# Applications of Tensor Networks to Machine Learning

The use of tensor networks for machine learning is an emerging topic. 
One branch of research involves using a tensor network directly as machine 
learning model architecture. Another uses tensor networks to compress layers in neural network
architectures or for other auxilary tasks.

Because tensor networks can be exactly mapped to quantum circuits, an exciting direction
for tensor network machine learning is deploying and even training such models
on quantum hardware.


## Selected Works on Tensor Networks for Machine Learning

Influential or ground breaking works on theory, algorithms, or applications of tensor networks for machine learning.
Please help to expand this list by submitting a pull request to the [tensornetwork.org](https://github.com/tensornetwork/tensornetwork.org) Github repository.

### Supervised Learning

- [Exponential Machines](https://arxiv.org/abs/1605.03795), Alexander Novikov, Mikhail Trofimov, Ivan Oseledets, arxiv:1605.03795 (ICLR 2017 workshop track paper) <br/>
  _Proposes the use of tensor networks for supervised machine learning with an elegant interpretation of the function represented by the model and a stochastic Riemannian optimization procedure. State-of-the-art performance is demonstrated on multiple datasets._

- [Supervised Learning with Tensor Networks](https://proceedings.neurips.cc/paper/2016/file/5314b9674c86e3f9d1ba25ef9bb32895-Paper.pdf), E.M. Stoudenmire and David J. Schwab, Advances in Neural Information Processing Systems **29** (2016) \cite{NIPS2016_5314b967} <br/>
  _Proposes the use of tensor networks for supervised machine learning, emphasizing connections to the quantum physics literature including related algorithms for optimization. State of the art results are demonstrated for the MNIST handwriting dataset._

- [From probabilistic graphical models to generalized tensor networks for supervised learning](https://arxiv.org/abs/1806.05964), Ivan Glasser, Nicola Pancotti, J. Ignacio Cirac, arxiv:1806.05964 <br/>
  _Explores connections between tensor networks and graphical models. Proposes "generalized tensor network" architectures for machine learning, and explores learning of local feature maps._

### Unsupervised Learning

- [Unsupervised Generative Modeling Using Matrix Product States](https://journals.aps.org/prx/abstract/10.1103/PhysRevX.8.031012), Zhao-Yu Han, Jun Wang, Heng Fan, Lei Wang, and Pan Zhang, Phys. Rev. X 8, 031012 (2018). \cite{PhysRevX.8.031012}

- [Tree tensor networks for generative modeling](https://journals.aps.org/prb/abstract/10.1103/PhysRevB.99.155131), Song Cheng, Lei Wang, Tao Xiang, and Pan Zhang. Phys. Rev. B 99, 155131 (2019). \cite{PhysRevB.99.155131}

- [Tensor networks for unsupervised machine learning](https://arxiv.org/abs/2106.12974), Jing Liu, Sujie Li, Jiang Zhang, Pan Zhang, arxiv:2106.12974 <br/>
  _Explores the idea of representing a sequence of conditional probabilities as separate tensor networks to learn a full, or joint probability distribution._


### Compression of Machine Learning Architectures 

- [Tensorizing Neural Networks](), A. Novikov, D. Podoprikhin, A. Osokin, D. Vetrov, Advances in Neural Information Processing Systems **28** (2015) \cite{Tensorizing} <br/>
  _Proposes the use of "quantized" tensor train matrix (matrix product operator) decompositions to achieve a massive compression of weights of a neural network layer with only a small impact to performance._



### Mathematical or Theoretical Works

- [Expressive power of tensor-network factorizations for probabilistic modeling](https://papers.nips.cc/paper/2019/hash/b86e8d03fe992d1b0e19656875ee557c-Abstract.html), Ivan Glasser, Ryan Sweke, Nicola Pancotti, Jens Eisert, Ignacio Cirac, Advances in Neural Information Processing Systems **32** (2019) \cite{NEURIPS2019_b86e8d03} <br/>
  _Rigorously explores and compares the expressive power of various tensor network formats, parameterizations, and formalisms for using them to model complicated functions._

- [Lower and Upper Bounds on the VC-Dimension of Tensor Network Models](https://arxiv.org/abs/2106.11827), Behnoush Khavari and Guillaume Rabusseau, arxiv:2106.11827  \cite{khavari2021lower}

### Language Modeling

- [Explainable Natural Language Processing with Matrix Product States](https://arxiv.org/abs/2112.08628), Jirawat Tangpanitanon, et al. arxiv:2112.08628


