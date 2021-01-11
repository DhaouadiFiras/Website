+++
date = "2019-04-02"
title = "A very basic introduction to Hamilton's principle"
slug = "hamilton"
+++

<p style="text-align: justify"> 
When we effortlessly let go of an object, say a tennis ball for example, we instinctively know it will fall straightforwardly to the ground. such a  predicition is based on our experience and daily observations. If the ball simply went up instead of falling, this would not feel right, because it was never observed before. This simple exeperience shows that nature is picky: for given circumstances, it does not behave randomly but rather seems to carefully choose one realizable outcome out of all possibilities (at least in classical mechanics). The question is : Which one ? 
</p>  
<p style="text-align: justify"> 
<img style="float: right;margin-left:20px;margin-bottom:10px" src="/images/tennis.svg">

<p style="text-align: justify"> 
To answer this question in general, there have been countless attempts to provide models which best describe the motion and the evolution of systems. The best of these models seem to originate from the idea that nature chooses the easiest path i.e. which minimises some cost for her. Finding such a path defines what we call a variational problem and requires the use of a suitable variational principle.  In our case, we will be using <a href="https://en.wikipedia.org/wiki/Hamilton%27s_principle" target="_blank">Hamilton's principle</a> of stationary action. This is a very powerful tool that allows to establish the equations of motion of a dissipationless system, provided you know its potential and kinetic energies (and provided you also know how to handle all the calculus that may follow). Let's demonstrate how it works on the tennis ball example. Assume the ball is identified by the position of its center in cartesian coordinates $(x,y,z)$ and is only submitted to its own weight.  Its potential energy $E_p$ and kinetic energy $E_k$ can be expressed as : 
<font size="2"> 
\begin{equation*}
E_p = mgz \qquad \qquad E_k = \frac{1}{2}mv^2 = \frac{1}{2}m(\dot{x}^2+\dot{y}^2+\dot{z}^2) 
\end{equation*}
</font>
Now applying Hamilton's principle to the Lagrangian $\mathcal{L} = E_k-E_p$ yields the following Euler-Lagrange equations : 

<font size="2"> 
\begin{equation*}
    \begin{cases}
    \displaystyle \frac{d \dot{x}}{dt} =0 \\[4pt]
    \displaystyle \frac{d \dot{y}}{dt} = 0 \\[4pt]
    m\ddot{z} = mg
    \end{cases}
\end{equation*}
</font>
Let's explain what this means. The first two equations mean that there is no acceleration in the $x$ and $y$ direction. If at the instant you dropped the ball you did not give any speed along $x$ or $y$, then the ball will not acquire any by itself. Therefore, if the ball moved, it will be along the z axis. The last equation means that the acceleration in the $z$ direction is equal to $g$. 

</p>  
