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
# Field values must be enclosed in braces; nested braces are allowed
# and are removed from the output.

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
    if (bt.url != "" || bt.doi != "")
      if bt.url != ""
        md *= "[_$(bt.title)_]($(bt.url))"
      else
        md *= "[_$(bt.title)_](https://dx.doi.org/$(bt.doi))"
      end
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

#
# Return the text inside the braces that open at byte index `open`,
# skipping over nested pairs of braces.
#
function bracedContents(s::AbstractString,open::Int)::String
  depth = 0
  i = open
  while i <= ncodeunits(s)
    c = s[i]
    if c == '{'
      depth += 1
    elseif c == '}'
      depth -= 1
      (depth == 0) && return s[nextind(s,open):prevind(s,i)]
    end
    i = nextind(s,i)
  end
  return s[nextind(s,open):end]
end

const latex_accents = Dict('"' => '\u0308', '\'' => '\u0301', '`' => '\u0300',
                           '^' => '\u0302', '~' => '\u0303')

#
# Convert LaTeX accents such as \"o, \'{e}, or \~n into Unicode characters
#
function latexToUnicode(s::AbstractString)::String
  s = replace(s,r"\\ss(?![A-Za-z])" => "ß")
  s = replace(s,r"\\([\"'`^~])\s*\{?\\?([A-Za-z])\}?" => function(m)
                letter = m[findlast(isletter,m)]
                return string(letter,latex_accents[m[2]])
              end)
  return Base.Unicode.normalize(s,:NFC)
end

function getField(name::String,entry::String;latex::Bool=true)::String
  m = match(Regex("\\b$(name)\\s*=\\s*(\\{)","i"),entry)
  isnothing(m) && return ""
  value = bracedContents(entry,m.offsets[1])
  latex && (value = latexToUnicode(value))
  return strip(replace(value,r"[{}]" => ""))
end

function parseBibTex(fname::String)
  contents = read(fname,String)

  entries = Dict{String,BTEntry}()

  for m in eachmatch(r"@(\w+)\s*(\{)\s*([^,\s]+)\s*,",contents)
    btype = String(m.captures[1])
    name = String(m.captures[3])
    bt = BTEntry(btype,name)
    entry = bracedContents(contents,m.offsets[2])

    bt.title = getField("title",entry)
    bt.journal = getField("journal",entry)
    bt.volume = getField("volume",entry)
    bt.pages = getField("pages",entry)
    bt.year = getField("year",entry)
    bt.doi = getField("doi",entry;latex=false)
    bt.eprint = getField("eprint",entry;latex=false)
    bt.url = getField("url",entry;latex=false)
    bt.school = getField("school",entry)

    all_authors = getField("authors?",entry)
    if all_authors != ""
      authors = split(all_authors," and")
      for a in authors
        a = strip(a)
        rev = r"(.+?), (.+)"
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
