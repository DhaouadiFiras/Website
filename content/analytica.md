+++
slug = "analytica"
+++
## Analytica: A Wolfram Mathematica code for analyzing nonlinear hyperbolic PDEs. 

*Brdiging the gap between mathematical equations on paper and numerical schemes on computers*
Analytica is a software written in the formal programming language of Wolfram Mathematica.
It analyzes hyperbolic PDEs by computing eigenvalues of the corresponding quasilinear system, the corresponding eigenvectors, and verifies strong hyperbolicity by checking for missing eigenvectors in multiple eigenvalues.
It also generates pieces of Fortran code allowing to immediately implement the considered system of PDE in three space dimensions. In particular it generates the following parts, already written as generic functions of the conserved variables
- The flux functions in all three dimensions
- The non-conservative terms
- The source terms
- The eigenvalues
- The mappings from conservative to primitive variables and the inverse mapping
- Sample parameter files and their respective declarations and related functions

It also generates the LaTeX input for the quasilinear matrix and its eigenvalues.
<!-- ### User Input : The PDE system written as on paper
The main objective of this code is to simplify the implementation of hyperbolic PDEs into computational codes as much as possible, without having to spend hours developing the equations and computing all the terms, in order to save time and reduce risk errors.  -->


### Download
A zip file with all the code files can be downloaded from [{{< fas "file-zipper" >}} here](Analytica.zip) 
<!-- 
```Mathematica
f[x_]:=Sin[x]
``` -->