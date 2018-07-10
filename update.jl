header = """
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>TensorNetwork</title>
    <meta http-equiv="content-language" content="en" />
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <link href='https://fonts.googleapis.com/css?family=Inconsolata:400,700' rel='stylesheet' type='text/css'>
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({tex2jax: {inlineMath: [['\$','\$'] ]}});
    </script>
    <script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML">
    </script>
</head>

<body>
"""

footer = """
</body>
</html>
"""

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
    print(of,header)
    print(of,html)
    print(of,footer)
    close(of)
  end
end
