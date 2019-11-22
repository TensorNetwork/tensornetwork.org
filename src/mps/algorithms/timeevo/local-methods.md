For the specific methods, see:

- [[Time-Step Targeting Method|mps/algorithms/timeevo/local-krylov]]
- [[Time-Dependent Variational Principle (TDVP)|mps/algorithms/timeevo/tdvp]]

---

# MPS-local time-evolution methods

The [[global Krylov method|mps/algorithms/timeevo/global-krylov]] uses
generic features of Krylov subspaces to compute the time evolution of
an MPS. However, working ‘globally’ and only using MPS to represent
the Krylov vectors comes with the major drawback that those vectors
are typically much more entangled than the actual time-evolved state
$\ket{\psi(t+\delta)}$. To circumvent this problem, it may be
desirable to work in the local basis of reduced sites. From a
practical point of view, this is also motivated by the DMRG
formulation which _always_ works in local spaces and hence makes it
very difficult to formulate a global Krylov method. There are two
different ways to obtain such a local basis, one being via an attempt
to directly Lie-Trotter decompose the Hamiltonian into local
subspaces\cite{feiguin05:_time,
manmana05:_time_quant_many_body_system,rodriguez06,garcia-ripoll06:_time_matrix_produc_states,
ronca17:_time_step_target_time_depen}, the other by enforcing a
constraint that the evolution lies within the MPS
manifold\cite{haegeman11:_time_depen_variat_princ_quant_lattic,
haegeman16:_unify}. Both have been used in the literature, but their
precise derivation requires some work. On this page, we will present a
very heuristic understanding of the general approach.
For a detailed description of the first approach, see the [[page on the local Krylov method|mps/algorithms/timeevo/local-krylov]].
The second approach is review in detail on the [[page on the time-dependent variational principle, TDVP||mps/algorithms/timeevo/tdvp]].

We start with an MPS $|\psi\rangle$, a Hamiltonian $\hat H$ and a site
$j$. The tensors $\psi^{L}_{j-1} \equiv (M_1, \ldots, M_{j-1})$ and
$\psi^{R}_{j+1} \equiv (M_{j+1}, \ldots, M_L)$ then constitute a left and
right map, respectively, from the joint Hilbert space on sites $1$
through $j-1$ onto the bond space $m_{j-1}$ and from the joint Hilbert
space on sites $j+1$ through $L$ onto the bond space $m_j$.

By sandwiching the Hamiltonian between two copies of $\psi^{L}_{j-1}$ and
$\psi^{R}_{j+1}$, we can transform it to act on the effective single-site
space on site $j$ (of dimension $\sigma_j \times m_{j-1} \times m_j$).
Let us call this effective single-site Hamiltonian
$\hat H_j^{\mathrm{eff}}$:

![medium](krylov_effective_operator.svg)

Likewise, we can take the MPS $\ket{\psi}$ and act on it with a single
copy of $\bar{\psi}^{L}_{j-1}$ and $\bar{\psi}^{R}_{j+1}$ to obtain
the effective single-site tensor $\tilde{M}_j$ representing the
effective state $\ket{\psi_j^{\mathrm{eff}}}$:

![medium](krylov_effective_state.svg)

If we move the orthogonality center of the MPS to site $j$ first, the
transformation of the state is an identity operation, as the
$\bar{A}_1$ of the transformation operator cancels with the $A_1$ in
the state etc. This is desirable for many reasons, primarily numerical
stability and avoiding a generalized eigenvalue problem in favor of a
standard eigenvalue problem.

Instead of mapping onto the space of a single site, we can also map
onto the space of two sites. This results in an effective state
$|\psi_{(j,j+1)}^{\mathrm{eff}}\rangle$ given by the product of two
site tensors $M_j \cdot M_{j+1}$ over their shared bond and likewise
an effective Hamiltonian $\hat H_{(j,j+1)}^{\mathrm{eff}}$. On the
other hand, if we map onto the space of a single bond between sites
$j$ and $j+1$ (without a physical index), we obtain the center
matrix. We will use underlined indices ${}_{\underline{j}}$ to refer
to bond tensors between sites $j$ and $j+1$ whereas ${}_j$ (without
the underline) refers to the site tensor or effective Hamiltonian
tensors on site $j$. $C_{\underline{j}}$ to represent the effective state
$|\psi_{\underline{j}}^{\mathrm{eff}}\rangle$ and the effective center
site Hamiltonian $\hat H_{\underline{j}}^{\mathrm{eff}}$. 

In any of these smaller spaces -- typically in the basis of left- and
right-orthogonal environments as produced naturally during left-to-right and right-to-left sweeps -- it is very easy to solve the
time-dependent Schrödinger equation exactly from time $t$ to time
$t+\delta$ using a local Krylov procedure or any other exponential
solver\cite{moler03:_ninet_dubious_ways_comput_expon}. This results then in a new effective state
$|\psi_{j}^{\mathrm{eff}}(t+\delta)\rangle$. Unfortunately, the new
state will be represented in a relatively bad basis of the
environments $\psi^L_{\vphantom{j}}$ and $\psi^R_{\vphantom{j}}$ which are optimized to represent
the original state at time $t$. To alleviate this issue, after
evolving the site tensor $M_j$ forwards by $\delta$, one now wishes to
obtain a global state $\ket{\psi(t)}$ at the original time but in the
new left auxiliary basis. If this is achieved, we may iteratively
update the basis transformation tensors to be suitable for the new
state $\ket{\psi(t+\delta)}$.

This is where the local Krylov method and the TDVP diverge and proceed
differently. An interesting intermediate between the local Krylov
method based on time-step targetting and the TDVP as introduced in
Refs. \onlinecite{haegeman11:_time_depen_variat_princ_quant_lattic,
haegeman16:_unify} was presented in
Refs. \onlinecite{koffel12:_entan_entrop_long_range_ising,
hauke13:_spread_correl_long_range_inter_quant_system} where the
time-step targetting was combined with a variational principle to
solve the local TDSE. However, regardless of how one obtains this old
state in the new basis, by sweeping once through the system, all site
tensors are incrementally optimized for a representation of the next
time step while the global state is kept at the original time. Upon
reaching the far end of the system, we keep the local state tensor at
the new time and hence obtain a global state at the new time
$t+\delta$ written using near-optimal basis transformation tensors.

Instead of solving the forward problem a single site at a time, it is
also possible to consider the effective Hamiltonian and state of two
neighboring sites. In this two-site scheme, one obtains a
forward-evolved tensor $M_{(j,j+1)}$ which needs to be split up using
a SVD, with then the single-site tensor on site $j+1$
backwards-evolved to keep the state at the original time. The
advantage is the variable bond dimension which allows a successive
adaptation of the MPS bond dimension to the entanglement growth in the
system. The downside is that an additional truncation error is
introduced. In practice, it appears that a hybrid scheme which first
uses the two-site method to increase the bond dimension to the usable
maximum and then switches to the single-site variant may fare best, at
least for some observables\cite{goto18:_perfor}.

Depending on the particular way in which we obtain the local problems,
solving the system of local Schrödinger equations exactly (using a
small direct solver each time) is possible. The result is that both
the energy and the norm (where applicable) of the state are conserved
exactly. This conservation may extend to other global
observables\cite{leviatan17:_quant_matrix_produc_states,
goto18:_perfor}. In practice, the TDVP achieves this goal.

Finally, one may turn the first-order integrator of sweeping once
through the system into a second-order integrator by sweeping once
left-to-right and then right-to-left through the system, each time
with a reduced time step $\delta/2$.

---

The content of this page is based on [Time-evolution methods for matrix-product states](https://www.sciencedirect.com/science/article/pii/S0003491619302532?via%3Dihub) by S. Paeckel, T. Köhler, A. Swoboda, S. R. Manmana, U. Schollwöck and C. Hubig and is licensed under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.
