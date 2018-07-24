
# Matrix Product State / Tensor Train

The matrix product state (MPS)\cite{Fannes,Ostlund} or tensor train (TT)\cite{Oseledets} tensor network
is a factorization of a [[tensor|tensor]] with N indices
into a chain-like product of three-index tensors.
The MPS/TT is one of the best understood tensor networks for which
many efficient algorithms have been developed, in part because
because it is a special case of a [[tree tensor network|ttn]]. 

A matrix product state / tensor train factorization of a tensor $T$ 
can be expressed in [[tensor diagram notation|diagrams]] as

![medium](mpstt_diagram.png)

where for concreteness $T$ is taken to have six indices. But the 
pattern above can be generalized without loss of efficiency for
a tensor with an arbitrary number of indices.;

Alternatively, the MPS/TT factorization of a tensor
can be expressed in traditional notation as

<div>@@
T^{s_1 s_2 s_3 s_4 s_5 s_6} = \sum_{\alpha} A^{s_1}_{\alpha_1} 
A^{s_2}_{\alpha_1 \alpha_2}
A^{s_3}_{\alpha_2 \alpha_3} 
A^{s_4}_{\alpha_3 \alpha_4} 
A^{s_5}_{\alpha_4 \alpha_5} 
A^{s_6}_{\alpha_5}
@@</div>

