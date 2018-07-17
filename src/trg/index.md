# Case Study: TRG Algorithm

The handful of techniques we have covered so far (ITensor contraction and SVD)
are already enough to implement a powerful algorithm: the *tensor renormalization group*
(TRG).

First proposed by Levin and Nave (cond-mat/0611687), TRG is a strategy for contracting a network
of tensors connected in a two-dimensional lattice pattern by decimating the network
in a heirarchical fashion. The term ["renormalization group"](http://physics.ohio-state.edu/~jay/846/Wilson.pdf) 
refers to processes where less important information at small distance scales is 
repeatedly discarded until only the most important information remains.

## The Problem

TRG can be used to compute certain large, non-trivial sums by exploiting
the fact that they can be recast as the contraction of a lattice of small tensors.

A classic example of such a sum is the "partition function" $Z$ of the classical Ising
model at temperature T, defined to be

@@
Z = \sum_{\sigma_1 \sigma_2 \sigma_3 \ldots} e^{-E(\sigma_1,\sigma_2,\sigma_3,\ldots)/T}
@@

where each Ising "spin" ``\sigma`` is just a variable taking the values ``\sigma = +1, -1`` and the energy
$E(\sigma_1,\sigma_2,\sigma_3,\ldots)$ is the sum of products ``\sigma_i \sigma_j`` of 
neighboring ``\sigma`` variables.
In the two-dimensional case described below, there is a "critical" temperature ``T_c=2.269\ldots``
at which this Ising system develops an interesting hidden scale invariance.


### One dimension

In one dimension, spins only have two neighbors since they are arranged along a chain.
For a finite-size system of N Ising spins, the usual convention is to use periodic boundary conditions 
meaning that the Nth spin connects back to the first around a circle:
@@
E(\sigma_1,\sigma_2,\sigma_3,\ldots,\sigma_N) 
 = \sigma_1 \sigma_2 + \sigma_2 \sigma_3 + \sigma_3 \sigma_4 + \ldots + \sigma_N \sigma_1 \:.
@@

The classic "transfer matrix" trick for computing ``Z`` goes as follows:
@@
Z = \sum_{\{\sigma\}} \exp \left(\frac{-1}{T} \sum_n \sigma_n \sigma_{n+1}\right)
 = \sum_{\{\sigma\}} \prod_{n} e^{-(\sigma_n \sigma_{n+1})/ T}
 = \text{Tr} \left(M^N \right)
@@

where ``\text{Tr}`` means "trace" and the transfer matrix ``M`` is a 2x2 matrix with elements

@@
M_{\sigma^{\\!} \sigma^\prime} = e^{-(\sigma^{\\!} \sigma^\prime)/T} \ .
@@

Pictorially, we can view ``\text{Tr}\left(M^N\right)`` as a chain of tensor contractions around a
circle:

<img class="diagram" width="60%" src="docs/book/images/TRG_1dIsingZ.png"/>

With each 2-index tensor in the above diagram defined to equal the matrix M, it is an exact
rewriting of the partition function ``Z`` as a tensor network.

For this one-dimensional case, the trick to compute ``Z`` is just to diagonalize ``M``. 
If ``M`` has eigenvalues ``\lambda_1`` and ``\lambda_2``, it follows that 
``Z = \lambda_1^N + \lambda_2^N`` by the basis invariance of the trace operation.

###  Two dimensions

Now let us consider the main problem of interest. For two dimensions, the energy function
can be written as
@@
E(\sigma_1, \sigma_2, \ldots) = \sum_{\langle i j \rangle} \sigma_i \sigma_j
@@
where the notation ``\langle i j \rangle`` means the sum only includes ``i,j`` which are
neighboring sites. It helps to visualize the system:

<img class="diagram" width="60%" src="docs/book/images/TRG_2dIsingZ.png"/>

In the figure above, the black arrows are the Ising spins ``\sigma`` and the 
blue lines represent the local energies ``\sigma_i \sigma_j``.
The total energy ``E`` of each configuration is the sum of all of these local energies.


Interestingly, it is again possible to rewrite the partition function sum
``Z`` as a network of contracted tensors. Define the tensor ``A^{\sigma_t \sigma_r \sigma_b \sigma_l}``
to be 
@@
A^{\sigma_t \sigma_r \sigma_b \sigma_l} = e^{-(\sigma_t \sigma_r + \sigma_r \sigma_b + \sigma_b \sigma_l + \sigma_l \sigma_t)/T}
@@

<img class="diagram" width="15%" src="docs/book/images/TRG_Atensor.png"/>

The interpretation of this tensor is that it computes the local energies between the four spins that
live on its indices, and its value is the Boltzmann probability weight ``e^{-E/T}`` associated with
these energies. Note its similarity to the one-dimensional transfer matrix ``M``.

With ``A`` thus defined, the partition function ``Z`` for the two-dimensional Ising model can
be found by contracting the following network of ``A`` tensors:

<img class="diagram" width="35%" src="docs/book/images/TRG_2dPeriodic.png"/>

The above drawing is of a lattice of 32 Ising spins (recall that the spins live on
the tensor indices). The indices at the edges of this square wrap around in a periodic
fashion because the energy function was defined using periodic boundary conditions.

## The TRG Algorithm

TRG is a strategy for computing the above 2d network, which is just equal to a single number ``Z``
(since there are no uncontracted external indices). The TRG approach is to locally replace 
individual ``A`` tensors with pairs of lower-rank tensors which guarantee the result of the contraction
remains the same to a good approximation. These smaller tensors can then be recombined in a different 
way that results in a more sparse, yet equivalent network.

Referring to the original ``A`` tensor as ``A_0``, the first "move" of 
TRG is to factorize the ``A_0`` tensor in two different ways:

<img class="diagram" width="85%" src="docs/book/images/TRG_factor2ways.png"/>

Both factorizations can be computed using the [[singular value decomposition (SVD)|book/itensor_factorizing]].
For example, to compute the first factorization, view ``A_0`` as a matrix with a collective "row"
index ``\sigma_l`` and ``\sigma_t`` and collective "column" index ``\sigma_b`` and ``\sigma_r``. 
After performing an SVD of ``A_0`` in this way, further factorize the singular value matrix ``S`` as ``S = \sqrt{S} \sqrt{S}`` and 
absorb each ``\sqrt{S}`` factor into 
U and V to create the factors ``F_1`` and ``F_2``. Pictorially:

<img class="diagram" width="100%" src="docs/book/images/TRG_factorizing.png"/>

Importantly, the SVD is only done approximately by retaining just the ``\chi`` largest singular
values and discarding the columns of U and V corresponding to the smaller singular values.
This truncation is crucial for keeping the cost of the TRG algorithm under control.

Making the above substitutions, either
``A_0=F_1 F_3`` or ``A_0=F_2 F_4`` on alternating lattice sites, transforms the
original tensor network into the following network:

<img class="diagram" width="90%" src="docs/book/images/TRG_network1.png"/>

Finally by contracting the four F tensors in the following way

<img class="diagram" width="40%" src="docs/book/images/TRG_group.png"/>

one obtains the tensor ``A_1`` which has four indices just like ``A_0``.
Contracting the ``A_1`` tensors in a square-lattice pattern gives the 
same result (up to SVD truncation errors) as contracting the original ``A_0`` tensors,
only there are half as many ``A_1`` tensors (each ``A_0`` consists
of two F's while each ``A_1`` consists of four F's).

<img class="diagram" width="80%" src="docs/book/images/TRG_recombine.png"/>

To compute ``Z`` defined by contracting a square lattice of ``2^{1+N}`` tensors, one
repeats the above two steps (factor and recombine) N times until only a single
tensor remains. Calling this final tensor ``A_N``, the result ``Z`` of contracting
the original network is equal to the following "double trace" of ``A_N``:

<img class="diagram" width="20%" src="docs/book/images/TRG_top.png"/>

### Implementing TRG in ITensor

Finally we are ready to implement the algorithm above using ITensor.
At the end of this section we will arrive at a complete working code,
but let's look at each piece step by step.

To get started, start with the following empty application:

    #include "itensor/all_basic.h"

    using namespace itensor;

    int main() 
    {

    //Our code will go here

    return 0;
    }

First define some basic parameters of the calculation, such as the temperature "T"; the
maximum number  of singular values "maxm"; and the top-most scale we want to reach
with TRG:

    Real T = 3.0;
    int maxm = 20;
    int topscale = 6;

Next define the indices which will go on the initial "A"
tensor:

    auto m0 = 2;
    auto x = Index("x0",m0,Xtype);
    auto y = Index("y0",m0,Ytype);
    auto x2 = prime(x,2);
    auto y2 = prime(y,2);

Here it is good practice to save the index dimension ``m_0=2`` into its own variable
to prevent "magic numbers" from appearing later in the code. The constants
`XType` and `YType` are "IndexType" tags which let us conveniently manipulate only horizontal
or only vertical indices later on. It is also convenient to save copies of x and 
y with prime level raised to 2 as the variables x2 and y2.

Now let's create the "A" tensor defining the partition function and set its values as discussed
in the previous section:

    auto A = ITensor(x,y2,x2,y);

    auto Sig = [](int s) { return 1.-2.*(s-1); };

	auto E0 = -4.0;

    for(auto s1 : range1(m0))
    for(auto s2 : range1(m0))
    for(auto s3 : range1(m0))
    for(auto s4 : range1(m0))
        {
        auto E = Sig(s1)*Sig(s2)+Sig(s2)*Sig(s3)
                +Sig(s3)*Sig(s4)+Sig(s4)*Sig(s1);
        auto P = exp(-(E-E0)/T);
        A.set(x(s1),y2(s2),x2(s3),y(s4),P);
        }

The first line creates the "A" tensor with indices x,y2,x2,y and all elements set to zero.
The next line defines a "lambda" function bound to the variable name Sig which converts integers
1 and 2 into Ising spin values +1.0 and -1.0. To set the elements of A, we loop over integers
s1,s2,s3,s4. The function `range1(d)` returns an object that can be used in a `for` loop to
iterate over the integers 1,2,3,...,d.

One slight difference with the convention of the previous section is that here 
the Boltzmann probability weight P has an energy shift of `E0 = -4.0` in the exponent. This 
will keep the norm of the rescaled A tensors from growing too quickly later. Though it changes
``Z``, it does so in a way that is easy to account for.

Finally we are ready to dive into the main TRG algorithm loop. To reach scale ``N`` we need to
do ``N-1`` steps, so we will write a loop that does this number of steps:

    for(auto scale : range(topscale))
        {
        printfln("\n---------- Scale %d -> %d  ----------",scale,1+scale);

        //...TRG algorithm code will go here...

		}

In contrast to the earlier `range1` function which starts at 1, `range(topscale)` makes the `for` loop
run over 0,1,...,topscale-1.

In the body of this loop let us first "grab" the x and y indices of the A tensor at the
current scale. 

	auto y = noprime(findtype(A,Ytype));
	auto y2 = prime(y,2);
	auto x = noprime(findtype(A,Xtype));
	auto x2 = prime(x,2);

Although on the first pass these are just the same indices we defined before, 
new indices will arise as A refers to tensors at higher scales.

The function `findtype(T,IndexType)` searches through the indices of a tensor and returns
the first index whose type matches the specified IndexType. Since we want the version of 
this index with prime level 0, we call noprime to reset the prime level to zero. We 
also create versions of these indices with prime level 2 for convenience.

Now it's time to decompose the current A tensor as discussed
in the previous section. First the `A=F1*F3` factorization:

	auto F1 = ITensor(x2,y);
	auto F3 = ITensor(x,y2);
	auto xname = format("x%d",scale+1);

	factor(A,F1,F3,{"Maxm",maxm,"ShowEigs",true,
					"IndexType",Xtype,"IndexName",xname});

We create the ITensors F1 and F3 with the indices of A we
want them to have after the factorization. This tells the `factor` routine how
to group the indices of A. Along with the tensors, we pass some [[named arguments|tutorials/args]].
The argument "Maxm" puts a limit on how many singular values are kept in the SVD. Setting "ShowEigs"
to `true` shows helpful information about the truncation of singular values (actually the squares
of the singular values which are called "density matrix eigenvalues"). Also we pass an IndexType and 
name for the new index which will be created to connect F1 and F3.
The line `auto xname = format("x%d",scale+1);` is a string formatting operation; if for example `scale == 2`
then xname will be "x3".

We can write very similar code to do the `A=F2*F4` factorization, the main difference being
which indices of A we request to end up on F2 versus F4:

	auto F2 = ITensor(x,y);
	auto F4 = ITensor(y2,x2);
	auto yname = format("y%d",scale+1);

	factor(A,F2,F4,{"Maxm=",maxm,"ShowEigs=",true,
					"IndexType=",Ytype,"IndexName=",yname});

For the last step of the TRG algorithm we combine the factors of the A tensor at the current
scale to create a "renormalized" A tensor at the next scale:

	auto l13 = commonIndex(F1,F3);
	A = F1 * noprime(F4) * prime(F2,2) * prime(F3,l13,2);

The first line grabs a copy of the index common to F1 and F3, which is convenient to
have for the next line. The second line first contracts F1 with F4, then the result of this
contraction with F2, and finally with F3 to produce the new A tensor. The functions
wrapping the F tensors adjust the prime levels of various indices so that the indices we
want contracted with match while the indices we don't want contracted will have unique
prime levels.

In more detail, `noprime(F4)` returns a copy of F4 (without copying F4's data) such that all
indices have prime level 0. Calling `prime(F2,2)` increases the prime level of all of F2's indices
by 2. And `prime(F3,l13,2)` raises the prime level of just the index `l13` by 2. Try drawing
the tensor diagram showing the contraction of the F tensors to convince yourself that the 
prime levels work out correctly.

Last but not least, after we have proceeded through each scale
we want to take the last A tensor at the "top scale" specified and 
compute observables from it. Though this tensor contains a wealth of information,
we will look at the simplest case of computing the partition function ``Z``.

To obtain ``Z`` from the top tensor, all we have to do is trace both the x indices with each
other and trace the y indices with each other, which results in a scalar tensor whose
value is ``Z``:

<img class="diagram" width="20%" src="docs/book/images/TRG_top.png"/>

In ITensor, you can compute a trace by creating a special type of sparse ITensor 
called a `delta`. A `delta` tensor has only diagonal elements, all equal to 1.0.
Pictorially, you can view the delta tensors as the dashed lines in the above diagram.

Let us grab the x and y indices of the top tensor:

    auto xt = noprime(findtype(A,Xtype));
    auto yt = noprime(findtype(A,Ytype));
    auto xt2 = prime(xt,2);
    auto yt2 = prime(yt,2);

Then use these indices to create delta tensors:

    auto Trx = delta(xt,xt2);
    auto Try = delta(yt,yt2);

Finally we contract these tensors with "A" and convert the result to a real
number to obtain ``Z``:

    auto Z = (Trx*A*Try).real();

An interesting quantity to print out is ``\ln(Z)/N_s`` where ``N_s = 2^{1+N}`` 
is the number of sites "contained" in the top tensor at scale ``N``:

    Real Ns = pow(2,1+topscale);
    printfln("log(Z)/Ns = %.12f",log(Z)/Ns);

With the conventions for the probability weights we have chosen, we can check
``\ln(Z)/N_s`` against the following exact result (for an infinite-sized system):
@@
\ln(Z)/N_s = -2\beta + \frac{1}{2} \ln(2) + \frac{1}{2\pi} \int_0^\pi\, d\theta \ln{\Big[ \cosh(2\beta)^2 + \frac{1}{k} \sqrt{1+k^2-2k\cos(2\theta)}\,\Big]}
@@
where the constant ``k=1/\sinh(2\beta)^2`` and recall ``\beta=1/T``.

Click the link just below to view a complete, working sample code you can compile yourself. Compare the value of
``\ln(Z)/N_s`` you get to the exact result. How does adjusting `maxm` and `topscale` affect your result?

<div class="example_clicker">Click here to view the full example code</div>

    include:docs/book/trg.cc

<img class="icon" src="docs/install.png"/>&nbsp;<a href="docs/book/trg.cc">Download the full example code</a>


### Next Steps for You to Try

1. Modify the sample application to read in parameters
  from a file, using the ITensor [[input parameter system|tutorials/input]].

2. Following the details in the appendix of the "Tensor Network Renormalization"
   paper arxiv:1412.0732, for the critical temperature ``T_c=2/\ln(1+\sqrt{2})`` trace 
   the top-scale "A" tensor in the x direction, then
   diagonalize the resulting matrix to obtain the leading scaling dimensions of
   the critical 2 dimensional Ising model.

3. Following the paper arxiv:0903.1069, include an "impurity tensor" which
   measures the magnetization of a single Ising spin, and compare your results
   at various temperatures to the [exact solution](https://en.wikipedia.org/wiki/Square-lattice_Ising_model).


*Pro Tip*: for tasks 2 and 3 above, it is a good idea to modify the TRG code such that A gets 
normalized after each step, for example by adding a line `A /= norm(A);`. 
The exact normalization is not so important (trace norm versus Frobenius norm); the idea is to 
prevent A from getting too big, which will definitely occur after too many iterations.
When computing observables such as the magnetization, it is sufficient to use the "effective" 
partition function ``Z_\text{eff}`` obtained by double-tracing the top-scale A, regardless
of how it is normalized.

### References

- *The original paper on TRG*:

  Levin and Nave, "Tensor Renormalization Group Approach to Two-Dimensional Classical Lattice Models",
  [PRL 99, 120601](http://dx.doi.org/10.1103/PhysRevLett.99.120601) (2007)  cond-mat/0611687

- *Paper on TRG with very useful figures (particularly Fig. 5)*:

  Gu, Levin, and Wen, 
  "Tensor-entanglement renormalization group approach as a unified method for symmetry
  breaking and topological phase transitions"
  [PRB 78, 205116](http://dx.doi.org/10.1103/PhysRevB.78.205116) (2008)  arxiv:0806.3509

- *TNR is an extension of TRG which qualitatively improves TRG's fixed-point behavior
   and can be used to generate MERA tensor networks*:

  Evenbly and Vidal, "Tensor Network Renormalization"
  [PRL 115, 180405](http://dx.doi.org/10.1103/PhysRevB.80.155131) (2015) arxiv:1412.0732

<br/>


<span style="float:left;"><img src="docs/arrowleft.png" class="icon">
[[Factorizing ITensors|book/itensor_factorizing]]
</span>
<span style="float:right;"><img src="docs/arrowright.png" class="icon">
[[IQTensor Overview|book/iqtensor_overview]]
</span>

<br/>
