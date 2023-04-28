
## Applications of Tensor Networks in Out-of-equilibrium Classical Statistical Physics

### Introduction

In a wide variety of situations, the time evolution of a physical system with $\mathcal N$ states is described by a master equation
\begin{equation}
 \frac{d}{dt}p_s(t)= \sum_{r=1}^{\mathcal N} A_{sr}p_r(t)
\end{equation}
where $p_s(t)$ is the probability of finding the system in state $s$ at time $t$ and $A$ a real-valued matrix.

Knowledge of the eigen-decomposition of $A$ would allow to solve for $p_s(t)$. In particular, the dominant eigenvector (e.g. the one relative to the largest eigenvalue) is of special interest since it corresponds to the steady-state distribution $\lim_{t\to\infty}p_s(t)$.
Diagonalizing $A$ is in general a hard problem because $\mathcal N$ is exponentially large in the size of the system.
However, tensor network techniques can be exploited to provide approximate, sometimes even exact, solutions.

### An example: 1D exclusion processes
A prominent example is the one-dimensional [fully asymmetric exclusion process](https://en.wikipedia.org/wiki/Asymmetric_simple_exclusion_process), useful in a variety of contexts ranging from the kinetics of biopolymers to vehicular traffic. 
It describes a chain of $L$ sites, each of which can be occupied or not by a particle. Particles can hop left or right, be injected or removed from the system, according to some stochastic rule which defines a master equation of the form $(1)$. 
The state of the system is described by binary variables $n_1,\ldots,n_L$ with $n_i=1$ if state $i$ is occupied, $0$ otherwise.

Derrida et al. showed that\cite{derrida1993exact}, for an infinite system $L\to\infty$, the steady state probability of finding the system in configuration $n_1,\ldots,n_L$ can be expressed exactly as a [[matrix product state|mps]]
\begin{equation}
p^{n_1,\ldots,n_L}= \frac{1}{Z}\sum_{\{\alpha\}}W_{\alpha_1} \left(\prod_{i=1}^L D_{\alpha_{i}\alpha_{i+1}}^{n_i}\right)V_{\alpha_{L+1}}
\end{equation}
where $W,D^0,D^1,V$ are real-valued matrices and $Z$ is the normalization constant ensuring $\sum_{\{n\}}p^{n_1,\ldots,n_L}= 1$.

Notice two slight differences with respect to how matrix product states are typically used in a quantum context:

* Matrices $W$ and $V$, which are really a row and a column vector, respectively, are fixed and do not depend on the variables $\{n\}$.

* The matrix product $(2)$ directly represents a probability distribution, whereas when working with quantum systems one typically uses a matrix product to parametrize a wavefunction.

Other models in the family of one-dimensional exclusion processes have been addressed via a matrix product ansatz followed by approximate diagonalization techniques like the [[density matrix renormalization group|mps/algorithms/dmrg]].


### Mapping to quantum systems
The use of tensor network techniques in this context comes in particularly naturally in those cases where the matrix $A$ governing the dynamics happens to be closely related to the Hamiltonian $H$ of a known quantum system.
Typically one has $A=-H$.

Whenever such a mapping can be established, any known result can be readily translated from one problem to the other.
In particular the ground state of $H$ is in correspondence with the steady state of the dynamics.
One of the earliest examples is the mapping between a symmetric exclusion process and the Heisenberg model with ferromagnetic interactions\cite{alexander1978lattice}.

In most cases the mapping is exploited in the same direction: known results from quantum physics are exploited to shed new light on the classical problem.
However there are also examples where investigation over this correspondence brought new insight to the quantum side\cite{essler1996representations}.

## Selected literature

- [Exact solution of a 1D asymmetric exclusion model using a matrix formulation](https://iopscience.iop.org/article/10.1088/0305-4470/26/7/011), Bernard Derrida, Martin R. Evans, Vincent Hakim, Vincent Pasquier \cite{derrida1993exact}<br/>
  _Solves exactly the steady-state dynamics of some driven diffusion in a 1D lattice with exclusion interactions,
  showing that the distribution of occupation numbers can be written in matrix product form._

- [Reaction-Diffusion Processes from Equivalent Integrable Quantum Chains](https://www.sciencedirect.com/science/article/pii/S0003491697957122?via%3Dihub), Malte Henkel, Enzo Orlandini, Jaime Santos, arxiv:cond-mat/9610059 <br/>
  _Formalizes the mapping to quantum chains for 1D reaction-diffusion processes. It also contains a rather pedagogical review of the formulation of stochastic processes as quantum chains._

- [The density-matrix renormalization group](https://journals.aps.org/rmp/abstract/10.1103/RevModPhys.77.259), Ulrich Schollwock, arxiv:cond-mat/0409292 <br/>
  _Contains a section on the applications of DMRG to classical stochastic systems._

- [Using matrix product states to study the dynamical large deviations of kinetically constrained models](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.123.200601), Mari Carmen Bañuls, Juan P. Garrahan, arxiv:1903.01570 <br/>
  _Studies large deviations of a class of one-dimensional stochastic models using matrix product states and DMRG._
