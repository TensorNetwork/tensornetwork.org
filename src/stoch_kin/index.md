<!-- Interactive widget bundle (self-mounting onto the div ids below).
     KaTeX CSS is already loaded globally by the site, so it is not re-included. -->
<link rel="stylesheet" href="stoch_kin_widget.css">
<script src="stoch_kin_widget.js" defer></script>

# Applications of Tensor Networks to Stochastic Chemical Kinetics

<!--TOC-->

Stochastic chemical kinetics describes a reaction network by a probability distribution over the integer copy numbers of its species, evolving under a master equation. The occupation-number representation expresses that master equation as a single linear operator acting on the vector of configuration probabilities\cite{doi1976a,doi1976b,zeldovich1978,grassberger1980}. Working in terms of integer molecule counts rather than continuous concentrations casts each reaction as a product of creation and annihilation operators, and the combinatorial factors associated with indistinguishable reactants arise directly from the action of those operators.

This operator representation is also the natural point of departure for tensor-network methods. The probability vector is represented as a [[Matrix Product State|mps]] and the generator as a [[Matrix Product Operator|mpo]], so that a state space that grows exponentially with the size of the system can be stored and propagated within a controllable memory budget\cite{schollwock2011}. The builder below assembles a reaction mechanism and displays its operator form and tensor diagrams; no quantum mechanics is needed to follow them.

## Why count molecules instead of concentrations

Deterministic chemical kinetics tracks concentrations through coupled ordinary differential equations, a description that is accurate when every species is present in large numbers and its concentration is effectively continuous. That description fails when a species is present in only tens or hundreds of copies, as is common for gene products, intracellular signaling molecules, and reactions confined to small volumes\cite{erban2020}. In this regime the copy number of each species is a discrete integer that changes by a whole number of molecules at each reaction event, and the timing of those events is a random process.

The appropriate description is then a probability distribution over integer copy numbers. Writing $\mathbf{n}$ for the vector of copy numbers of each species, $p(\mathbf{n}, t)$ denotes the probability of configuration $\mathbf{n}$ at time $t$, and its evolution obeys the chemical master equation\cite{vankampen2007}, a linear rate equation with one term per reaction. The master equation is readily written but difficult to solve, since the number of accessible configurations grows combinatorially with the number of species\cite{gillespie1977}.

The occupation-number representation does not alter the underlying physics. It re-expresses the same master equation in an operator language that exposes its algebraic structure and, in particular, renders it amenable to tensor-network representation.

The operator representation used here was introduced independently by Doi\cite{doi1976a,doi1976b}, by Zel'dovich and Ovchinnikov\cite{zeldovich1978}, and by Grassberger and Scheunert\cite{grassberger1980}. The name Doi-Peliti properly refers to the coherent-state path integral built on this representation\cite{peliti1985,tauber2005}, which this page does not use; the construction below stays at the operator level.

## Reactions as operators

Consider a single species, and let $|n\rangle$ denote the state containing exactly $n$ molecules. These occupation-number states form a basis, and any probability distribution over copy numbers is a nonnegative linear combination of them. The state of the system is the probability vector expressed in this basis,

$$\left|p(t)\right\rangle = \sum_{\mathbf{n}} p(\mathbf{n}, t)\left|\mathbf{n}\right\rangle .$$

Two operators connect neighboring basis states. The annihilation operator $a$ removes one molecule and multiplies by $n$, reflecting the $n$ indistinguishable molecules that could be removed. The creation operator $a^{\dagger}$ adds one molecule and carries no numerical prefactor,

$$a\left|n\right\rangle = n\left|n-1\right\rangle , \qquad a^\dagger\left|n\right\rangle = \left|n+1\right\rangle , \qquad \hat{n}=a^\dagger a .$$

Combinatorial factors therefore arise automatically. A step that consumes two molecules of the same species acquires the factor $n(n-1)$ directly from the action of those operators, with no binomial coefficient introduced by hand,

$$a^2\left|n\right\rangle = n(n-1)\left|n-2\right\rangle .$$

A caveat on notation is warranted. The dagger is an algebraic label rather than a Hermitian conjugate: the construction borrows the symbols of second quantization, but the evolved object is a classical probability distribution, normalized so that its entries sum to one (the 1-norm) rather than so that their squares do (the 2-norm of a wave function).

The builder below assembles elementary steps and displays each reaction as a balanced equation together with its generated operator term; hovering over an operator reveals the truncated matrix it represents. Load a preset with the two buttons, the reversible Schlögl model or a seven-species gene toggle switch, or clear the mechanism and build your own.

<div id="rn-builder"></div>

## The flat state and observables

Probabilities are read out of the state by a single fixed covector, the flat state (or sum state),

$$\langle 1| = \sum_{\mathbf{n}} \langle \mathbf{n}| .$$

Its defining property is that creation is invisible to it,

$$\langle 1|\, a^{\dagger} = \langle 1| ,$$

because $\langle 1|a^{\dagger}|n\rangle = \langle 1|n+1\rangle = 1 = \langle 1|n\rangle$ for every $n$. Pairing the flat state with the probability vector returns total probability, which is the normalization condition,

$$\langle 1 | p(t)\rangle = \sum_{\mathbf{n}} p(\mathbf{n},t) = 1 .$$

Averages are pairings as well: for an observable that is a function of the copy numbers, represented by a diagonal operator $\hat{A}$, the expectation value is

$$\langle A \rangle_t = \langle 1|\, \hat{A}\, \left|p(t)\right\rangle ,$$

so the mean copy number of species $i$ is $\langle \hat{n}_i\rangle = \langle 1|\hat{n}_i|p(t)\rangle$. This is the practical contrast with quantum mechanics, where an expectation value is a state paired with itself, $\langle \psi|\hat{A}|\psi\rangle$; here the state is always paired with the same fixed dual vector $\langle 1|$. The identity $\langle 1|a^{\dagger}=\langle 1|$ is what makes probability conservation a one-line result once the generator is assembled below.

## How a reaction becomes an operator

The operator terms generated by the builder follow a fixed structure: each elementary reaction contributes a rate constant multiplying a gain term minus a loss term. Consider the unimolecular decay $A\to\varnothing$ with rate constant $k$,

$$\mathbb{W}_{A\to\varnothing} = k\left(a - a^\dagger a\right) .$$

The gain term $a$ removes one molecule, transferring probability from each state to the state with one fewer molecule. The loss term $a^{\dagger}a$ is the number operator, counting the molecules available to decay while leaving the configuration unchanged; the minus sign removes the corresponding probability from the originating state, so probability leaves each state at exactly the rate it accumulates elsewhere.

For a general reaction with reactant stoichiometry $\eta_i$, product stoichiometry $\mu_i$, and rate constant $k$, the operator is

$$\mathbb{W} = k\left(\prod_i \left(a_i^\dagger\right)^{\mu_i} - \prod_i \left(a_i^\dagger\right)^{\eta_i}\right)\prod_i a_i^{\eta_i} .$$

## Building the generator

A reaction mechanism comprises several elementary reactions, and its generator $\mathbb{W}$ is the sum of the operator terms of the individual steps, so the mechanism assembled in the builder corresponds to a single matrix. The distribution evolves under a single linear equation, with no minus sign and no factor of $i$, in contrast to the Schrödinger equation,

$$\frac{d}{dt}\left|p(t)\right\rangle = \mathbb{W}\left|p(t)\right\rangle .$$

The spectrum of $\mathbb{W}$ lies in the left half-plane, its eigenvalues having nonpositive real part, so the evolution relaxes the distribution toward its stationary state. Total probability is conserved for any mechanism, and the flat state makes this a one-line result. Applying $\langle 1|$ to the general term above, every product of creation operators acts as the identity from the left, since $\langle 1|a_i^{\dagger} = \langle 1|$, so the gain and loss brackets cancel and

$$\langle 1|\,\mathbb{W} = 0 \qquad\Longrightarrow\qquad \frac{d}{dt}\langle 1 | p(t)\rangle = \langle 1|\,\mathbb{W}\left|p(t)\right\rangle = 0 .$$

The formal solution is a matrix exponential, $\left|p(t)\right\rangle = e^{t\mathbb{W}}\left|p(0)\right\rangle$. Constructing $\mathbb{W}$ is straightforward; the difficulty lies in applying $e^{t\mathbb{W}}$, since $\left|p(t)\right\rangle$ carries one entry for every accessible configuration and the dimension of this space grows exponentially with system size. Tensor networks provide a controlled approximation for this evolution.

## Tensor diagrams

Operators built from $a$ and $a^{\dagger}$ are [[tensors|tensor]], and this page draws them in [[tensor diagram notation|diagrams]]: a tensor is a shape, each line is an index, and joining two lines denotes a contraction, a summation over the shared index. Two features are specific to the present setting. The tensors here generate a stochastic process rather than a Hermitian observable, so a diagram is generally not symmetric under exchanging its upper and lower legs. And each external index is an occupation number, whose dimension is the number of retained states per site, while the flat state $\langle 1|$ is a specific covector that closes a diagram to return a probability or an average.

## From operators to tensor networks

A single well-mixed species can be treated directly. The tensor-network representation becomes valuable when the distribution is high-dimensional, whether because the network contains many chemical species whose copy numbers are correlated or because a spatially extended system is resolved into a chain of small volumes, or voxels\cite{erban2020}. Truncating each site at a maximum occupation $n \le d$ retains $d+1$ states per site, so a chain of $L$ sites supports $(d+1)^{L}$ configurations.

A Matrix Product State circumvents explicit storage. The distribution is expressed as a chain of factor tensors, one per site, each carrying a vertical external index for its local occupation and horizontal internal indices connecting it to its neighbors,

$$\left|p(t)\right\rangle \approx \sum_{n_1,\ldots,n_L} A^{[1]n_1}A^{[2]n_2}\cdots A^{[L]n_L}\left|n_1,\ldots,n_L\right\rangle .$$

<div id="rn-mps"></div>

The dimension of these internal bonds, denoted $\chi$, is the rank of the factorization across each bipartition of the chain. Across a given cut, $\chi = 1$ means the distribution factorizes into independent halves, so $\chi$ is a direct measure of the correlation the representation retains between the two sides. Because the factor tensors may carry negative entries, $\chi$ can fall well below the bond dimension a nonnegative representation would require\cite{glasser2019}; those same negative entries are why compression in the 2-norm can leave small negative probabilities.

The generator admits the same structure. Because each operator term couples only a few sites, $\mathbb{W}$ can be written as a Matrix Product Operator, a chain of factor tensors each carrying an upper external index $n_i$ and a lower external index $n_i^{\prime}$.

<div id="rn-mpo"></div>

Time evolution then proceeds by contracting the operator network with the state network and compressing the result to a prescribed bond dimension\cite{schollwock2011}. The controls below compare the number of parameters in the tensor-network representation with the size of the full distribution as the chain length increases.

Truncation is not free. On a truncated site the identity $\langle 1|a^{\dagger} = \langle 1|$ acquires a boundary term, so a naive hard cut-off leaks probability and $\langle 1|\mathbb{W} \ne 0$ exactly. The pragmatic response is to choose $d$ generously and monitor $\langle 1|p\rangle$ as a diagnostic; the principled one is to zero the rate of every reaction step that would carry a configuration past the cap, removing that step's gain and loss together, which restores exact conservation on the finite space at the price of a boundary term in the commutation relations of the truncated operators\cite{nicholson2023}.

<div id="rn-chain"></div>

## Rare events and rate-constant exploration

A representative application is the estimation of rare transition rates, such as the switching of a spatially extended bistable system between its two stable states. Direct simulation is inefficient here, because the transition occurs infrequently and the configuration space is too large to enumerate. In the operator formulation the rate is a ratio of contractions: the distribution is projected onto the initial basin, evolved under the generator, and projected onto the target basin, with the rate read off from the growth of the projected probability.

This procedure has been implemented for a reaction-diffusion chain by representing the distribution as a Matrix Product State and the generator as a Matrix Product Operator, and propagating the compressed state with the time-dependent variational principle\cite{nicholson2023}, which yields the switching rate without a prescribed reaction coordinate. A closely related approach applies the [[density-matrix renormalization group|mps/algorithms/dmrg]] to survey the rate constants of a well-mixed network, constructing the joint distribution over correlated copy numbers as a tensor network and tracking its variation across parameter space\cite{zima2025}.

The same operator-to-tensor-network route has been pursued in many groups, from tensor-train solvers for the chemical master equation\cite{kazeev2014,gelss2016} to matrix-product-state methods for driven and large-deviation dynamics\cite{banuls2019} and broader treatments of stochastic mechanics\cite{baez2018}. The framework is modular: the occupation-number construction supplies the local operator structure, tensor diagram notation makes it explicit, and the Matrix Product State and Operator provide the compression that extends it to systems well beyond direct enumeration.
