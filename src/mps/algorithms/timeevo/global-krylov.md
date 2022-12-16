# Krylov Time Evolution (Global Krylov)

$ \newcommand{\braket}[1]{ \langle #1 \rangle } $

<!--TOC-->

Krylov subspace methods\cite{park86:_unitar_lancz, kosloff88:_time,
saad03:_iterat_method_spars_linear_system,
garcia-ripoll06:_time_matrix_produc_states, dargel12:_lancz,
wall12:_out} (e.g. the Lanczos
method\cite{lanczos50,barrett94:_templ_solut_linear_system}) are
well-known iterative techniques from the field of numerical linear
algebra. In their application to time-dependent problems, one
approximates the action of $\hat U^\mathrm{exact}(\delta)$ onto the
quantum state $\ket{\psi(t)}$ directly, resulting in a time-evolved
state $\ket{\psi(t+\delta)}$.  It does _not_ provide access to
the exponential $e^{-\mathrm{i} \delta \hat H}$ in the standard
physical basis.  The most straight-forward approach is to ignore the
special structure of the MPS/MPO representation and directly implement
the iterative procedure, as detailed below.  This is what we call the
\textit{global Krylov method}.  In contrast, a variant exploiting the
structure of the MPS ansatz is called the
[[local Krylov method|mps/algorithms/timeevo/local-krylov]] and
identical to the time-step targeting method of sytem-environment DMRG.

Here, we first introduce the Krylov method independent of the specific
representation (dense vectors as in exact diagonalization, MPS, tree
tensor networks etc.) used.  This algorithm is also used as the local
integrator for the
[[local Krylov method|mps/algorithms/timeevo/local-krylov]] and the
[[TDVP|mps/algorithms/timeevo/tdvp]]. Subsequently, we will discuss
particular caveats when applying the method globally to matrix-product
states.

The Krylov subspace $\mathcal{K}_N$ of a Hamiltonian $\hat H$ and
initial state $\ket{\psi}$ is defined as the span of vectors $\{
\ket{\psi}, \hat H \ket{\psi}, \ldots, \hat H^{N-1} \ket{\psi} \}$.
This space is spanned by the Krylov vectors $\ket{v_0}$, $\ket{v_1}$,
$\ldots$, $\ket{v_{N-1}}$ such that the first Krylov vector
$|v_0\rangle$ is set to $\ket{\psi}$ normalized to have norm $1$, and
the subsequent Krylov vectors $\ket{v_i}$ are constructed by applying
$\hat H$ to $\ket{v_{i-1}}$ and orthonormalizing against all previous
Krylov vectors equivalently to the Lanczos algorithm.  In exact
arithmetics with Hermitian $\hat H$, this way to construct a Krylov
subspace reduces to orthogonalizing against the previous two vectors
$\ket{v_{i-1}}$ and $\ket{v_{i-2}}$, which is equivalent to the
Lanczos algorithm \cite{barrett94:_templ_solut_linear_system}.

However, due to round-off errors intrinsic to a numerical
implementation, orthogonality of the Krylov vectors is usually
lost. If the precision required of each solution is low, one may
abstain from avoiding this problem and simply work in a very small
subspace.  However, due to the accumulation of errors during a time
evolution and the calculation of spectral or time-dependent
properties, it is necessary to cure this problem. Hence, one typically
needs to explicitly orthogonalize each new Krylov vector against _all_
previous Krylov vectors. (Alternatively, one may only orthogonalize
against the previous two vectors and achieve complete orthogonality by
a subsequent basis transformation as detailed in
Ref. \onlinecite{dargel12:_lancz}.)  The method then proceeds by searching
for the element of $\mathcal{K}_N$ which approximates the result of
the exact evolution most closely:

\begin{equation}
  \hat U^\mathrm{exact}(\delta)\ket{\psi(t)} \approx \mathrm{argmin}_{\ket{u} \in \mathcal{K}_N}\| \ket{u} - \hat U^\mathrm{exact}(\delta)\ket{\psi(t)} \|\equiv \ket{\psi_N(t + \delta)} \;.
\end{equation}

To do so, we define the projector onto $\mathcal{K}_N$

\begin{align}
  \hat P_N & = \sum_{i=0}^{N-1} \ket{v_{i}}\langle v_i | \\
           & = \begin{pmatrix} \Big|\begin{matrix} \vdots \\ v_0 \\ \vdots \end{matrix}\Big\rangle & \Big|\begin{matrix} \vdots \\ v_{1} \\ \vdots \end{matrix}\Big\rangle & \cdots & \Big|\begin{matrix} \vdots \\ v_{N-1} \\ \vdots \end{matrix}\Big\rangle \end{pmatrix} \cdot \begin{pmatrix} \bra{\cdots v_{0\hspace{0.5cm}\hbox{}} \cdots} \\ \bra{\cdots v_{1\hspace{0.5cm}\hbox{}} \cdots} \\ \vdots\\ \bra{\cdots v_{N-1} \cdots} \end{pmatrix} \equiv V_N^\dagger V_N
\end{align}
		   
where we have introduced matrices $V_N$ and $V_N^\dagger$ to represent the maps from the Hilbert space onto the Krylov space and vice versa. 
The solution to the above minimization problem is given by

\begin{equation}
  \ket{\psi_N(t + \delta)} = \hat P_N^\dagger \hat U^\mathrm{exact}(\delta) \hat P_N \ket{\psi(t)} \;.
\end{equation}

Note that for $N = {\rm dim} \mathcal{H} \equiv N_{\mathcal{H}}$ this is exact. 
Expanding the projectors and writing down the formal Taylor series for
$\hat U^\mathrm{exact}(\delta)$, we find:

\begin{align}
  |\psi_{N_{\mathcal{H}}}(t + \delta)\rangle & = \sum_{i=0}^{N_{\mathcal{H}}-1} \ket{v_{i}}\langle v_i | e^{-\mathrm{i} \delta \hat H} \sum_{i^\prime=0}^{N_{\mathcal{H}}-1} \ket{v_{i^\prime}}\braket{v_{i^\prime} \vert \psi(t)} \\
                             & = \sum_{i=0}^{N_{\mathcal{H}}-1} \ket{v_{i}}\langle v_i | \sum_{n=0}^\infty \frac{\left(-\mathrm{i} \delta\right)^n}{n!} \hat H^n \sum_{i^\prime=0}^{N_{\mathcal{H}}-1} \ket{v_{i^\prime}}\braket{v_{i^\prime} \vert \psi(t)} \\
                             & = V^\dagger_{N_{\mathcal{H}}} \sum_{n=0}^\infty \frac{\left(-\mathrm{i} \delta\right)^n}{n!} \underbrace{V_{N_{\mathcal{H}}} \hat H^n V^\dagger_{N_{\mathcal{H}}}}_{\equiv \left(T_{N_{\mathcal{H}}}\right)^n} V_{N_{\mathcal{H}}} \ket{\psi(t)} \\
                             & \approx V^\dagger_N \sum_{n=0}^\infty \frac{\left(-\mathrm{i} \delta\right)^n}{n!} \left(T_N\right)^n V_N \ket{\psi(t)} = V^\dagger_N e^{-\mathrm{i} \delta T_N} V_N \ket{\psi(t)} \label{eq:krylov:final} \;,
\end{align}

where $N \ll N_{{\mathcal{H}}}$ and $T_N$ is the Krylov-space representation of $\hat H$ with
coefficients

\begin{equation}
  \left(T_N \right)_{i,i^\prime} = \bra{v_i}\hat H\ket{v_{i^\prime}} \;.
\end{equation}

The Krylov approximation is introduced in $\eqref{eq:krylov:final}$. Note
that for $n > N-1$
\begin{equation}
	V_{N_{\mathcal{H}}} \hat H^n V_{N_{\mathcal{H}}}^\dagger V_{N_{\mathcal{H}}}\ket{\psi(t)} \neq \left(T_N\right)^n V_N\ket{\psi(t)}\;.
\end{equation}

This implies that the error in the Taylor-expansion of the time-
evolution operator is of order $\frac{\delta^n}{n!}$, indicating
that already a few iterations suffice to give a very small error in
the integrator.  If $V_N^\dagger V_N$ were a proper
identity, we could insert it in between any power of $\hat H$ and
obtain exactly $V_N \hat H^n V_N^\dagger = T_N^n$.  However,
our Krylov subspace is much smaller than the true Hilbert space and
the projection induced by $V_N^\dagger V_N$ is hence very
large, $V_N^\dagger V_N \neq \mathbf{1}$. But due to the
special structure of this Krylov space, $V_N^\dagger T_N^n
V_N\ket{\psi(t)}$ converges much more quickly to $\hat
H^n\ket{\psi(t)}$ than expected if we, e.g., selected random vectors
in the full Hilbert space to construct our subspace.

In exact arithmetic and with Hermitian $\hat H$, $T_N$ would be
tridiagonal, i.e., $\left(T_N\right)_{i,i^\prime} = 0$ if
$|i-i^\prime| > 1$.  While in practice this is not necessarily true,
we found that it improves numerical stability and accuracy of the
results to _assume_ $T_N$ to be tridiagonal and only evaluate
those elements while forcibly setting all other elements to
zero. Returning to our equation $\eqref{eq:krylov:final}$,
$V_N \ket{\psi(t)}$ is the Krylov-space vector

\begin{equation}
  (\| \ket{\psi(t)} \|, 0, 0, \ldots)^T
  \end{equation}
  
as all other Krylov vectors are orthogonal to $\ket{v_0}$ and
$\ket{v_0}$ is the normalized version of $\ket{\psi(t)}$.  $T_N$ can
be exponentiated efficiently using standard diagonalization routines
from LAPACK, as it is only of size $N \times N$.  With $T_N =
Q_N^\dagger D_N Q_N$ this yields

\begin{equation}
  e^{-\mathrm{i} \delta T_N} = Q^\dagger_N e^{-\mathrm{i} \delta D_N} Q_N \;.
\end{equation}

For a given number of Krylov vectors and step size $\delta$, we hence
obtain

\begin{align}
  \ket{\psi_N(t + \delta)} & = \| \ket{\psi(t)}\| V^\dagger_N  Q^\dagger_N e^{-\mathrm{i} \delta D_N} Q_N e^1_N \\
                           & = \| \ket{\psi(t)}\| V^\dagger_N c_N
\end{align}

with the coefficient vector $c_N = Q^\dagger_N e^{-\mathrm{i} \delta D_N}
Q_N e^1_N$ and $e^1_N$ the $N$-dimensional unit vector $(1,
0, 0, \ldots)^T$.  For typical problems as presented in the example
section, the number of Krylov vectors used by us was between $3$ and
$10$.

## Algorithm

The main input of the Krylov method are the Hamiltonian $\hat H$, the
initial state $\ket{\psi(0)}$ and the (possibly complex) time
step. Additionally, a procedure `APPLY-ORTHONORMALIZE` is needed,
which in turn requires the operator-state product and the
orthogonalization of states.  For details on a variational approach to
this, see Ref. \onlinecite{paeckel19}, Sec. 2.8.2. The function
`COMPUTE-EFFECTIVE-H` only needs to update the new elements of $T_{j+1}$
compared to $T_j$.

\begin{align}
  & \texttt{ORTHONORMALIZE}(\ket{w}, \; \{\ket{v_0}, \cdots, \ket{v_k} \}) \; \{ \\
  & \quad \ket{w'} \gets \ket{w} - \sum_{\alpha=0}^{k}\braket{w|v_\alpha}\ket{v_\alpha} \quad \quad \textrm{// or variational orthonormalization for MPS} \\
  & \quad \textbf{if }{\|\ket{w'}\| < \varepsilon} \; \{ \\
  & \quad \quad \textbf{return }\textrm{ invariant subspace found } \quad \quad \textrm{// evolution exact using just }\{\ket{v_0}, \cdots, \ket{v_k}\} \\
  & \quad \} \\
  & \quad \textbf{return }{\frac{\ket{w'}}{\|\ket{w'}\|}} \\
  & \} \\
  & \nonumber \\
  & \texttt{APPLY-ORTHONORMALIZE}(\hat{H}, \{\ket{v_k}, \cdots, \ket{v_0}\}) \; \{ \\
  & \quad  \ket{w^\prime_k} \gets \hat{H}\ket{v_k} \\
  & \quad  \textbf{return } \texttt{ORTHONORMALIZE}(\ket{w_k'}, \{\ket{v_0},\cdots, \ket{v_k}\}) \\
  & \} \\
  & \nonumber \\
  & \texttt{TIMESTEP}(\hat{H}, \; \ket{\psi(t)}, \; \delta) \; \{ \\
  & \quad \ket{v_0} \gets \ket{\psi(t)}/ \|\ket{\psi(t)}\| \\
  & \quad \textbf{for }{j\gets 1\ldots} \; \{ \\
  & \quad \quad |v_j\rangle \gets \texttt{APPLY-ORTHONORMALIZE}(\hat H, \{\ket{v_0},\cdots\ket{v_{j-1}}\}) \\
  & \quad \quad T_{j+1} \gets \texttt{COMPUTE-EFFECTIVE-H}(T_j, \hat H,  \{\ket{v_0},\cdots, \ket{v_{j}}\}) \quad \quad \textrm{//} \left(T_{j+1}\right)_{k,l}=\braket{v_k|\hat{H}|v_l} \\
  & \quad \quad c_{j+1} \gets e^{-\mathrm{i}\delta T_{j+1}}\,e_{j+1}^1 \\
  & \quad \quad \textbf{if }c_{j+1} \textrm{ converged} \; \{ \\
  & \quad \quad \quad \textbf{break} \\
  & \quad \quad \} \\
  & \quad \} \\
  & \quad \textbf{return } \|\ket{\psi(t)}\| \sum_{i=0}^j c_{j+1}^i \ket{v_i} \\
  & \} \\ 
\end{align}

### Evaluation of expectation values $\braket{\hat O(t+\delta)}$

It is not actually necessary to construct the time-evolved state
$\ket{\psi_N(t+\delta)}$ to evaluate $\braket{\hat O(t+\delta)}$ for
arbitrary $\delta$. Instead, evaluating $\bra{v_i} \hat O
\ket{v_{i^\prime}}$ for all $i,i^\prime=[0, \ldots, N-1]$ and
constructing only the coefficient vector $c_N$ is sufficient to
evaluate the observable. One can hence potentially avoid adding up the
Krylov vectors and constructing the time-evolved state
$\ket{\psi(t+\delta)}$. Indeed, by evaluating the expectation values
$\bra{v_i} \hat O \ket{v_{i^\prime}}$, it becomes possible to
calculate the value of the observable at _any_ time
$\delta^\prime < \delta$ by only operating on small $N \times N$
matrices. Hence very small time steps unattainable by the other
time-stepping methods (e.g. $\delta^\prime = 10^{-5}$) become
available.

## Errors

Elaborate bounds are available to estimate the error incurred during
the Krylov approximation\cite{Hochbruck1997}.  Unfortunately, these
bounds are proven under the assumption of exact arithmetic and hence
do not necessarily apply in the context of matrix-product states. The
main take-away, which is confirmed in practice, is that the Krylov
error is in $O( \delta^N )$ as long as $\sqrt{W \delta} \leq N$ where
$W$ is the spectral range, which, in turn, is roughly of the same
order of magnitude as the system size. For a typical system of $L=100$
sites with $\delta = 0.1$, this condition is fulfilled as soon as $N
\approx 3$; more precise bounds are available in exact arithmetic.  In
exact arithmetic for a spectral width $W$ of $\hat H$, the error is
smaller than $10 e^{-\frac{N^2}{(5 W \delta)}}$ if $N$ is between
$\sqrt{4 W \delta}$ and $2 W \delta$ and the error is smaller than
$\left(\frac{10}{W \delta}\right) e^{-W \delta} \left( \frac{e
W \delta}{N} \right)^N$ if $N > 2 W \delta$ \cite{Hochbruck1997}. It
is unknown how this translates to the case of inexact arithmetic.

Hence, there are two approaches to measure the convergence of the
Krylov space: (i) The bottom-rightmost entry of the effective matrix
$T_n$ measures the weight scattered out of the Krylov space by
application of the Hamiltonian and typically decays exponentially;
(ii) the full Hilbert-space 2-norm distance between two sequential
iterations is cheaply available through the coefficients of Krylov
vectors produced in the two iterations. In our experience, this second
measure makes for an excellent convergence criterion.

In addition to the inherent Krylov error which can often be made
extremely small ($O(10^{-10})$ or smaller), the Krylov method of
course also suffers from the standard MPS truncation error -- this
error, too, can be measured precisely (via the discarded weight) and
be made very small. As such, both errors of the global Krylov method
can be made extremely small at _finite time-step size_, albeit at
relatively large numerical cost. The method hence in particular
excels if used to evaluate states very precisely, e.g., to measure the
errors of other methods on short time scales.

\subsection{Application to matrix-product states}
Up to this point, there was no need to narrow the description down to
a specific representation, which serves as a proof for the versatility
of the Krylov method. In our practical calculations, however, we wish
to use MPS to represent the time-evolved quantum states and
intermediate Krylov vectors and an MPO to represent the Hamiltonian
$\hat H$, which requires a few minor adaptations for efficiency and
accuracy. Note that in stark contrast to the TEBD and MPO \wiii
method, _only_ an MPO representation of $\hat H$ and no analytical
or other decomposition is required.

First and foremost, the most obvious improvement is in the calculation
of the last entry of the effective Krylov matrix $T_N$. In exact or
dense arithmetic, the evaluation of
$\bra{v_{N-1}} \hat H \ket{v_{N-1}}$ requires computing the
matrix-vector product $\hat H \ket{v_{N-1}}$. This is not the case in
the MPS approach: Indeed, evaluating the expectation value
$\bra{v_{N-1}} \hat H \ket{v_{N-1}}$ is much cheaper than calculating
the MPS representing $\hat H \ket{v_{N-1}}$. As such, to generate a
$N \times N$-dimensional effective Krylov matrix $T_N$, one only needs
to evaluate $N-1$ MPO-MPS products and avoids the MPO-MPS product for
the most costly application on the last Krylov vector. In our
experience, the bond dimension of every additional Krylov vector grows
superlinearly, making this optimization very worthwhile.

To construct the time-evolved state $\ket{\psi(t+\delta)}$, it is
necessary to sum $N$ Krylov vectors together. Various methods to do so
exist, in our implementation, we sequentially add two vectors
(resulting in a new MPS with bond dimension $2m$) which are then
truncated back down to the target bond dimension $m$. In $N-1$ steps,
all $N$ Krylov vectors are summed together at cost $O(N (2m)^3)$. One
could follow-up on this procedure with some sweeps of variational
optimization or alternatively directly variationally optimize, but
this does not appear to be necessary for our application.

## Loss of orthogonality

A typical problem of Krylov-subspace methods is the possible loss of
orthogonality of the basis vectors due to the finite-precision
arithmetic of floating point operations.  This matter becomes substantially
more pressing in the matrix-product algebra, as truncation is crucial
to keeping computations feasible.  If many Krylov vectors are desired,
truncation errors affecting the orthogonality of the basis vectors do
not simply add to the overall error (see above), but may quickly
degrade the overall quality of the Krylov space, leading to a poor
result.  In this case, it is necessary to check for orthogonality in
the basis and eventually re-orthogonalize the basis vectors
successively.  However, if one uses a simple Gram-Schmidt procedure to
orthogonalize vectors by successive additions of MPS, new truncation
errors are introduced during this procedure, which will quite often
entail the same problem.

In our experience, it has proven fruitful to orthogonalize the new
Krylov states variationally against all other Krylov states.  This is
essentially variational compression of a state under the additional
constraints of having zero overlap with all previous Krylov states.
The additional constraints can be incorporated with the method of
Lagrange multipliers: For each constraint (orthogonal vector
$\ket{v_i}$), introduce the respective Lagrange multiplier $\beta_i$.
To minimize $\|\hat{H}\ket{v_i}-\ket{v_{i+1}}\|^2$ under the
constraints $\{\braket{v_{i+1}|v_{i^\prime}} = 0\}_{0\leq i^\prime
\leq i}$, we actually minimize

\begin{align}
\left\|\hat{H}\,\ket{v_i}-\ket{v_{i+1}}\right\|^2 +
\sum_{i^\prime}\,\beta_{i^\prime}\,\braket{v_{i+1}|v_{i^\prime}}
\label{eq:krylov:ortho}
\end{align}

with regard to $\ket{v_i}$ and
the $\beta_{i^\prime}$.  As with variational compression, this can
also be solved by iteratively solving the local one- or two-site
problems (without explicitly evaluating $\braket{\hat H^2}$). Care
should be taken to ensure local orthogonality by using the
pseudo-inverse of the Gram matrix as explained in
Ref. \onlinecite{wall12:_out}. Using a two-site approach entails an
additional truncation step after each local optimization step and
implies again a loss of orthogonality. However, the two-site approach
converges much better than the single-site approach towards the global
optimum. In practice, we hence first do a few sweeps using the
two-site optimization (or, similarly, a single-site optimization with
subspace expansion\cite{hubig15:_stric_dmrg}) and follow up with a few
sweeps of fully single-site optimization without expansion and hence
also without truncation. The resulting state is then exactly
orthogonal to all previous states. Note that when initially starting
the optimization $\eqref{eq:krylov:ortho}$, the available vector space on
the first few sites is likely to be very small (e.g., $\sigma^2\cdot
(m_2 = \sigma^2)$) and the orthogonalization hence overconstrained. To
avoid this problem, one should add the constraints one-by-one during
subsequent sweeps.

This variational orthogonalization can either be used as a separate
orthogonalization step after the MPO-MPS application (using any of the
known algorithms) or it can be combined with the variational operator
application. Whether it is better to first do the MPO-MPS application
using the zip-up method and then variationally orthogonalize the
result or to do both steps at once depends on the system at hand: in
particular with long-range interactions, the variational approach may
require more sweeps to converge whereas short-range interactions are
dealt with very efficiently there.

## Dynamic step sizing

Dynamic step sizing is one of the most interesting and powerful
features of this method and can be used in several ways.  The idea is
that a Krylov subspace, which was computed for some time step
$\delta$, can be recycled for some other step length.  It is possible
to distinguish two cases: interpolation and extrapolation.

### Interpolation

In some applications, the time evolution needs to be
performed on a very fine grid in time.  The time-stepping methods
would involve a single step for each point of the grid, which can
quickly turn cumbersome or even impossible.  On the other hand, if we have a Krylov
subspace that we used to perform a large time step, it can be re-used
to compute any intermediate smaller time step at the same or higher
accuracy.  This immediately follows from the construction of the
Krylov space and the convergence criteria/assumptions made above.  As
the diagonalization of the effective Hamiltonian is already known, all
we need to do is exponentiate the diagonal times the new time step,
map back into the Krylov basis to get the coefficient vector, and
compute the new MPS as a superposition of Krylov vectors.  If one is
only interested in expectation values of an observable $\hat{O}$, it
is advantageous to compute its projection into the Krylov space via
$\left(O_{N}\right)_{i,i^\prime}=\braket{\phi_i|\hat{O}|\phi_{i^\prime}}$ with complexity
$\sim\mathcal{O}(n^2)$.  With the coefficient vector $c_N$, the
desired expectation value can be computed as
$c_N^\dagger O_N c_N$, entirely skipping the more
expensive superposition of Krylov states.

### Extrapolation

Albeit trickier to implement, extrapolation can significantly improve
performance when used as a kind of automatic adaptive step sizing
scheme.  The idea is as follows: Given a Krylov space, it is also
often possible to recycle it for larger step sizes, by only adding a
small number of additional Krylov vectors (or none at all).  It
follows that the optimal Krylov subspace dimension minimizes the ratio
of the time needed to compute its basis and the number of steps that
it can be used for. As crude approximations of these quantities, we
assume that the cost of any new Krylov vector grows exponentially,
i.e. the ratio of the costs of successive vectors is
fixed. Furthermore, we also assume that any new Krylov vector allows
us as many additional time steps as the previous Krylov vector. We
then continuously monitor the time needed to construct a new Krylov
vector and the number of steps we are able to take with it. Once a
decision has to be taken whether to extend the Krylov space or rebuild
it from scratch, we use those values as estimates for our decision. In
practice, this heuristic has proven to be quite reliable.

---

The content of this page is based on [Time-evolution methods for matrix-product states](https://www.sciencedirect.com/science/article/pii/S0003491619302532?via%3Dihub) by S. Paeckel, T. Köhler, A. Swoboda, S. R. Manmana, U. Schollwöck and C. Hubig and is licensed under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.
