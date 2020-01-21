## Graphical Interfaces and Visualization

* <a href="https://www.tensortrace.com">TensorTrace</a><br/>
  TensorTrace is an application that facilitates the design and 
  implementation of tensor network algorithms. Among many other features,
  TensorTrace can automatically determine the optimal contraction sequence and 
  cost scaling for each network, and generate code (in MATLAB, Python or Julia languages) 
  for contracting the tensor networks numerically.
 
## Open Source Tensor Network Software

(Listed in alphabetical order by project name.)

* <a href="http://solomon2.web.engr.illinois.edu/ctf/">Cyclops Tensor Framework</a> (C++)<br/>
  This library provides automatic parallelization of operations on multidimensional 
  (sparse) arrays. Cyclops supports general tensor sparsity, so it is 
  possible to define graph algorithms with the use of sparse adjacency matrices

* <a href="https://itensor.org">ITensor</a> (C++, Julia)<br/>
  ITensor is a library for tensor networks where tensor indices carry extra information and matching tensor
  indices automatically contract. Also features MPS and MPO algorithms, such as DMRG, and quantum number block-sparse tensors.

* <a href="https://arxiv.org/abs/1402.0939">NCON</a> (MATLAB)<br/>
  NCON (Network Contractor) is a MATLAB routine which can be used for computing
  a broad class of tensor network diagrams in an efficient and convenient way.
  
* <a href="https://quimb.readthedocs.io/en/latest/">QUIMB</a> (Python)<br/>
  python library for contracting tensors and tensor networks,
  with support for matrix product states and algorithms, and advanced
  features such as determination of the optimal ordering of tensor contractions.\cite{quimb}
  
* <a href="https://github.com/PGelss/scikit_tt">Scikit-TT</a> (Python)<br/>
  Scikit-TT is a Python library for applying the tensor-train (TT) format 
  to various numerical problems in order to reduce the memory consumption and computational
  cost compared to classical tensor approaches significantly.

* <a href="https://github.com/tenpy/tenpy">TenPy</a> (Python)<br/>
  Tensor Network Python (TeNPy) is a Python library for the simulation of 
  quantum systems with tensor networks. The philosophy of this library is 
  to get a new balance of a good readability and usability for new-comers, 
  and at the same time powerful algorithms and fast development of new 
  algorithms for experts.\cite{tenpy}

* <a href="http://tensorly.org/">TensorLy</a> (Python)<br/>
  A python library offering a high-level API for tensor methods and 
  deep tensorized neural networks. TensorLy's backend system allows users to 
  perform computations with NumPy, MXNet, PyTorch, TensorFlow, and CuPy
  in order to be scalable on both CPU and GPU.\cite{tensorly}

* <a href="https://github.com/google/TensorNetwork">TensorNetwork</a> (Python)<br/>
  python library for easy and efficient contraction of tensor
  networks, supporting multiple powerful backends

* <a href="http://www.tensortoolbox.org/">Tensor Toolbox</a> (MATLAB)<br/>
  The Tensor Toolbox is a MATLAB library supporting multiple tensor types, 
  including dense, sparse, and symmetric tensors as well as specially 
  structured tensors, such as Tucker format,
  and others. Tensors can be manipulated using MATLAB's object-oriented features.
   
* <a href="https://github.com/jemisjoky/TorchMPS">TorchMPS</a> (Python)<br/>
  TorchMPS is a framework for working with matrix product state (also known 
  as MPS or tensor train) models within Pytorch. Our MPS models are written as 
  Pytorch Modules, and can simply be viewed as differentiable black boxes 
  that are interchangeable with standard neural network layers. However, 
  the rich structure of MPS's allows for more interesting behavior...

* <a href="https://github.com/oseledets/TT-Toolbox">TT-Toolbox</a> (MATLAB)<br/>
  MATLAB implementation of basic operations with tensors in TT-format,
  including TT tensor and TT matrix formats, fast rounding procedures,
  methods for solutions of linear systems and eigenvalue problems,
  and the TT-cross method.
  
* <a href="http://yingjerkao.github.io/uni10/">Uni10</a> (C++)<br/>
  Universal Tensor Library, an open-source C++ library designed for 
  the development of tensor network algorithms. Provides a Network class to process 
  and store the details of the graphical representations of the networks,
  and supports quantum number block-sparse tensors.

* <a href="https://libxerus.org">Xerus</a> (C++)<br/>
  The Xerus library is a general purpose library for numerical 
  calculations with higher order tensors, Tensor-Train 
  Decompositions / Matrix Product States and general Tensor Networks. 
  The focus of development was the simple usability and adaptibility to any 
  setting that requires higher order tensors or decompositions thereof.


  
## Low-Level Tensor Software and Tensor Backends

* <a href="https://developer.nvidia.com/cutensor">CuTensor</a> (C)<br/>
  CuTensor is a library for high-performance contraction of arbitrary tensors on NVIDIA graphics processing units (GPUs). It is built on top of hardware-optimized, permutation-free contraction algorithms and can achieve very high performance.
  
* <a href="https://github.com/springer13/hptt">HPTT</a> (C/C++)<br/>
  High-performance tensor transpose (HPTT) is a library for permuting (transposing) tensor data including summing two tensors which may have a different ordering of indices. Performance is achieved by hardware and cache-friendly algorithms as well as multi-threading based on OpenMP.
  
* <a href="https://github.com/devinamatthews/tblis">TBLIS</a> (C/C++)<br/>
  TBLIS is a contraction library for arbitrary (real-valued) tensors which uses a sophisticated permutation-free algorithm, avoiding the permutation overhead that would be incurred by a more naive permute and matrix-multiply algorithm.

## Closed-Source Tensor Software

* <a href="https://syten.eu">SyTen</a><br/>
  A symmetry-protected tensor networks toolkit in C++,
  with a set of standard matrix-product state, binary tree-tensor network states 
  and infinite projected entangled pair state utilities included.
