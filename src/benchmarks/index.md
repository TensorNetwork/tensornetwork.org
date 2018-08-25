# Tensor Operation Benchmarks

## Synthetic Benchmark

This benchmark consists of 1000 random tensor contractions with very different number of modes, extents, and permutation of the modes, stressing the performance of any tensor contraction implementation across a wide range of use cases; from very bandwidth-bound all the way to very compute-bound TCs.  Moreover, tensor contractions that natively map to a pure matrix-matrix multiplication are omitted (i.e., only "pure" tensor contractions).  

The benchmark is expressed via the Einstein notation and is found at [[here|randomTCs.dat]]

An exemplary performance plot that uses this benchmark is shown [[here|https://github.com/springer13/tcl#performance-results]]


## Real-world Benchmark (coming soon)

