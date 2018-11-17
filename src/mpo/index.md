# Matrix Product Operator (MPO)

A matrix product operator (MPO) is a tensor network where each tensor has two external, uncontracted indices as well as two internal indices contracted with neighboring tensors in a chain-like fashion. Intuitively, if one thinks of a matrix product state (MPS) as parameterizing a large "vector" in a high-dimensional space, then an MPO is the generalization to the case of a "matrix" acting in the same space. 

In traditional notation, an MPO is a tensor network of the form

\begin{equation}
M^{s_1 s_2 s_3 s_4 s_5 s_6}_{s'_1 s'_2 s'_3 s'_4 s'_5 s'_6}
= \sum_{\{\mathbf{\alpha}\}} A^{s_1 \alpha_1}_{s'_1} 
A^{s_2 \alpha_2}_{\alpha_1 s'_2}
A^{s_3 \alpha_3}_{\alpha_2 s'_3}
A^{s_4 \alpha_4}_{\alpha_3 s'_4}
A^{s_5 \alpha_5}_{\alpha_4 s'_5}
A^{s_6}_{\alpha_5 s'_6}
\end{equation}

One of the key uses of MPOs is to represent large, sparse matrices in a form convenient for MPS algorithms, such as finding MPS approximations of eigenvectors. MPOs also arise in certain algorithms for approximately contracting [[PEPS tensor networks|peps]].

# Content Needed for this Page

- Examples of exact MPO representations

- Representing long-range Hamiltonians with MPOs

- Zalatel, Mong, Pollmann approach for approximating exponentials of Hamiltonian (Hermitian) matrices as MPOs