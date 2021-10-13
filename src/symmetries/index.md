# Symmetries in Tensor Networks

_[This article is currently a placeholder - please help to expand it!]_

A variety of symmetries can be exactly preserved with tensor networks,
most notably symmetries corresponding to the action of a group on the 
individual tensor indices. For cases such as infinite tensor networks,
other symmetries like translation invariance can be enforced.


## Global "On Site" Symmetries

A case that has been studied in great detail are symmetries of tensors and
tensor networks under the action of a group, where the representation of 
the group is a tensor product of the group action on each external, or "site"
index of the tensor or tensors. (For an introduction to group theory,
the book by [Arovas](https://courses.physics.ucsd.edu/2016/Spring/physics220/LECTURES/GROUP_THEORY.pdf) 
is recommended.\cite{Arovas}.)

The general theory of tensor networks which are symmetric under such operations
is reviewed in Ref. \onlinecite{SinghGlobal:2010}.
Many more details about the cases of the groups $U(1)$ and $SU(2)$
can be found in Ref. \onlinecite{SinghU} and \onlinecite{SinghSU2}, respectively.

For tensor networks symmetric under Abelian groups such as $\mathbb{Z}_2$ or $U(1)$, the main
consequence is that each tensor in the network can be taken to be block-sparse without
loss of generality. Thus many of the elements of the tensor can be assumed to be zero,
and then are not stored in memory or explicitly used in computations, leading to significant
gains in performance.

For tensor networks which are symmetric under non-Abelian groups such as $SU(2)$, 
the consequences are similar but the internal structure of the tensors in the network can 
be constrained to a greater degree, yielding much larger (lossless) compression 
compared to the Abelian case. However, the non-Abelian case is much more technical to
implement, so that some authors have published detailed discussions of the implementation
of $SU(2)$ symmetries in code.\cite{Schmoll:2020,SinghSU2,Fledderjohann:2011}


