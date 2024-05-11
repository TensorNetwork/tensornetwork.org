
## Functions of Continuous Variables (Quantum Inspired)

### Introduction

Consider a one-dimensional function $f(x)$ with $0 \leq x < 1$.
The variable $x$ can be expressed to high precision
as a *binary fraction*
\begin{equation}
x = 0.x_1x_2\cdots x_n = x_1/2 + x_2/2^2 + \ldots + x_n/2^n \ .
\end{equation}
described by bits $x_i = 0,1$. (For example, $1/3 \approx 0.010101$.)
This way of writing numbers is similar to the to the binary representation of integers, but with the numbers stepping through
a finely-spaced grid of spacing $1/2^n$ instead of steps of size 1.

Next we can write the values the function $f(x)$ takes on this grid as
$f(x) = f(0.x_1x_2\cdots x_n) = F^{x_1 x_2 \cdots x_n}$ so that the values of $f(x)$ have been repackaged into an $n$-index tensor $F$.

The last move is to approximate of $F$ as a tensor network, such as a [[matrix product state / tensor train|mps]]
network:
\begin{equation}
F^{x_1 x_2 \cdots x_n} = \sum_{\{\mathbf{\alpha}\}} A^{x_1}_{\alpha_1}
A^{x_2}_{\alpha_1 \alpha_2}
A^{x_3}_{\alpha_2 \alpha_3}
\cdots
A^{x_n}_{\alpha_{n-1}}
\end{equation}

Tensor networks of this class turn out to have very low rank (or bond dimension) for a wide class of 
functions $f(x)$ such as functions which are smooth, have self-similar structure, or a finite number of sharp features.
For example, both the functions $f(x) = e^{i k x}$ and $f(x) = \delta(x-k)$
give MPS/TT ranks of exactly one. (Equal to an outer product of vectors or a product state.)

The idea of using a tensor train (TT) this way is known as the "quantics tensor train" (QTT) (or "quantized tensor train") representation of a function \cite{KhoromskijOseledets2010, Oseledets2010Approximation, latorre2005image, khoromskij2011d, khoromskij2014tensor}.
It can be straightforwardly generalized to two-dimensional, three-dimensional, or higher-dimensional functions by using a tensor train with two, three, or more open indices on each tensor. For dimensions higher than three, however, other tensor decompositions such as tree tensor networks may be more appropriate.

In quantum physics and quantum computing, an essentially equivalent idea is known as the "amplitude encoding" of a function into a quantum register. In this context, it becomes an efficient tensor network method when the quantum entanglement (closely tied to tensor network rank) is moderate or low.

### Motivating Examples

An exponential function $f(x) = e^{a x}$ can be represented by a tensor network of rank 1 (or "product state"). This holds whether $a$ is real or complex. The construction is as follows:
\begin{align}
e^{a x} = e^{a (x_1/2 + x_2/2^2 + \ldots + x_n/2^n)} = (e^{a/2})^{x_1}\ \  (e^{a/2^2})^{x_2}\ \ (e^{a/2^3})^{x_3} \cdots (e^{a/2^n})^{x_n}
\end{align}
Then because this is now a rank-1 tensor, it can be represented by a tensor network of rank 1 (e.g. MPS/TT with ranks or bond dimensions of size 1), where one sets the elements of each tensor as $A^{x_j} = (e^{a/2^j})^{x_j}$.

The above result for an exponential function implies that $\cos(a x)$ or $\sin(a x)$ are exactly MPS/TT of rank 2, since the sum of two MPS with ranks $r_1$ and $r_2$ gives a new MPS whose rank is at most $r_1+r_2$.

### Application Areas

Early applications of this format include representing bosons in quantum systems \cite{Jeckelmann} and compressing images\cite{latorre2005image}. More recently this image compression approach has been proposed for machine learning on classical and quantum computers \cite{DilipData2022,Wright2022Deterministic}.

The QTT representation can be used to represent solutions of a wide range of differential equations \cite{khoromskij2014tensor}.

For example, QTT representation has been used to represent velocity fields of fluids in numerical algorithms for solving
the Navier-Stokes partial differential equation \cite{gourianov2022quantum,kiffner2023tensor}, with a similar approach used to solve the Vlasov-Poisson equations for plasma physics \cite{Ye2022}.

Green's functions of quantum many-body systems can also be compactly described by the QTT representation \cite{Shinaoka2023Multiscale,ritter2023quantics}, and tensor network algorithms used to solve the Dyson and Bethe-Salpeter equations.

Electronic orbitals used in quantum chemistry can be captured by QTTs, leading to more efficient representations than with Gaussian type orbitals \cite{Jolly2023Tensorized}.

### Rigorous Results

For the case of one-dimensional (univariate) functions, the tensor network or QTT representation has been shown to achieve optimal approximation order for functions in spaces of smooth functions (Sobolev or Besov spaces) of any smoothness order.\cite{Ali_Approximation_1_2} On the other hand, the QTT representation is itself not embedded into (space of all QTT lies outside of) any classical smoothness space.

Similar results can be proved for multivariate functions, with further considerations regarding whether the function is isotropic, anisotropic, or mixed smoothness spaces. Many types of classical smoothness spaces can be continuously embedded into the QTT representation, while the QTT approximation classes are themselves not embedded into any classical smoothness space.\cite{Ali_Approximation_3}

Any univariate polynomial of degree $p$ can be represented by a QTT of rank at most $(1+p)$.\cite{Ali_Approximation_1_2}

Constructive proofs together with efficient algorithms are given by Lindsey \cite{Lindsey_Multiscale}, showing results such as decaying ranks and rank bounds for band limited functions and rank bounds for functions with cusps or discontinuities that can be represented by polynomials across multiple scales.

The discrete Fourier transform can be represented as an MPO tensor network with low rank (small bond dimension). In the QTT formalism, the discrete Fourier transform is equivalent to the ["quantum Fourier transform"](https://en.wikipedia.org/wiki/Quantum_Fourier_transform) algorithm known from quantum computing, but compressed into a tensor network.\cite{ChenQFT,Shinaoka2023Multiscale,Chen_Direct} An explicit representation for the MPO Fourier transform operator in terms of Chebyshev cardinal functions \cite{Chen_Direct}.

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

