## Graphical Interfaces and Visualization

* <a href="https://www.tensortrace.com">TensorTrace</a><br/>
  TensorTrace is an application that facilitates the design and 
  implementation of tensor network algorithms. Among many other features,
  TensorTrace can automatically determine the optimal contraction sequence and 
  cost scaling for each network, and generate code (in MATLAB, Python or Julia languages) 
  for contracting the tensor networks numerically.
 
## High-Level Tensor Software

(Listed in alphabetical order by project name.)

* <a href="https://block2.readthedocs.io/en/latest/">block2</a> (Python/C++)<br/>
  **block2** is an efficient and scalable implementation of
  the Density Matrix Renormalization Group (DMRG) for quantum chemistry.
  The code is highly optimized for production level calculation of realistic systems.
  Like many quantum chemistry packages,
  it can be used by reading parameters and instructions from a formatted input file.

* <a href="http://solomon2.web.engr.illinois.edu/ctf/">Cyclops Tensor Framework</a> (C++)<br/>
  This library provides automatic parallelization of operations on multidimensional 
  (sparse) arrays. Cyclops supports general tensor sparsity, so it is 
  possible to define graph algorithms with the use of sparse adjacency matrices.

* <a href="https://kaihsinwu.gitlab.io/Cytnx_doc/Intro.html">Cytnx</a> (Python/C++)<br/>
  Cytnx is a library designed for Quantum/classical Physics simulations. 
  Most of Cytnx APIs share very similar interfaces as the most common and popular 
  libraries: numpy/scipy/pytorch. Cytnx also supports multi-devices (CPUs/GPUs) 
  directly on the base container level. For algorithms in physics, Cytnx provides powerful 
  tools such as UniTensor, Network, Bond, Symmetry etc. These objects are built on 
  top of Tensor objects.

* <a href="https://kth-dmrg.readthedocs.io/en/latest/installation.html">DMRG++</a> (C++)<br/>
  This library includes 4 algorithms for finding eigenstates of 1D quantum spin chains:
  - xDMRG: Excited state DMRG. Finds highly excited eigenstates of finite systems.
  - fDMRG: finite DMRG. Finds the ground state of finite systems.
  - iDMRG: infinite DMRG. Finds the ground state of infinite translationally invariant systems.
  - iTEBD: Imaginary Time Evolving Block Decimation.
  Finds the ground state of infinite translationally
  invariant systems from a quench in imaginary time.

* <a href="https://github.com/romeric/Fastor">Fastor</a> (C++)<br/>
  Fastor is a stack-based high performance tensor (multi-dimensional array) library written 
  in modern C++ [C++11/14/17] with powerful in-built tensor algebraic functionalities 
  (tensor contraction, permutation, reductions, special tensor groups etc). 

* <a href="https://github.com/yhtang/FunFact">FunFact</a> (Python)<br/>
  FunFact enables flexible and concise expressions of tensor algebra through a hybrid
  NumPy/Einstein notation-based syntax. A particular emphasis is on automating the design
  of matrix and tensor factorization models. It’s areas of applications include quantum
  circuit synthesis, tensor decomposition, and neural network compression. FunFact is
  GPU-ready and easily parallizable thanks to the modern linear algebra backends such as
  JAX/TensorFlow and PyTorch that it builds on top of.

* <a href="https://itensor.org">ITensor</a> (Julia, C++)<br/>
  ITensor is a library for tensor networks where tensor indices carry extra information
  and matching tensor indices automatically contract. Also features MPS and MPO algorithms,
  such as DMRG, and quantum number block-sparse tensors.

* <a href="https://arxiv.org/abs/1402.0939">NCON</a> (MATLAB)<br/>
  NCON (Network Contractor) is a MATLAB routine which can be used for computing
  a broad class of tensor network diagrams in an efficient and convenient way.

* <a href="https://github.com/Drachier/PyTreeNet?tab=readme-ov-file">PyTreeNet</a> (Python)<br/>
  PyTreeNet is a Python implementation of tree tensor networks with a focus on the simulation
  of quantum systems admitting a tree topology.
  
* <a href="https://quimb.readthedocs.io/en/latest/">QUIMB</a> (Python)<br/>
  python library for contracting tensors and tensor networks,
  with support for matrix product states and algorithms, and advanced
  features such as determination of the optimal ordering of tensor contractions.\cite{quimb}
  
* <a href="https://github.com/PGelss/scikit_tt">Scikit-TT</a> (Python)<br/>
  Scikit-TT is a Python library for applying the tensor-train (TT) format 
  to various numerical problems in order to reduce the memory consumption and computational
  cost compared to classical tensor approaches significantly.

* <a href="https://susmost.com">SuSMoST</a><br/>
  SuSMoST (Surface Science Modelling and Simulation Toolkit) is meant to build and study
  classical lattice models of adsorption, such as Langmuir, Ising, Potts, or hard-core models.
  SuSMoST automatically builds a tensor network representation of a lattice model from
  samples of adsorption complexes. Several versions of the [[TRG|trg]] algorithm are
  implemented in SuSMoST.
  They can be used to compute the partition function and its derivatives
  for simulated lattice models.

* <a href="https://syten.eu">SyTen</a> (C++) <br/>
  A symmetry-protected tensor networks toolkit in C++,
  with a set of standard matrix-product state, binary tree-tensor network states 
  and infinite projected entangled pair state utilities included.

* <a href="https://github.com/issp-center-dev/TeNeS">TeNeS</a> (C++)<br/>
  TeNeS is a package for calculating many-body quantum states on two-dimensional
  lattices based on iTPS (iPEPS). It can treat various spin and boson Hamiltonians
  through comprehensive input parameters, while we need a simple input format for
  predefined lattices and models. Furthermore, it supports MPI/OpenMP hybrid parallelization
  for supercomputers.
 
* <a href="https://github.com/anthony-nouy/tensap">tensap</a> (Python)<br/>
  A Python package for the approximation of functions and tensors.
  `tensap` features low-rank tensors (including canonical, tensor-train 
  and tree-based tensor formats or tree tensor networks),
  sparse tensors, polynomials, and allows the plug-in of other approximation tools.
  It provides different approximation methods based on interpolation,
  least-squares projection or statistical learning.

* <a href="https://github.com/Jutho/TensorKit.jl">TensorKit</a> (Julia)<br/>
  A Julia package for large-scale tensor computations, with a hint of category theory.
  TensorKit.jl aims to be a generic package for working with tensors as they appear throughout
  the physical sciences. Currently, most effort is oriented towards tensors as they appear in
  the context of quantum many body physics and in particular the field of tensor networks.
  Such tensors often have large dimensions and take on a specific structure when symmetries
  are present. To deal with generic symmetries, we employ notations and concepts from category
  theory all the way down to the definition of a tensor. At the same time, TensorKit.jl
  focuses on computational efficiency and performance.

* <a href="https://github.com/tenpy/tenpy">TenPy</a> (Python)<br/>
  Tensor Network Python (TeNPy) is a Python library for the simulation of 
  quantum systems with tensor networks. The philosophy of this library is 
  to get a new balance of a good readability and usability for new-comers, 
  and at the same time powerful algorithms and fast development of new 
  algorithms for experts.\cite{tenpy}

* <a href="https://www.tensorlab.net">TensorLab</a> (MATLAB)<br/>
  Tensorlab is a MATLAB toolbox for rapid prototyping of tensor
  decompositions with structured factors. By mixing different types
  of decompositions and factor structures, a vast amount of factorizations
  can be computed.

* <a href="http://tensorly.org/">TensorLy</a> (Python)<br/>
  A python library offering a high-level API for tensor methods and 
  deep tensorized neural networks. TensorLy's backend system allows users to 
  perform computations with NumPy, MXNet, PyTorch, TensorFlow, and CuPy
  in order to be scalable on both CPU and GPU.\cite{tensorly}

* <a href="https://jutho.github.io/TensorOperations.jl/stable/">TensorOperations</a> (Julia) <br/>
  Julia package for tensor contractions and related operations.
  Offers fast tensor operations using a convenient Einstein index notation,
  as well as optimizing pairwise contraction order, the "ncon" function
  for contracting groups of tensors or tensor networks, GPU support,
  and other features.

* <a href="https://github.com/google/TensorNetwork">TensorNetwork</a> (Python)<br/>
  python library for easy and efficient contraction of tensor
  networks, supporting multiple powerful backends.

* <a href="http://www.tensortoolbox.org/">Tensor Toolbox</a> (MATLAB)<br/>
  The Tensor Toolbox is a MATLAB library supporting multiple tensor types, 
  including dense, sparse, and symmetric tensors as well as specially 
  structured tensors, such as Tucker format,
  and others. Tensors can be manipulated using MATLAB's object-oriented features.

* <a href="https://github.com/lanaperisa/TensorToolbox.jl">TensorToolbox.jl</a> (Julia)<br/>
  Julia package for tensors. Includes functionality for dense tensors, and tensors in the Tucker,
  Kruskal (CP), Hierarchical Tucker, and Tensor Train formats.
  Follows the functionality of MATLAB Tensor toolbox and Hierarchical Tucker Toolbox.
  Additionally, it contains algorithms from the paper Recompression of Hadamard Products of 
  Tensors in Tucker Format by D. Kressner and L. Periša.
   
* <a href="https://github.com/ValeevGroup/tiledarray">TiledArray</a> (C++)<br/>
  TiledArray is a massively-parallel, block-sparse tensor framework written in C++.
  It is a scalable, block-sparse tensor framework for rapid composition of high-performance 
  tensor arithmetic, appearing for example in many-body quantum mechanics. It allows 
  users to compose tensor expressions of arbitrary complexity in native C++ code that 
  closely resembles the standard mathematical notation. The framework is designed to 
  scale from a single multicore computer to a massive distributed-memory multiprocessor.

* <a href="https://github.com/jemisjoky/TorchMPS">TorchMPS</a> (Python)<br/>
  TorchMPS is a framework for working with matrix product state (also known 
  as MPS or tensor train) models within Pytorch. Our MPS models are written as 
  Pytorch Modules, and can simply be viewed as differentiable black boxes 
  that are interchangeable with standard neural network layers. However, 
  the rich structure of MPS's allows for more interesting behavior...

* <a href="https://github.com/ion-g-ion/torchTT/tree/main">TorchTT</a> (Python)<br/>
  Tensor-Train decomposition package written in Python on top of pytorch. Supports GPU 
  acceleration and automatic differentiation. It also contains routines for solving linear 
  systems in the TT format and performing adaptive cross approximation 
  (the AMEN solver/cross interpolation is inspired form the MATLAB TT-Toolbox). 
  Some routines are implemented in C++ for an increased execution speed.

* <a href="https://github.com/oseledets/ttpy">ttpy</a> (Python)<br/>
  Same as <a href="https://github.com/oseledets/TT-Toolbox">TT-Toolbox</a>
  but in Python.

* <a href="https://github.com/oseledets/TT-Toolbox">TT-Toolbox</a> (MATLAB)<br/>
  MATLAB implementation of basic operations with tensors in TT-format,
  including TT tensor and TT matrix formats, fast rounding procedures,
  methods for solutions of linear systems and eigenvalue problems,
  and the TT-cross method.

* <a href="https://github.com/QuantumLiquids/UltraDMRG">UltraDMRG</a> (C++)<br/>
  This library is specifically designed to tackle two-dimensional
  strongly correlated electron systems. It offers
  MPI parallelization of Density Matrix Renormalization Group,
  MPI parallelization of MPS-based time-dependent variational principle algorithm,
  finite-temperature calculation.

* <a href="https://gitlab.com/uni10/uni10/">Uni10</a> (C++)<br/>
  Universal Tensor Library, an open-source C++ library designed for 
  the development of tensor network algorithms. Provides a Network class to process 
  and store the details of the graphical representations of the networks,
  and supports quantum number block-sparse tensors.

* <a href="https://libxerus.org">Xerus</a> (C++)<br/>
  The Xerus library is a general purpose library for numerical 
  calculations with higher order tensors, Tensor-Train 
  Decompositions / Matrix Product States and general Tensor Networks. 
  The focus of development was the simple usability and adaptability to any 
  setting that requires higher order tensors or decompositions thereof.


## High-Performance, Lower-Level Tensor Software and Tensor Backends

* <a href="https://developer.nvidia.com/cutensor">CuTensor</a> (C)<br/>
  CuTensor is a library for high-performance contraction of arbitrary tensors on
  NVIDIA graphics processing units (GPUs). It is built on top of hardware-optimized,
  permutation-free contraction algorithms and can achieve very high performance.

* <a href="http://solomon2.web.engr.illinois.edu/ctf/">Cyclops Tensor Framework</a> (C++)<br/>
  This library provides automatic parallelization of operations on multidimensional 
  (sparse) arrays. Cyclops supports general tensor sparsity, so it is 
  possible to define graph algorithms with the use of sparse adjacency matrices
  
* <a href="https://github.com/springer13/hptt">HPTT</a> (C/C++)<br/>
  High-performance tensor transpose (HPTT) is a library for permuting (transposing)
  tensor data including summing two tensors which may have a different ordering of indices.
  Performance is achieved by hardware and cache-friendly algorithms as well as multi-threading
  based on OpenMP.

* <a href="http://tensor-compiler.org">taco</a> (C/C++) <br/>
  taco is a library for compiling dense and sparse linear and tensor algebra expressions. 
  The expressions can range from simple kernels like SpMV to more complex kernels 
  like MTTKRP, where the operands can be dense, sparse, or a mix of dense and sparse. 
  taco automatically generates efficient compute kernels (loops) to evaluate these expressions.
  
* <a href="https://github.com/devinamatthews/tblis">TBLIS</a> (C/C++)<br/>
  TBLIS is a contraction library for arbitrary (real-valued) tensors
  which uses a sophisticated permutation-free algorithm,
  avoiding the permutation overhead that would be incurred by a more naive permute and
  matrix-multiply algorithm.

## Other Resources

* Review article ["The landscape of software for tensor computations"](https://arxiv.org/abs/2103.13756) by
  Psarras et al.\cite{psarras2021landscape} surveying and partially
  classifying existing tensor software.
