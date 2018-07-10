header_prenav = open("header_prenav") do file readstring(file) end
footer = open("footer") do file readstring(file) end

idir = "src"
odir = "pages"
run(`mkdir -p $odir`)

for (root,dirs,files) in walkdir(idir)
  curri = idir * root[4:end]
  curro = odir * root[4:end]
  for d in dirs
    run(`mkdir -p $curro/$d`)
  end
  for f in files
    (f[1]=='.') && continue
    (base,ext) = split(f,".")
    (ext!="md") && continue
    ifname = curri*"/"*f
    ofname = curro*"/"*base*".html"
    html = Base.Markdown.html(Markdown.parse_file(ifname))
    of = open(ofname,"w")
    print(of,header_prenav)
    print(of,html)
    print(of,footer)
    close(of)
  end
end
