# The Schrodinger Equation of Quantum Mechanics

The Schrodinger equation is the basic defining equation 
of non-relativistic quantum mechanics.
It is a partial differential equation which determines the
of the quantum wavefunction $\Psi$ as a function of time.
The wavefunction parameterizes the probability density
of observing a certain configuration of
a quantum system in the sense that the 
probability density is the square magnitude of 
the wavefunction. This correspondence is known as
the Born rule, or 2-norm probability formalism.

## Introduction to the Schrodinger Equation

The Schrodinger equation is

\begin{equation}
i \frac{\partial \Psi}{\partial t} = \hat{H} \Psi
\end{equation}

where $\hat{H}$ is a linear operator known as the 
Hamiltonian. Typically, $\hat{H}$ is a second-order
differential operator in terms of the spatial coordinates
of a set of quantum particles. Here and in what follows,
the units are chosen such that $\hbar=1$.

### Single-particle Schrodinger Equation

Arguably the simplest example of the Schrodinger equation
is the case of a single quantum particle moving in a 
in the presence of a potential $V(\mathbf{r})$. 
For this case, the Schrodinger equation takes the form:

\begin{equation}
i \frac{\partial \Psi(\mathbf{r},t)}{\partial t} 
= \Big[\frac{-1}{2m}\nabla^2 + V(\mathbf{r})\Big] \Psi(\mathbf{r},t)
\end{equation}

Having determined the wavefunction $\Psi(\mathbf{r},t)$,
the probability to find the particle at the position $\mathbf{r}$
is given by $p(\mathbf{r},t) = |\Psi(\mathbf{r},t)|^2$.

### Stationary Solutions and Time-Independent Equation

Of the many possible solutions of the Schrodinger equation,
a special set of solutions are those known as *stationary states*
or *energy eigenstates*.
These are solutions of the form
\begin{equation}
\Psi(\mathbf{r},t) = \psi(\mathbf{r}) e^{-i E t}
\end{equation}
where $E$ is a constant interpreted as the energy 
of the quantum system. The reason such solutions are called
stationary is that they correspond to a time-independent 
probability distribution 
$p(\mathbf{r})=|\psi(\mathbf{r}) e^{-i E t}|^2 = |\psi(\mathbf{r})|^2$.

For solutions of this form, the spatially-dependent part of the
solution $\psi(\mathbf{r})$ is determined by the solution of the following eigenvalue equation, known as the *time-independent Schrodinger equation*:
\begin{equation}
\hat{H} \psi(\mathbf{r}) = E \psi(\mathbf{r}) \ .
\end{equation}
Thus the set of eigenvectors and eigenvalues 
of the Hamiltonian operator $\hat{H}$ 
determines the set of such solutions.

## Many-Body Schrodinger Equation

In terms of modern research and applications
the most important case of the Schrodinger equation
is when it describes many interacting quantum particles. 
The particles could be electrons and protons, as in
chemistry or materials science, or whole atoms
in atomic gas systems or astrophysics.
The many-body setting is also where <b>high-order tensors</b>
naturally arise, as we will see below.

The solution to the many-body Schrodinger equation is 
the many-body wavefunction
\begin{equation}
\Psi(\{\mathbf{r}\},t)=
\Psi(\mathbf{r}_1,\mathbf{r}_2,\mathbf{r}_3,\ldots,\mathbf{r}_N,t)
\end{equation}
where $N$ is the number of particles and $\mathbf{r}_j$ is the
location of particle $j$.
The wavefunction can be interpreted as parameterizing the probability
density of finding the particles at the positions $\{\mathbf{r}\}$
at time $t$ through the relation:
\begin{equation}
p(\{\mathbf{r}\},t)=|\Psi(\{\mathbf{r}\},t)|^2 \ .
\end{equation}

Additional symmetry constraints on the solution $\Psi$ are
also required to specify the problem correctly when
applying it to identical particles, such as electrons.
If the solution is required to be symmetric under exchange of
particle labels, the particles are known as bosons, and if 
antisymmetric, the particles are known as fermions.
(Electrons and protons are fermions, whereas certain isotopes of 
neutral atoms are bosons when approximated as a single particle.)

The most common form of the many-body Schrodinger equation
is:
\begin{equation}
i\frac{\partial}{\partial t} \Psi(\{\mathbf{r}\},t)
= \Big[ \sum_{j=1}^N \left( -\frac{1}{2 m_j} \nabla^2 + v(\mathbf{r}_j) \right)
   + \frac{1}{2} \sum_{i=1}^N \sum_{j=1}^N u(\mathbf{r}_i,\mathbf{r}_j)
  \Big] \Psi(\{\mathbf{r}\},t)
\end{equation}
where $m_j$ is the mass of particle number $j$.
The operator in square brackets on the right-hand side of the equation
is the many-body Hamiltonian $\hat{H}$.

The first term in the Hamiltonian, involving a single sum over $j$, is
known as the single-particle or non-interacting part of the Hamiltonian.
The second term involving a double sum is the 2-particle or interaction
term.


