For detailed descriptions of each method, see:

- [[Trotter Gate Time Evolution|mps/algorithms/timeevo/tebd]]
- [[Time-Step Targeting Method|mps/algorithms/timeevo/local-krylov]] (coming soon)
- [[Time-Dependent Variational Principle (TDVP)|mps/algorithms/timeevo/tdvp]] (coming soon)
- [[MPO Time Evolution|mps/algorithms/timeevo/mpo]]
- [[Krylov Time Evolution|mps/algorithms/timeevo/global-krylov]] (coming soon)
- [[Additional tricks|mps/algorithms/tricks]] (coming soon)

---

# Overview of Time-Evolution Methods for Matrix-Product States

On the individual pages of time-evolution methods for MPS, we will
discuss in detail five different time-evolution methods for MPS which
are currently in use to solve the time-dependent Schrödinger
equation (TDSE). Each of them has different strengths and weaknesses,
requiring a careful consideration of each individual problem to
determine the most promising approach.

The first two methods ([[TEBD|mps/algorithms/timeevo/tebd]] and [[MPO $W^\mathrm{II}$|mps/algorithms/timeevo/mpo]]) approximate the
time-evolution operator $\hat U(\delta) = e^{-\mathrm{i} \delta \hat H}$, which is
then repeatedly applied to the MPS $\ket{\psi(t)}$ to yield
time-evolved states $\ket{\psi(t+\delta)}$, $\ket{\psi(t+2\delta)}$
etc.

The _time-evolving block decimation_, also known as the Trotter method and abbreviated here as TEBD, was developed around 2004
both for MPS\cite{vidal04:_effic_simul_one_dimen_quant,zwolak04,verstraete04:_matrix_produc_densit_operat} and the original
classical DMRG\cite{white04:_real_time_evolut_using_densit,daley04:_time_hilber}.
It uses a Trotter-Suzuki decomposition of $\hat U(\delta)$, which is
in particular applicable to short-ranged Hamiltonians. The time evolution is unitary up to the inherent truncation error, but
the energy is typically not conserved. The main variants are using a second-order decomposition (TEBD2 in the
following) and a fourth-order decomposition (TEBD4) to minimise the
error due to the finite time step. While TEBD2 is essentially always
useful, as it produces only two- to three times as many exponential
terms as a first-order decomposition, TEBD4 produces four to five
times as many exponentials as TEBD2. Depending on the desired error,
this may or may not be worthwhile.

In contrast, the _MPO $W^\mathrm{II}$_ method was introduced only
recently\cite{zaletel15:_time} and relies on a different decomposition
scheme for the time-evolution operator $\hat U(\delta)$ particularly
suited to construct an efficient representation as a matrix-product
operator. It can directly deal with long-range interactions and
generally generates smaller MPOs than TEBD. Its primary downside is
that the evolution is not exactly unitary.

The time step error of both TEBD and the MPO $W^\mathrm{II}$ method is larger
than in the other methods described below.

Compared to these methods, algorithms based on Krylov
subspaces\cite{paige:_approx_krylov,barrett94:_templ_solut_linear_system} directly approximate the
action of $\hat U(\delta)$ onto $\ket{\psi}$, i.e. produce a state
$\ket{\psi(t+\delta)}$ without explicitly constructing
$\hat U(\delta)$ in the full Hilbert space while preserving the
unitarity of the time evolution. The main advantage lies in a very precise evaluation of
$\ket{\psi(t+\delta)}$ with a very small inherent finite time-step
error\cite{Hochbruck1997}.

The [[_global Krylov_|mps/algorithms/timeevo/global-krylov]] algorithm is related
to the time-dependent Lanczos method in exact diagonalization
approaches to time evolution\cite{park86:_unitar_lancz,kosloff88:_time,saad03:_iterat_method_spars_linear_system} and has only
partially\cite{garcia-ripoll06:_time_matrix_produc_states,dargel12:_lancz,wall12:_out} been adapted to the MPS setting.  Interestingly,
evaluation of observables on a very fine time grid
(e.g.~$\delta = 10^{-5}$) is possible, which would be prohibitively
expensive using any of the time-stepping methods.  The downside of
this global Krylov method is its need to represent potentially highly
entangled Krylov vectors as matrix-product states.

These highly-entangled global Krylov vectors do not need to be
represented if instead of working globally, one works in the [[local reduced basis|mps/algorithms/timeevo/local-krylov]]. From a DMRG perspective, this can be seen as a variant of the time-step targeting
method\cite{feiguin05:_time, manmana05:_time_quant_many_body_system,rodriguez06,
ronca17:_time_step_target_time_depen}.
Its primary objective is to solve the TDSE locally on each pair of
lattice sites to construct an optimal MPS for the time-evolved state.
Conversely, this local method can no longer evaluate observables
precisely at arbitrarily-small time steps $\delta' \ll \delta$ (as no
complete MPS is available at such intermediate times) but works much
like TEBD2 as a time-stepper, producing a single final state
$|\psi(t+\delta)\rangle$.  In contrast to TEBD and the MPO \wii it
allows for the treatment of arbitrary Hamiltonians. An uncontrolled
projection error may, however, lead to incorrect results as the MPS-projected
Hamiltonian cannot represent the actual physical Hamiltonian well if
the MPS used for the projection is very small. A further development
of this approach is the [[_time-dependent variational principle_|mps/algorithms/timeevo/tdvp]]\cite{haegeman11:_time_depen_variat_princ_quant_lattic,haegeman16:_unify} (TDVP). The TDVP can be considered an approach to remedy the dominant
errors in the local Krylov approach by a thorough theoretical analysis
leading to an optimized evolution method. Its implementation is nearly
identical to the local Krylov method, but the different derivation of
the local equations leads to smaller errors because it arrives at a
closed solution of a series of coupled equations.  In particular,
using the two-site variant of TDVP (2TDVP), we know that
nearest-neighbor Hamiltonians do not incur a projection error which is
often the primary error source in the local methods.  The single-site
variant (1TDVP) has a larger projection error and also always works at
constant MPS bond dimension but violates neither unitarity nor energy
conservation during the time evolution.

Finally, a subjective selection of
[[useful tricks|mps/algorithms/timeevo/tricks]] which are applicable
to most of the time-evolution methods and which can help in the
treatment of complicated systems may be helpful to the reader. We will
discuss in some detail: (i) how to combine the time evolution in the
Heisenberg and the Schrödinger picture, respectively, to reach longer
times; (ii) how to select time steps to increase the accuracy of the
integrator; (iii) how removing low-lying eigenstates and the
application of linear prediction helps in calculating Green's
functions; (iv) how to specifically select the optimal choice of
purification schemes for finite-temperature calculations; and (v)
briefly summarize the local basis optimization technique to treat
systems with many bosonic degrees of freedom.

---

The content of this page is based on [Time-evolution methods for matrix-product states](https://www.sciencedirect.com/science/article/pii/S0003491619302532?via%3Dihub) by S. Paeckel, T. Köhler, A. Swoboda, S. R. Manmana, U. Schollwöck and C. Hubig and is licensed under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.
