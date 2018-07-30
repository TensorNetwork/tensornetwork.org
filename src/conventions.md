
Conventions for describing tensors and tensor networks:

- The range of values a single index can take is its _dimension_.

- The number of indices of a tensor is its _order_ (a matrix is an order-2 tensor).

- The tensors making up a tensor network are _factors_ or _factor tensors_.

- For a given tensor network, the contracted indices between factor tensors
  are _internal indices_. The uncontracted indices corresponding to the indices
  of the tensor the network represents are _external indices_.

- The term _rank_ refers to the minimum dimension of a factorization of a tensor
  with respect to some bipartition of its indices. 
