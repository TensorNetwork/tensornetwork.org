The Tensor Network is an *open-source review article* about tensor network algorithms,
theory, and software.

This repository contains both the content for the site (in the src/ folder) and 
the program (generator.jl) for generating the website (https://tensornetwork.org).

Local Content Generation
========================

To generate the website locally from a checked-out git repository,
follow these steps:

- install the Julia language binary from
  [julialang.org](https://julialang.org/downloads/). Version 1.2
  works, version 0.4.5 doesn't.
- install cmark from [the github repository](https://github.com/commonmark/cmark).
- make sure that the git repository is _not_ cloned into a folder
  `tensornetwork.org`, if necessary, rename it:

````
    $ mv tensornetwork.org tensornetwork.org-git
````

- inside the git repository, run

````
    $ cd tensornetwork.org-git
    $ julia generate.jl
````

- a new folder `tensornetwork.org` will be generated one level up
- inside that folder, start a tiny HTTP server to serve the files locally:

````
    $ cd ../tensornetwork.org
    $ python3 -m http.server 8080
````
