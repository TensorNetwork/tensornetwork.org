#!/usr/bin/env -S julia --startup-file=no -O0
#
# Static site generator for Tensor Network website
#
# The flags in the line above roughly halve the build time:
# this short script spends most of its time compiling, so skipping
# the user's startup file and compiler optimizations pays off.
#

include("bibtex.jl")

#
# Like replace(s, re => f), but f receives the RegexMatch
# so that it can use the captures.
#
function replaceMatches(f,s::String,re::Regex)::String
  io = IOBuffer()
  pos = 1
  for m in eachmatch(re,s)
    print(io,SubString(s,pos,prevind(s,m.offset)))
    print(io,f(m))
    pos = m.offset+ncodeunits(m.match)
  end
  print(io,SubString(s,pos))
  return String(take!(io))
end

#
# Remove HTML comments, except for the <!--TOC--> marker
#
stripComments(md::String) = replace(md,r"<!--(?!TOC-->).*?-->"is => "")

#
# Process citations
#
function processCitations(md::String)::Tuple{String,Dict{String,Int}}
  citenums = Dict{String,Int}()
  res = replaceMatches(md,r"\\(cite|onlinecite){(.+?)}"s) do m
    cmd = m.captures[1]
    nums = sort([get!(citenums,strip(name),length(citenums)+1) => strip(name)
                 for name in split(m.captures[2],",")])
    if cmd == "cite"
      return join(["<a class=\"citation\" href=\"#$(name)_$(num)\">[$num]</a>" for (num,name) in nums])
    else
      return join(["<a class=\"online_citation\" href=\"#$(name)_$(num)\">$num</a>" for (num,name) in nums],", ")
    end
  end
  return (res,citenums)
end

#
# Process MathJax: math is replaced by placeholders so that
# cmark leaves it untouched, then restored afterwards
#
function processMathJax(md::String)
  mj_re = r"(\@\@.+?\@\@|\$.+?\$|\\begin{equation}.+?\\end{equation}|\\begin{equation\*}.+?\\end{equation\*}|\\begin{align}.+?\\end{align})"s
  mjlist = String[]
  res = replaceMatches(md,mj_re) do m
    push!(mjlist,m.match)
    return "(MathJax$(length(mjlist)))"
  end
  return (res,mjlist)
end

function restoreMathJax(html::String,mjlist::Vector{String})
  return replaceMatches(m -> mjlist[parse(Int,m.captures[1])],html,r"\(MathJax(\d+)\)")
end

#
# Process wiki-style links
#
function processWikiLinks(md::String,ifname::String)
  missing_links = String[]
  res = replaceMatches(md,r"\[\[(.+?)\|(.*?)\]\]") do m
    text = m.captures[1]
    target = String(m.captures[2])
    #If link has a "#" in it, split into target and sublink
    sublink = ""
    hash = findfirst('#',target)
    if !isnothing(hash)
      sublink = target[hash:end]
      target = target[1:prevind(target,hash)]
    end
    if isdir("src/"*target)
      return "[$text](/$target/$sublink)"
    elseif isfile("src/"*target*".md")
      return "[$text](/$target.html$sublink)"
    end
    push!(missing_links,target)
    return "[$text](unknown_file)"
  end
  if length(missing_links) > 0
    println("Missing/Incorrect Wiki Links in File $ifname:")
    for link in missing_links
      println("  $link")
    end
  end
  return res
end

#
# Process arxiv preprint links
#
function processArxivLinks(md::String)
  link_re = r"(arxiv|cond-mat|quant-ph|math|math-ph|physics)[/:]\W*?(\d+(?:\.\d+)*)"i
  return replaceMatches(md,link_re) do m
    prefix = m.captures[1]
    number = m.captures[2]
    if lowercase(prefix) == "arxiv"
      return "arxiv:[$number](https://arxiv.org/abs/$number)"
    end
    nbprefix = replace(prefix,"-" => "&#8209;") #non-breaking hypen
    return "<span>$nbprefix/[$number](https://arxiv.org/abs/$prefix/$number)</span>"
  end
end

function generateRefs(citenums,btentries,ifname)
  names = Vector{String}(undef,length(citenums))
  for (k,v) in citenums
    names[v] = k
  end
  rhtml = "<a name=\"toc_refs\"></a>\n"
  rhtml *= "## References\n"
  for (n,k) in enumerate(names)
    if haskey(btentries,k)
      bt = btentries[k]
      rhtml *= "$n. <a name=\"$(bt.name)_$(n)\"></a>"*convertToMD(bt)
      rhtml *= "\n"
    else
      println("Missing BibTeX entry \"$k\" cited in File $ifname")
    end
  end
  return rhtml
end

#
# Generate a Table of Contents if Requested
#
function generateTOC(md::String,has_refs::Bool)
  toc_re = r"<!--TOC-->"i
  occursin(toc_re,md) || return md
  toc = IOBuffer()
  print(toc,"\n\n\n<div class=\"toc\">\n")
  print(toc,"<b>Table of Contents</b><br/><br/>\n")
  lev = 1
  count = 0
  output = replaceMatches(md,r"\n(#+)(.*)") do m
    nlev = length(m.captures[1])
    (nlev > 1) || return m.match
    count += 1
    name = strip(replace(m.captures[2],r"\\(cite|onlinecite){.*?}" => ""))
    print(toc,"  "^nlev)
    (nlev > lev) && print(toc,"<ul>"^(nlev-lev))
    (nlev < lev) && print(toc,"</ul>"^(lev-nlev))
    print(toc,"<li><a href=\"#toc_$count\">$name</a></li>\n")
    lev = nlev
    return " <a name=\"toc_$count\"></a>\n"*m.match
  end
  if lev == 1 # no section headings: still open the top-level list
    print(toc,"<ul>")
  end
  print(toc,"</ul>"^max(lev-2,0))
  if has_refs
    print(toc,"<li><a href=\"#toc_refs\">References</a></li>\n")
  end
  print(toc,"</ul></div>\n\n\n")
  return replace(output,toc_re => String(take!(toc)))
end

function markdownToHTML(md::String)::String
  return open(`cmark --unsafe --smart`,"r+") do p
    @async begin
      write(p,md)
      close(p.in)
    end
    read(p,String)
  end
end

function backlinks(folders,f,base)::String
  (length(folders) > 0 || f != "index.md") || return "" #<-- don't show for main page
  out = "<tr><td></td><td class='backlinks'>"
  out *= "<a href='/'>main</a>/"
  tfold = "/"
  for fold in folders[1:end-1]
    tfold *= fold * "/"
    out *= "<a href=\"$tfold\">$fold</a>/"
  end
  if f != "index.md"
    if length(folders) > 0
      fold = folders[end]
      tfold *= fold * "/"
      out *= "<a href=\"$tfold\">$fold</a>/"
    end
    out *= base
  else
    (length(folders) > 0) && (out *= "$(folders[end])/")
  end
  return out*"</td></tr>"
end

header_prenav = read("header_prenav.html",String)
header_postnav = read("header_postnav.html",String)
footer = read("footer.html",String)
template_edit_footer = read("template_edit_footer.html",String)

idir = "src"
odir = "../tensornetwork.org"

# Source-only files that are not copied to the output
source_exts = [".bib",".tex"]

#
# Clear previous output (keeping hidden files such as .git)
#
mkpath(odir)
for f in readdir(odir)
  startswith(f,".") && continue
  rm(joinpath(odir,f); recursive=true)
end
cp("css",joinpath(odir,"css"))
cp("images",joinpath(odir,"images"))

for (root,dirs,files) in walkdir(idir)
  rel = relpath(root,idir)
  folders = (rel == ".") ? String[] : split(rel,"/")
  curro = joinpath(odir,rel)

  for d in dirs
    mkpath(joinpath(curro,d))
  end
  for f in files
    startswith(f,".") && continue
    (base,ext) = splitext(f)
    ifname = joinpath(root,f)
    if ext == ".md"
      mdstring = stripComments(read(ifname,String))

      btfile = joinpath(root,base*".bib")
      has_refs = isfile(btfile)

      mdstring = generateTOC(mdstring,has_refs)
      (mdstring,mjlist) = processMathJax(mdstring)
      mdstring = processWikiLinks(mdstring,ifname)

      (mdstring,citenums) = processCitations(mdstring)
      if has_refs
        mdstring *= generateRefs(citenums,parseBibTex(btfile),ifname)
      end

      mdstring = processArxivLinks(mdstring)

      html = restoreMathJax(markdownToHTML(mdstring),mjlist)

      edit_link = "https://github.com/TensorNetwork/tensornetwork.org/edit/master/"*ifname
      open(joinpath(curro,base*".html"),"w") do of
        print(of,header_prenav)
        print(of,backlinks(folders,f,base))
        print(of,header_postnav)
        print(of,html)
        print(of,replace(template_edit_footer,"{github_link}" => edit_link))
        print(of,footer)
      end
    elseif !(ext in source_exts)
      cp(ifname,joinpath(curro,f); force=true,follow_symlinks=true)
    end
  end
end
