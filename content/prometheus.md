+++
slug = "prometheus"
+++
# PROMETHEUS: Hy{{< colored  P "#0065f3">}}erbolic {{< colored  R "#0065f3">}}eformulation {{< colored  O "#0065f3">}}f dispersive {{< colored  ME "#0065f3">}}chanics: {{< colored  TH "#0065f3">}}eory and n{{< colored  U "#0065f3">}}meric{{< colored  S "#0065f3">}}

*This project is funded in the framework of NextGenerationEU, Azione 247 MUR Young Researchers—SoE line.*
{{< img EU.svg 500 >}} 
In Project PROMETHEUS, we would like to provide a new framework that enables the rigorous description multiphase and turbulent flows. Such phenomena are ubiquitous in nature. For instance, the swirls and irregular patterns you may see in the flow of water in a river are due to turbulence. Waves on the water surface are due to dispersion and soda pouring in a glass is a typical example of a multiphase flow (the liquid together with the gas bubbles inside).

The challenge we would like to address in this project is not only to provide a rigorous mathematical model describing the structure of such flows but also to make it possible to easily solve it numerically in order to accurately simulate and analyze a wide range of real-world fluid flow phenomena and which are still very challenging up to now. The approach we propose consists in developing new equations and reformulating existing ones into first-order symmetric hyperbolic equations, derived from first principles and that are in line with the laws of physics and thermodynamics. Symmetric Hyperbolic equations offer a notably advantageous terrain both at the theoretical level (well-posedness, bounded speeds) but also at the numerical level since there is an extremely rich literature on general numerical methods able to address this type of equations even in the presence of discontinuities or steep gradients in the solutions. In this context, we have published the following papers  


### The Navier-Stokes-Korteweg model
{{< paperlinks 
    year     = "2023"
    title    = "A structure-preserving finite volume scheme for a hyperbolic reformulation of the Navier–Stokes–Korteweg equations"
    authors  = "Dhaouadi, F. and Dumbser, M., 2023"
    reference = "Mathematics, 11(4), p.876."
    journal = "https://www.mdpi.com/2227-7390/11/4/876"
    file = "Dhaouadi Dumbser 2023 - CurlFreeNSK.pdf"
 >}}
{{< paperlinks 
    year     = "2022"
    title    = "A first order hyperbolic reformulation of the Navier-Stokes-Korteweg system based on the GPR model and an augmented Lagrangian approach"
    authors  = "Dhaouadi, F. and Dumbser, M., 2023"
    reference = "Journal of Computational Physics, 470, p.111544."
    journal = "https://doi.org/10.1016/j.jcp.2022.111544"
    file = "Dhaouadi Dumbser 2022 - Hyperbolic NSK.pdf"
 >}}
### Heat transfer in compressible flows
{{< paperlinks 
    year     = "2024"
    title    = "An Eulerian hyperbolic model for heat transfer derived via Hamilton’s principle: analytical and numerical study"
    authors  = "Dhaouadi, F. and Gavrilyuk, S."
    reference = "Proceedings of the Royal Society A, 480(2283), p.20230440."
    preprint = "https://arxiv.org/abs/2305.12229"

    journal = "https://royalsocietypublishing.org/doi/abs/10.1098/rspa.2023.0440"

    code = "https://royalsocietypublishing.org/doi/suppl/10.1098/rspa.2023.0440"

    file = "Dhaouadi Favrie Gavrilyuk 2018 - Hyperbolic Heat.pdf"
 >}}
### The Cahn-Hilliard equation
{{< paperlinks 
    year     = "2024"
    title    = "A first-order hyperbolic reformulation of the Cahn-Hilliard equation"
    authors  = "Dhaouadi, F., Dumbser, M. and Gavrilyuk, S."
    reference = "arXiv:2408.03862. "
    preprint = "https://arxiv.org/abs/2408.03862"
    status = "accepted"
 >}}
### Romenski's two phase flow model
{{< paperlinks 
    year     = "2024"
    title    = "An exactly curl-free finite-volume scheme for a hyperbolic compressible barotropic two-phase model"
    authors  = "Río-Martín, L., Dhaouadi, F. and Dumbser, M."
    reference = "Journal of Scientific Computing 102 (1), 13"
    preprint = "https://arxiv.org/abs/2403.18724"
    journal = "https://link.springer.com/article/10.1007/s10915-024-02733-9"
    file = "SP_TwoFluid.pdf"
 >}}

