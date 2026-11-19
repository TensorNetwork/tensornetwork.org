The Tensor Network is an *open-source review article* about tensor network algorithms,
theory, and software.

This repository contains both the content for the site (in the src/ folder) and 
the program (generate.jl) for generating the website (https://tensornetwork.org).

Deployment
==========

The site is hosted on GitHub Pages. Every push to `master` (including merged
pull requests) runs the workflow in `.github/workflows/pages.yml`, which runs
`generate.jl` and deploys the result, usually within a few minutes.
Pull requests are built but not deployed, so build errors show up as a failed
check on the pull request.

The page shown for missing URLs is generated from `src/404.md`.

Local Content Generation
========================

To generate the website locally from a checked-out git repository,
follow these steps:

- install the Julia language binary from
  [julialang.org](https://julialang.org/downloads/).
- install cmark from [the github repository](https://github.com/commonmark/cmark).
- make sure that the git repository is _not_ cloned into a folder
  `tensornetwork.org`, if necessary, rename it:

````
    $ mv tensornetwork.org tensornetwork.org-git
````

- inside the git repository, run

````
    $ cd tensornetwork.org-git
    $ ./generate.jl

  (equivalent to `julia --startup-file=no -O0 generate.jl`; the
  flags roughly halve the build time)
````

- a new folder `tensornetwork.org` will be generated one level up
  (its previous contents, except hidden files such as `.git`, are deleted first)
- inside that folder, start a tiny HTTP server to serve the files locally:

````
    $ cd ../tensornetwork.org
    $ python3 -m http.server 8080
````
