# Tensor Operation Benchmarks

## Synthetic Benchmark

This benchmark consists of 1000 random tensor contractions. The tensor contractions exhibit very different number of modes, extents, and permutation of the modes to stress the performance of any tensor contraction implementation across a wide range of use cases, ranging from very bandwidth-bound TCs all the way to very compute-bound TCs.  Moreover, tensor contractions that natively map to a direct matrix-matrix multiplication are omitted (i.e., only "pure" tensor contractions).  

The benchmark is expressed via the Einstein notation and is found at [[here|randomTCs.dat]].

An exemplary performance plot that uses this benchmark is shown [[here|https://github.com/springer13/tcl#performance-results]].


## Real-world Benchmark (coming soon)

