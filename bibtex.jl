#module BibTex

#
# Example of a BibTex entry:
#
# @article{name,
#   author = {Lastname1, Firstname1 and Lastname2, Firstname2},
#   title = {Title of the article},
#   journal = {Fancy journal},
#   year = {1982},
#   volume = {36},
#   pages = {1000-1010},
#   url = {http://arxiv.org/abs/1801.00315},
#   doi = {10.1103/PhysRevB.90.155136}
#   }
#

mutable struct BTEntry
  ref_num::Int
  btype::String
  name::String
  authors ::Array{String,1}
  journal ::String
  title ::String
  doi::String
  url::String
  eprint::String
  year::String
  pages::String
  volume::String
  school::String

  function BTEntry(btype_::String,name_::String)
    return new(0,
               btype_,
               name_,
               [], #authors
               "", #journal
               "", #title
               "", #doi
               "", #url
               "", #eprint
               "",  #year
               "", #pages
               "",  #volume
               "")  #school
  end
end

function convertToMD(bt::BTEntry)::String
  md = ""
  if bt.btype == "phdthesis"
    for a in bt.authors
      md *= "$a: "
    end
    if bt.url != ""
      md *= "[_$(bt.title)_]($(bt.url))"
    else
      md *= "_$(bt.title)_"
    end
    md *= " (Doctoral Thesis)"
    if bt.school != ""
      md *= ", $(bt.school)"
    end
    if bt.year != ""
      md *= ", $(bt.year)"
    end
  else
    if bt.url != ""
      md *= "[_$(bt.title)_]($(bt.url))"
    else
      md *= "_$(bt.title)_"
    end
    for a in bt.authors
      md *= ", $a"
    end
    if bt.journal != ""
      md *= ", <i>"*bt.journal*"</i>"
      if bt.volume != ""
        md *= " <b>$(bt.volume)</b>"
      end
      if bt.pages != ""
        md *= ", $(bt.pages)"
      end
    end
    if bt.year != ""
      md *= " ($(bt.year))"
    end
    if bt.eprint != ""
      md *= ", "*bt.eprint
    end
  end
  return md
end

function getEntry(contents::String,start::Int)::String
  lev = 1
  n = start
  while (lev > 0 && n < length(contents))
    if (contents[n] == '{') lev += 1 end
    if (contents[n] == '}') lev -= 1 end
    #@show n,contents[n],lev
    n += 1
  end
  return contents[start:n-1]
end

function parseBibTex(fname::String)
  contents = open(fname) do file read(file,String) end

  entries = Dict{String,BTEntry}()

  btre = r"@(.+?){(.+?),"s

  function getField(re,source::String)::String
    if occursin(re,source)
      return strip(match(re,source).captures[1])
    end
    return ""
  end

  for m in eachmatch(btre,contents)
    btype = convert(String,m.captures[1])
    name = convert(String,m.captures[2])
    bt = BTEntry(btype,name)
    start = m.offset+length(m.match)
    entry = getEntry(contents,start)

    bt.btype = btype
    bt.title = getField(r"title\W*=\W*{(.+?)}"is,entry)
    bt.journal = getField(r"journal\W*=\W*{(.+?)}"is,entry)
    bt.volume = getField(r"volume\W*=\W*{(.+?)}"is,entry)
    bt.pages = getField(r"pages\W*=\W*{(.+?)}"is,entry)
    bt.year = getField(r"year\W*=\W*{(.+?)}"is,entry)
    bt.doi = getField(r"doi\W*=\W*{(.+?)}"is,entry)
    bt.eprint = getField(r"eprint\W*=\W*{(.+?)}"is,entry)
    bt.url = getField(r"url\W*=\W*{(.+?)}"is,entry)
    bt.school = getField(r"school\W*=\W*{(.+?)}"is,entry)

    all_authors = getField(r"author[s]*\W*=\W*{(.+?)}"is,entry)
    if all_authors != ""
      authors = split(all_authors,"and")
      for a in authors
        a = strip(a)
        rev = r"(\w+?), (.+)"
        if occursin(rev,a)
          m = match(rev,a)
          push!(bt.authors,"$(m.captures[2]) $(m.captures[1])")
        else
          push!(bt.authors,a)
        end
      end
    end

    entries[name] = bt
  end
  return entries
end

#export parseBibTex
#end
