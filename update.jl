#
# Static site generator for Tensor Network website
# 

#
# Process citations
# 
function processCitations(html::String)
  cite_re = r"\\cite{(.+?)}"
  res = ""
  pos = 1
  match = false
  num = 1
  for m in eachmatch(cite_re,html)
    match = true
    res *= html[pos:m.offset-1]
    res *= "<a class=\"citation\" href=\""*m.captures[1]*"\">[$num]</a>"
    num += 1
    pos = m.offset+length(m.match)
  end
  if !match 
    return html 
  else
    res *= html[pos:end]
  end
  return res
end

#
# Process MathJax
# 
function processMathJax(html::String)
  imj_re = r"(\@\@.+?\@\@)"s
  res = ""
  pos = 1
  match = false
  for m in eachmatch(imj_re,html)
    match = true
    res *= html[pos:m.offset-1]
    res *= "\n\n<div>"*m.captures[1]*"</div>\n\n"
    pos = m.offset+length(m.match)
  end
  if !match 
    return html 
  else
    res *= html[pos:end]
  end
  return res
end

#
# Process wiki-style links
# 
function processWikiLinks(html::String)
  link_re = r"\[\[(.+?)\|(.*?)\]\]"
  res = ""
  pos = 1
  match = false
  for m in eachmatch(link_re,html)
    match = true
    res *= html[pos:m.offset-1]
    if isdir("src/"*m.captures[2])
      res *= "["*m.captures[1]*"](/"*m.captures[2]*")"
    elseif isfile("src/"*m.captures[2]*".md")
      res *= "["*m.captures[1]*"](/"*m.captures[2]*".html)"
    else
      res *= "["*m.captures[1]*"](unknown_file)"
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

#
# Process wiki-style links
# 
function processArxivLinks(html::String)
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

header_prenav = open("header_prenav.html") do file readstring(file) end
header_postnav = open("header_postnav.html") do file readstring(file) end
footer = open("footer.html") do file readstring(file) end

idir = "src"
odir = "../tensornetwork.org"
run(`mkdir -p $odir`)
run(`cp -r css $odir/`)
run(`cp -r images $odir/`)

for (root,dirs,files) in walkdir(idir)
  curri = idir * root[4:end]
  curro = odir * root[4:end]
  for d in dirs
    run(`mkdir -p $curro/$d`)
  end
  for f in files
    (f[1]=='.') && continue
    (base,ext) = split(f,".")
    ifname = curri*"/"*f
    if ext == "md"
      ofname = curro*"/"*base*".html"
      mdstring = readstring(`cat $ifname`)
      mdstring = processMathJax(mdstring)
      mdstring = processWikiLinks(mdstring)
      mdstring = processArxivLinks(mdstring)
      mdstring = processCitations(mdstring)
      open("_tmp_file.md","w") do tf
        print(tf,mdstring)
      end
      html = readstring(`cmark _tmp_file.md`)
      open(ofname,"w") do of
        print(of,header_prenav)
        print(of,header_postnav)
        print(of,html)
        print(of,footer)
      end
      run(`rm -f _tmp_file.md`)
    elseif ext == "png" || ext == "jpg"
      run(`cp $ifname $(curro*"/"*f)`)
    end
  end
end

