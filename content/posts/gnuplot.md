+++
date = "2020-04-30"
title = "Producing LaTeX figures with Gnuplot"
slug = "gnuplot"

+++
<p style="text-align: justify"> 
Gnuplot is a very handy tool when it comes to producing figures to be included into your work, be it a report, article or any of the like. It offers much capability and enough options to produce graphs that boost the quality and presentation of your paper. But, as is the case with any programming language, it takes some time and patience to learn how to actually it efficiently.  
I use Gnuplot mainly for one dimensional graphs to be inserted in LaTeX documents. For me, any figure should satisfy the following requirements :  

1. **It's formatted as vector graphics :** Vector graphics are more reliable when it comes to quality. Unless you use some trillions of pixels, a bitmap image turns very quickly into a mess when you zoom for details.
2. **Its Labels and axis graduations are effortlessly visible :** This is important especially in slides for oral presentations. Graduations and labels must be clearly visible, otherwise the figure may lose its purpose. 
3. **It blends well with the surroundings where it's inserted :** The figure should be in harmony with the text around it. For instance, it would be better if it shares the same fonts and should have as little extra white space as possible.

Assuming you have an up-to-date version of gnuplot (and LaTeX) installed and working, let's get started. 
### Creating the figure
What I do is actually generate a .tex file with gnuplot. Then, I compile this file with Latex to obtain the output pdf. For a multistep process I generally recommend using a bash script that does all the work in one-line command.
Consider for example the following "minimal" gnuplot script: 

``` gnuplot
set terminal epslatex standalone size 15cm,7cm color colortext 12
set output 'figure.tex'
set grid 
plot sin(x) ,cos(x) 
```
If this script is saved as 'plotscript' in a directory `/path/to/dir` then running the following in a terminal :
```bash
cd /path/to/dir
gnuplot plotscript
```
generates a 'figure.tex' file. Since we use the `standalone` option, this tex file has the necessary headings and is compilable on its own, for example by using :
```bash
pdflatex figure.tex
```
This will finally generate a 'figure.pdf' alongside the usual latex outputs (which you can remove if you want). The figure should look like this : 
<img style="display:block; margin-left: auto; margin-right: auto;"src="/images/gnu1.svg">
Test it yourself:  

1. Download the <a href="/files/plotscript" target="_blank"> <i class="far fa-file"></i> test script </a> and the <a href="/files/plotfigure" target="_blank"> <i class="far fa-file"></i> bash script</a>.
2. Put them in some directory `'/path/to/dir'` .
3. Open a terminal and : 

``` bash
cd path/to/dir
bash plotfigure
```

### Enhancing quality
We can try to make the previous graph look a little bit better. We can for instance :

1. Add arrows and labels to the both axes.   
2. Make more meaningful graduations.
3. Add more resolution points to the curves.
4. Customize the key.

But first, let us define some line styles. It helps to have some predefined styles you set at your own convenience for future uses : 

```gnuplot
set style line 1 lc rgb '#dd181f' lt 1 lw 2 dt 2 
set style line 2 lc rgb '#0060ad' lt 1 lw 2  
set style arrow 1 head filled size screen 0.022,20,30 lw 2 lc rgb "black"
```

Then let us add the axes : 

```gnuplot 
#x-Axis
set arrow from graph 0,0 to graph 1,0 arrowstyle 1 front
set label 1 "$x$" at graph 1.02,0.01
#y-Axis
set arrow from graph 0,0 to graph 0,1 arrowstyle 1
set label 2 "$y$" at graph -0.01,1.05
```

We define the plot range and add custom graduations : 

```gnuplot
pi=3.141569265359
set xrange[0:5*pi]
set xtics ("$0$" 0,'$\pi$' pi,'$2\pi$' 2*pi,'$3\pi$' 3*pi,'$4\pi$' 4*pi,'$5\pi$' 5*pi) 
set yrange[-1.2:1.5]
set ytics (-1,-0.5,0,0.5,1)
set tic scale 0.5
```

We add more points to have smoother lines : 

```gnuplot
set samples 2000
```

and finally customise the key : 

```gnuplot 
set key box at graph 0.98,0.95
```
The full script is available <a href="/files/script" target="_blank">here</a>. The output should now look like this : 
<img style="display:block; margin-left: auto; margin-right: auto;"src="/images/gnu2.svg">
