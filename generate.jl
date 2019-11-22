#
# Static site generator for Tensor Network website
# 

include("bibtex.jl")

function pause() 
  a = readline(STDIN)
  (length(a) == 0) && return
  (a[1]=='q') && exit(0)
end


#
# Process citations
# 
function processCitations(html::String)::Tuple{String,Dict{String,Int}}
  cite_re = r"\\(cite|onlinecite){(.+?)}"s
  citenums = Dict{String,Int}()
  res = String("")
  pos = 1
  match = false
  counter = 1
  for m in eachmatch(cite_re,html)
    match = true
    res *= html[pos:m.offset-1]
    names = split(convert(String,m.captures[2]),",")
    namenums = Tuple{Int,String,String}[]
    for name in names
      name = strip(name)
      if haskey(citenums,name)
        num = citenums[name]
      else
        citenums[name] = counter
        num = counter
        counter += 1
      end
      push!(namenums,(num,name,convert(String,m.captures[1])))
    end
    sort!(namenums, by = x -> x[1])
    for i in 1:length(namenums)
      (num,name,cmd) = namenums[i]
      if cmd == "cite"
        res *= "<a class=\"citation\" href=\"#$(name)_$(num)\">[$num]</a>"
      elseif cmd == "onlinecite"
        res *= "<a class=\"online_citation\" href=\"#$(name)_$(num)\">$num</a>"
        if i < length(namenums) res *= ", " end
      end
    end
    pos = m.offset+length(m.match)
  end
  if !match 
    return (html,citenums)
  else
    res *= html[pos:end]
  end
  return (res,citenums)
end

#
# Process MathJax
# 
function processMathJax(html::String)
  mj_re = r"(\@\@.+?\@\@|\$.+?\$|\\begin{equation}.+?\\end{equation}|\\begin{equation\*}.+?\\end{equation\*}|\\begin{align}.+?\\end{align})"s
  mjlist = String[]
  res = ""
  pos = 1
  match = false
  for m in eachmatch(mj_re,html)
    match = true
    res *= html[pos:m.offset-1]
    #res *= "\n\n<div>"*m.captures[1]*"</div>\n\n"
    push!(mjlist,m.captures[1])
    res *= "(MathJax$(length(mjlist)))"
    pos = m.offset+length(m.match)
  end
  if match 
    res *= html[pos:end]
  else
    res = html
  end
  return (res,mjlist)
end

function restoreMathJax(html::String,mjlist::Array{String,1})
  res = html
  for (n,mj) in enumerate(mjlist)
    res = replace(res,"(MathJax$n)" => mj)
  end
  return res
end

#
# Process wiki-style links
# 
function processWikiLinks(html::String,ifname::String)
  link_re = r"\[\[(.+?)\|(.*?)\]\]"
  sub_re = r"(.*?)(#.*)"
  missing_links = String[]
  res = ""
  pos = 1
  match = false
  for m in eachmatch(link_re,html)
    match = true
    res *= html[pos:m.offset-1]
    target = convert(String,m.captures[2])

    #If link has a "#" in it, split into target and sublink
    sublink = ""
    for sm in eachmatch(sub_re,target)
      target = convert(String,sm.captures[1])
      sublink = convert(String,sm.captures[2])
    end

    if isdir("src/"*target)
      res *= "["*m.captures[1]*"](/"*target*"/$sublink)"
    elseif isfile("src/"*target*".md")
      res *= "["*m.captures[1]*"](/"*target*".html$sublink)"
    else
      res *= "["*m.captures[1]*"](unknown_file)"
      push!(missing_links,target)
    end
    pos = m.offset+length(m.match)
  end
  if length(missing_links) > 0
    println("Missing/Incorrect Wiki Links in File $ifname:")
    for link in missing_links
      println("  $link")
    end
  end
  if !match 
    return html 
  else
    res *= html[pos:end]
  end
  return res
end

#
# Process arxiv preprint links
# 
function processArxivLinks(html::String)
  link_re = r"(arxiv|cond-mat|quant-ph|math|math-ph|physics)[/:]\W*?([\d\.]+)"i
  res = ""
  pos = 1
  match = false
  for m in eachmatch(link_re,html)
    match = true
    res *= html[pos:m.offset-1]
    prefix = m.captures[1]
    number = m.captures[2]
    if lowercase(prefix) == "arxiv"
      res *= "arxiv:[$number](https://arxiv.org/abs/$number)"
    else
      nbprefix = replace(prefix,"-" => "&#8209;") #non-breaking hypen
      res *= "<span>$nbprefix/[$number](https://arxiv.org/abs/$prefix/$number)</span>"
    end
    pos = m.offset+length(m.match)
  end
  if !match 
    return html 
  else
    res *= html[pos:end]
  end
  return res
end
function processCondMatLinks(html::String)
  link_re = r"arxiv:\W*?(\d+?\.\d+)"
  res = ""
  pos = 1
  match = false
  for m in eachmatch(link_re,html)
    match = true
    res *= html[pos:m.offset-1]
    res *= "arxiv:["*m.captures[1]*"](https://arxiv.org/abs/"*m.captures[1]*")"
    pos = m.offset+length(m.match)
  end
  if !match 
    return html 
  else
    res *= html[pos:end]
  end
  return res
end

function printEditFooter(of::IOStream,fname::String)
  template_edit_footer = open("template_edit_footer.html") do file read(file,String) end
  link = "https://github.com/TensorNetwork/tensornetwork.org/edit/master/"*fname
  out = replace(template_edit_footer,r"{github_link}" => link)
  print(of,out)
end

function generateRefs(citenums,btentries)
  keys = Array{String,1}(undef,length(citenums))
  for (k,v) in citenums
    keys[v] = k
  end
  rhtml = "<a name=\"toc_refs\"></a>\n"
  rhtml *= "## References\n"
  for (n,k) in enumerate(keys)
    if haskey(btentries,k)
      bt = btentries[k]
      rhtml *= "$n. <a name=\"$(bt.name)_$(n)\"></a>"*convertToMD(bt)
      rhtml *= "\n"
    end
  end
  return rhtml
end

#
# Generate a Table of Contents if Requested
# 
function generateTOC(input::String,has_refs::Bool)
  toc_re = r"<!--TOC-->"is
  if occursin(toc_re,input)
    output = ""
    toc_html = "\n\n\n<div class=\"toc\">\n"
    toc_html *= "<b>Table of Contents</b><br/><br/>\n"
    lev = 1
    sec_re = r"\n(#+)(.*)"
    count = 1
    pos = 1
    for m in eachmatch(sec_re,input)
      nlev = length(m.captures[1])
      output *= input[pos:m.offset-1]
      if nlev > 1
        output *= " <a name=\"toc_$count\"></a>\n"
        name = strip(convert(String,m.captures[2]))
        name = replace(name,r"\\cite{.*?}" => "")
        name = replace(name,r"\\onlinecite{.*?}" => "")
        for n in 1:nlev toc_html *= "  " end
        if nlev == lev+1
          toc_html *= "<ul>"
        elseif nlev == lev-1
          toc_html *= "</ul>"
        end
        toc_html *= "<li><a href=\"#toc_$count\">$name</a></li>\n"
        lev = nlev
        count += 1
      end
      output *= m.match
      pos = m.offset+length(m.match)
    end
    while lev != 2
      lev -= 1
      toc_html *= "</ul>"
    end
    if has_refs 
      toc_html *= "<li><a href=\"#toc_refs\">References</a></li>\n"
    end
    toc_html *= "</ul></div>\n\n\n"
    output *= input[pos:end]
    #println(toc_html)
    return replace(output,toc_re => toc_html)
  end
  return input
end

header_prenav = open("header_prenav.html") do file read(file,String) end
header_postnav = open("header_postnav.html") do file read(file,String) end
footer = open("footer.html") do file read(file,String) end

idir = "src"
odir = "../tensornetwork.org"
run(`mkdir -p $odir`)
run(`rm -f $odir/\*`)
run(`cp -r css $odir/`)
run(`cp -r images $odir/`)
run(`cp -r htaccess_file $odir/.htaccess`)
run(`chmod 644 $odir/.htaccess`)

for (root,dirs,files) in walkdir(idir)
  folderstring = root[4:end]
  curri = idir * folderstring
  curro = odir * folderstring

  folders = split(folderstring,"/")[2:end]

  for d in dirs
    run(`mkdir -p $curro/$d`)
  end
  for f in files
    (f[1]=='.') && continue
    (base,ext) = split(f,".")
    ifname = curri*"/"*f
    if ext == "md"
      ofname = curro*"/"*base*".html"
      mdstring = read(ifname,String)

      btfile = curri*"/"*base*".bib"
      has_refs = isfile(btfile)

      if has_refs
        if mtime(ofname) > mtime(ifname) && mtime(ofname) > mtime(btfile)
          println("Skipping $(ifname), $(btfile), they are older than $(ofname).")
          continue
        end
      else
        if mtime(ofname) > mtime(ifname)
          println("Skipping $(ifname), it is older than $(ofname).")
          continue
        end
      end
      mdstring = generateTOC(mdstring,has_refs)
      (mdstring,mjlist) = processMathJax(mdstring)
      mdstring = processWikiLinks(mdstring,ifname)

      (mdstring,citenums) = processCitations(mdstring)
      btfile = curri*"/"*base*".bib"
      if has_refs
        bt = parseBibTex(btfile)
        refmd = generateRefs(citenums,bt)
        mdstring *= refmd
      end

      mdstring = processArxivLinks(mdstring)


      open("_tmp_file.md","w") do tf
        print(tf,mdstring)
      end
      html = read(`cmark --unsafe --smart _tmp_file.md`,String)
      #html = read(`python2.7 -m markdown _tmp_file.md`,String)

      html = restoreMathJax(html,mjlist)

      #
      # Put in backlinks
      #
      open(ofname,"w") do of
        print(of,header_prenav)

        if length(folders) > 0 || f!="index.md" #<-- don't show for main page
          print(of,"<tr><td></td><td class='backlinks'>")
          print(of,"<a href='/'>main</a>/")
          tfold = "/"
          for fold in folders[1:end-1]
            tfold *= fold * "/"
            print(of,"<a href=\"$tfold\">$fold</a>/")
          end
          if f!="index.md" 
            if length(folders) > 0 
                fold = folders[end]
                tfold *= fold * "/"
                print(of,"<a href=\"$tfold\">$fold</a>/")
            end
            print(of,base)
          else
            (length(folders) > 0) && print(of,"$(folders[end])/")
          end
          print(of,"</td></tr>")
        end
        print(of,header_postnav)
        print(of,html)
        printEditFooter(of,ifname)
        print(of,footer)
      end
      run(`rm -f _tmp_file.md`)

    #elseif ext == "png" || ext == "jpg"
    else
      run(`cp $ifname $(curro*"/"*f)`)
    end
  end
end

