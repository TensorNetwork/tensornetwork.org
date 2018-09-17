# Tensor

A tensor is a representation of a multilinear function. 
The most familiar examples of tensors
are vectors and matrices, which can be viewed as linear functions of one and 
two arguments, respectively.

Because a linear function is completely specified by the values it takes on a basis,
it is customary to think of a tensor as a multidimensional array of these values,
known as the tensor components. From this point of view, a tensor is the same
as a multidimensional array, assuming one specifies the basis of the vector
space on which the tensor acts.

## Background: Vector Spaces

A [vector space](https://en.wikipedia.org/wiki/Vector_space) is a set of objects that can be added, subtracted, and multiplied
by scalars. More formally, a vector space is a set $V$ of "vectors" and an 
associated set $S$ of "scalars. The scalars are almost always chosen
to be the real numbers $\mathbb{R}$ or complex numbers $\mathbb{C}$.

The set $V$ is equipped with an operation "$+$" such that it forms an Abelian group. 
Multiplication of an element of $V$ by a scalar results in another element of the space.

### Example 1: real $N$-dimensional vectors 

The most familiar example of a vector space is $\mathbb{R}^N$. Elements of 
$\mathbb{R}^N$ are ordered collections of $N$ real numbers which can be 
added or subtracted element-wise and multiplied by real scalars.
These elements are the familiar real vectors, for example

\begin{align*}
\mathbf{v} & = (0.1,\  7.2,\ 3.0) \\\\
e^1 & = (1,0,0) \\\\
e^2 & = (0,1,0) \\\\
e^3 & = (0,0,1) \\\\
\mathbf{v} & = 0.1 e^1 + 7.2 e^2 + 3.0 e^3
\end{align*}


### Example 2: Hermitian matrices

A less familiar example of a vector space is the set of $N \times N$ 
Hermitian matrices. The sum of difference of Hermitian matrices is
also Hermitian, as is the product of a Hermitian matrix and a real
scalar. Note that allowing the scalars to be complex would *not*
result in a vector space, since the product of a Hermitian 
matrix with a complex number is not generally Hermitian.

## Background: Dual Vectors

Given a vector space $V$, one can consider the set of linear functions 
on $V$. This set is denoted $V^*$. By a linear function, what is meant 
is a function $f \in V^*$ such that

@@
f(\alpha \mathbf{v} + \beta \mathbf{w}) = \alpha f(\mathbf{v}) + \beta f(\mathbf{w})
@@

for any $\mathbf{v}, \mathbf{w} \in V$ and scalars $\alpha, \beta$.

It turns out that the set $V^*$ is a vector space, and is known as the *dual space*,
or the dual of the space $V$. Its elements are known as *dual vectors* or *covectors*.
The reason for the term *dual* is that just as elements of $V^*$ are linear functions
on $V$, likewise elements of $V$ can be viewed as linear functions on $V^*$.

In quantum physics, Dirac bra-ket notation is used to distinguish between vectors
and covectors, with "kets" being vectors and "bras" being covectors.

## Tensors

Given some vector space $V$, a tensor $T$ is a multilinear function whose
arguments are $r$ elements of $V^*$ and $s$ elements of $V$. 
Such a tensor is said to be of type $(r,s)$.

For example, a tensor of type $(1,1)$ is a function $T$ such that

@@
T(\alpha f + \beta g, \gamma v + \delta w)
= 
\alpha \gamma T(f,v) + \beta \gamma T(g,v) + \alpha \delta T(f,w) + \beta \delta T(g,w)
@@

Say that the vector spaces $V$ (and therefore $V^*$) are two-dimensional. Take
$\{e^1, e^2\}$ to be a basis of $V$ and $\{e_1, e_2\}$ a basis of $V^*$. Then 
the numbers

\begin{align}
T_{11} = T(e_1, e^1) \ ;\ T_{12} = T(e_1, e^2) \\\\
T_{21} = T(e_2, e^1) \ ;\ T_{22} = T(e_2, e^2)
\end{align}

