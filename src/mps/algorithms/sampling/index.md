# Sampling from an MPS / TT


Matrix product state (MPS) or tensor train (TT) tensor networks admit an
There is an efficient, direct sampling algorithm that can be used to sample
from any probability distribution that can be represented as an MPS/TT network.
This sampling algorithm can be used within the standard (or "one-norm") probability formalism
or in the two-norm (or "Born rule") probability formalism.

The algorithm described below can be extended to
any tensor network with a tree structure, and even to any tensor or
function approximator for which marginal probabilities can be computed efficiently.
(One such example are "autoregressive" neural networks.)

## Two-Norm Probability Sampling Algorithm

Consider an MPS/TT representing a tensor $T^{s_1 s_2 s_3 \cdots s_N}$
with $N$ indices. In other words,
\begin{equation}
T^{s_1 s_2 s_3 \cdots s_{N-1} s_{N}} = \sum_{\{\mathbf{\alpha}\}} A^{s_1}_{\alpha_1} 
A^{s_2}_{\alpha_1 \alpha_2}
A^{s_3}_{\alpha_2 \alpha_3} 
\cdots
A^{s_{N-1}}_{\alpha_{N-2} \alpha_{N-1}} 
A^{s_N}_{\alpha_{N-1}}
\end{equation}
or diagramatically
![medium](mps_representation.png)

Assume that the probability of observing the indices to have
the values $(s_1, s_2, s_3, \ldots, s_N)$ is given by
\begin{equation}
p(s_1, s_2, s_3, \ldots, s_N) = |T^{s_1 s_2 s_3 \cdots s_N}|^2
\end{equation}

The algorithm works by using the "chain rule" of probability
\begin{equation}
p(s_1, s_2, s_3, \ldots, s_N) = p(s_1) p(s_2|s_1) p(s_3|s_1 s_2) \cdots p(s_N|s_1 s_2 s_3 \cdots s_{N-1}) \ .
\end{equation}
Each factor in the expression on the right can be computed efficiently using MPS summation techniques, allowing one to draw a single sample from the full (or "joint") distribution on the left.

For simplicity, assume that the MPS is normalized so that $\sum_{\{s\}} |T^{s_1 s_2 s_3 \cdots s_N}|^2 = 1$, or diagrammatically
![medium](normalization_condition.png)




