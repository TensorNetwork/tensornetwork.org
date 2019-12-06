## The Schrodinger Equation of Quantum Mechanics

The Schrodinger equation is the basic defining equation 
of quantum mechanics. It is a partial
differential equation which determines the
of the quantum wavefunction $\Psi$ as a function of time.
The wavefunction parameterizes the probability density
of observing a certain (classical) configuration of
a quantum system in the sense that the 
probability density is the square magnitude of 
the wavefunction. (This correspondence is known as
the Born rule, or 2-norm probability formalism.)

### General Form of the Schrodinger Equation

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
solution $\psi(\mathbf{r})$ is determined by the solution of the following eigenvalue equation, knpwn as the *time-independent Schrodinger equation*:
\begin{equation}
\hat{H} \psi(\mathbf{r}) = E \psi(\mathbf{r}) \ .
\end{equation}
Thus the set of eigenvectors and eigenvalues 
of the Hamiltonian operator $\hat{H}$ 
determines the set of such solutions.






