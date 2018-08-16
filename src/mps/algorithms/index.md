# Algorithms for Matrix Product States / Tensor Trains

A wide variety of efficient algorithms have been developed
for [[MPS/TT tensor networks|mps]].

## Elementary MPS/TT Algorithms

- [[Retrieving a Single MPS/TT Component|mps/index#component]]
- [[Inner Product of Two MPS/TT|mps/index#innerprod]]
- [[Compression of MPS/TT|mps/index#compression]] (Using Density Matrix Algorithm)

## Solving Linear Equations

The following algorithms involve solving equations such as $A x = \lambda x$
or $A x = b$ where $x$ is a tensor in MPS/TT form.

- [[DMRG &mdash; Density Matrix Renormalization Group|mps/algorithms/dmrg]].
  Adaptive algorithm for finding eigenvectors in MPS form.

## Summing MPS/TT networks

The following are algorithms for summing two or more MPS/TT networks
and approximating the result by a single MPS/TT.

- [[Density Matrix Algorithm|mps/algorithms/dm_sum]] (coming soon)
- [[Direct Algorithm|mps/algorithms/sum_direct]] (coming soon)

## Multiplying a MPS/TT by an MPO

The following are algorithms for multiplying a given MPS/TT tensor network
by an MPO tensor network, resulting in a new MPS/TT that approximates
the result.

- [[Density Matrix Algorithm|mps/algorithms/dm_mpo]] (coming soon)
- [[Fitting Algorithm|mps/algorithms/fitting_mpo]] (coming soon)
- [[Zip-Up Algorithm|mps/algorithms/zip_up_mpo]] (coming soon)

## Time Evolution Algorithms

One reason MPS are very useful in quantum physics applications
is that they can be efficiently evolved in real or imaginary time.
This capability is useful for studying quantum dynamics
and thermalization, and directly simulating finite-temperature
systems.

- [[Trotter Gate Time Evolution|mps/algorithms/trotter_tevol]] (coming soon)
- [[Time-Step Targeting Method|mps/algorithms/targeting_tevol]] (coming soon)
- [[Time-Dependent Variational Principle (TDVP)|mps/algorithms/tdvp_tevol]] (coming soon)
- [[MPO Time Evolution|mps/algorithms/mpo_tevol]] (coming soon)
- [[Krylov Time Evolution|mps/algorithms/krylov_tevol]] (coming soon)



