+++
date = "2019-01-10"
title = "My PhD Work"
slug = "my-phd"

+++

---
* **Subject:** Mathematical analysis and numerical simulation of dispersive models by Extended Lagrangians.
* **Advisors:** Jean-Paul Vila (PhD advisor), Nicolas Favrie (PhD co-advisor) , Sergey Gavrilyuk (Advisor)
* **Location:** This is a joint project between IMT (Toulouse) and IUSTI (Marseille).
* **Defense:** It will be held at IMT by the end of 2020 ( to be determined ).

---


#### The main motivation
<p style="text-align: justify"> 
The main motivation of my work is to derive a first order hyperbolic system that closely approximates dispersive equations of the Euler-Korteweg type. 
The latter can be seen as a generalization of Euler equations which takes dispersion into account and can be written in this form : 

<font size="2"> 
\begin{align}
&\rho_t + \mathrm{div}\left(\rho \mathbf{u}\right) = 0 \newline
&(\rho \mathbf{u})_t +\mathrm{div}\left(\rho \mathbf{u} \otimes \mathbf{u} + \mathbf{P}\right) = \nabla \left( K(\rho)\Delta \rho + \frac{1}{2}K'(\rho) \left| \nabla \rho \right|^2 \right)
\end{align}
</font>



For example, if $\rho$ is a positive fluid density and $\mathbf{u}$ is the associated velocity field, the left-hand side of this system corresponds exactly to Euler equations with a pressure tensor $\mathbf{P}$. Now, before moving on to giving more details about the right-hand side, let me explain first how such equations came to be.  
</p>  








