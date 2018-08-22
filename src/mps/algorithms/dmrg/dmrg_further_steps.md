
Next, combine the first two MPS tensors by contracting over their shared bond index:

![medium](bond1.png)

At the point, it is helpful to observe that the components of the resulting "bond tensor" $B^{i_1 i_2 \alpha}_{12}$ are not just partial information about the tensor $v$ represented by the MPS. Rather, they are the coefficients of $v$ in the $i_1, i_2, \alpha_2$ basis. If the $\alpha_2$ basis spans a subspace of the $i_3, i_4, \ldots, i_N$ space sufficient to represent the eigenvector of $H$ we seek, then optimizing $B_{12}$ to be the dominant eigenvector of the transformed $H$ is sufficient to solve the original problem.

In practice, however the $\alpha_2$ basis can be improved, and to do so the algorithm optimizes $v$ at every bond sequentially.

### Step 1: Optimization

To optimize the first bond tensor $B_{12}$, a range of procedures can be used, but often the most effective are iterative algorithms, either Davidson\cite{Davidson:1976} or Lanczos. 

The key step of each of these algorithms is the multiplication of $B_{12}$ by the (transformed) matrix $H$:

