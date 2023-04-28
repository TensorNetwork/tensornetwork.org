
## Representation of Continuous Functions

### Introduction

Consider a one-dimensional function $f(x)$ with $0 \leq x < 1$.
The variable $x$ can be expressed to high precision
as a *binary fraction*
\begin{equation}
x = 0.b_1b_2\cdots b_n = b_1/2 + b_2/2^2 + \ldots + b_n/2^n \ .
\end{equation}
described by bits $b_i = 0,1$. (For example, $1/3 \approx 0.010101$.)
This way of writing numbers is similar to the to the binary representation of integers, but with the numbers stepping through
a finely-spaced grid of spacing $1/2^n$ instead of steps of size 1.

Next we can write the values the function $f(x)$ takes on this grid as
$f(x) = f(0.b_1b_2\cdots b_n) = F^{b_1 b_2 \cdots b_n}$ so that the values of $f(x)$ have been repackaged into an $n$-index tensor $F$.

The last move is to approximate of $F$ as a tensor network, such as a [[matrix product state / tensor train|mps]]
network:
\begin{equation}
F^{b_1 b_2 \cdots b_n} = \sum_{\{\mathbf{\alpha}\}} A^{b_1}_{\alpha_1}
A^{b_2}_{\alpha_1 \alpha_2}
A^{b_3}_{\alpha_2 \alpha_3}
\cdots
A^{b_n}_{\alpha_{n-1}}
\end{equation}

Tensor networks of this class turn out to have very low rank (or bond dimension) for a wide class of 
functions $f(x)$ such as functions which are smooth or have periodic or self-similar structure.
For example, both the functions $f(x) = e^{i k x}$ and $f(x) = \delta(x-k)$
give MPS/TT ranks of exactly one (Kronecker product of vectors).

The idea of using tensor train (TT) this way is known as the "quantics tensor train" (QTT) (or "quantized tensor train") representation of a function.
It can be straightforwardly generalized to two-dimensional, three-dimensional, or higher-dimensional functions
by using a tensor train with two, three, or more open indices on each tensor. 

### References and Review Articles

* **"Quantum-inspired algorithms for multivariate analysis: from interpolation to partial differential equations"**<br/>
  **Author:** Juan Jose Garcia-Ripoll<br/>
  **Journal**: <a href="https://quantum-journal.org/papers/q-2021-04-15-431/">Quantum 5, 431 (2021)</a><br/>
  **Notes**: Uses of the QTT format to perform many computational tasks, such as interpolating functions, computing Fourier transforms, and solving differential equations.

* **"Multigrid Renormalization"**<br/>
  **Author:** Michael Lubasch, Pierre Moinier, Dieter Jaksch<br/>
  **Journal**: <a href="https://doi.org/10.1016/j.jcp.2018.06.065">J. Comp. Phys. 372, 587 (2018)</a><br/>
  **arxiv link**: <a href="https://arxiv.org/abs/1802.07259">arxiv:1802.07259</a><br/>
  **Notes**: Physics inspired methods for working with QTT functions, such as "prolonging" coarse-grid functions to finer grids and solving equations.

* **"Tensor numerical methods for high-dimensional PDEs: Basic theory and initial applications"**<br/>
  **Author:** Boris N. Khoromskij<br/>
  **Journal**: <a href="https://arxiv.org/abs/1408.4053">arxiv:1408.4053</a><br/>
  **Notes**: Applications of the QTT format to solving partial differential equations.

* **"O(d log(n))-Quantics Approximation of Nd tensors in High-Dimensional Numerical Modeling"**<br/>
  **Author:** Boris N. Khoromskij<br/>
  **Journal**: <a href="https://doi.org/10.1007/s00365-011-9131-1">Constr Approx 34, 257–280 (2011)</a><br/>
  **Notes**: Introduces the quantics, or quantized tensor train (QTT) format for representing functions as [[tensor trains or matrix product states|mps]].


* **"Image Compression and Entanglement"**<br/>
  **Author:** Jose I. Latorre<br/>
  **Journal**: <a href="https://arxiv.org/abs/quant-ph/0510031">quant-ph/0510031</a><br/>
  **Notes**: Proposes a binary "amplitude encoding" of images into quantum states.

