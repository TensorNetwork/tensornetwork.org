## Resources and Tips for Machine Learning with Tensor Networks

### Initializing tensor network parameters

A challenging aspect of optimizing tensor networks for use as 
machine learning models is initializing their parameters so as
to avoid floating-point underflow and overflow issues early
in the optimization. (Near the optimum this is no longer an issue.)

For the specific case of matrix product state tensor networks,
some of the tricks that have been found to work well are:

* _Initializing the MPS matrices to identity matrices_. Thinking of 
  MPS tensors as a collection of matrices selected by setting the visible
  index to different values, choose each of these matrices to be the identity.
  Though this will not give good initial performance on the machine learning task,
  it will ensure that the initial model outputs numbers of a reasonable size.

* _Initializing the MPS from a trained linear classifier_. Linear classifiers
  are easy to train and can give surprisingly good performance for how simple
  they are. Then, an MPS of bond dimension 2 can be written down which parameterizes
  a model which is exactly equivalent to a linear classifier. The method for
  writing down this MPS is explained in the appendices of 
  Ref. \onlinecite{Novikov:2016}(version 2) and Ref. \onlinecite{Stoudenmire:2018L}.



