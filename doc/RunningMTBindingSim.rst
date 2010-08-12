====================
Running MTBindingSim
====================

To plot a graph using MTBindingSim, select the plotting options and 
binding model you would like to use, enter the parameters you want, and 
click the graph button. This section explains what plotting options and 
binding models are available.

.. raw:: wikir
   
   <wiki:toc max_depth="1" />
   


Plotting Options
================

There are serveral sets of plotting options that can be selected. These 
options will apply to all graphed curves.

Experimental Method
-------------------

There are three avalible experimental methods. Curves from different 
experimental methods cannot be plotted on the same graph, so changing 
the experimental method will automatically close an active graph.

Screen shot of the experimental method selection box.

**Vary [MT]:** In this method, the concentration of A is held constant 
and the concentration of MT is varied. The fraction of A bound is 
graphed on the y-axis. This is a "standard" binding experiment and 
simulates data from many standard experimental methods of measuring 
binding data, including SPR, fluorescence anisotropy, and tryptophan 
fluorescence, as well as cosedimentation assays.

**Vary [A]:** In this method, the concentration of MT is held constant 
and the concentration of A is varied. The concentration of A bound is 
graphed on the y-axis. This kind of data cannot be collected using many 
standard binding assays such as SPR and fluorescence anisotropy, but it 
can be collected using a cosedimentation assay.

**Competition:** In this method, there are two MT binding proteins, A and 
B. The concentration of A and the concentration of MT are held constant 
while the concentration of B is varied. The fraction of A bound is 
plotted on the y-axis. This kind of data can be collected with many 
standard methods of measuring binding data, such as SPR, fluorescence 
anisotropy, tryptophan fluorescence, and cosedimentation assays.

Plotting Mode
-------------

MTBindingSim can plot one curve at a time or it can plot two curves 
simultaneously.

Screen shot of plotting mode box

For more information about comparing two curves see the `How To section 
<$(DOCS):HowTo>`_.

X-axis
------

In Vary [MT] mode, the X-axis can be set to either [MT] total or [MT] free.

Screen shot of X-axis MT

[MT] total is a known quantity in the experiment, while [MT] free must be 
calculated. However, the familiar Langmuir Isotherm uses [MT] free as 
its independent variable, and the quick method of determining K\ 
:sub:`D` by looking at the MT concentration when the fraction of A 
bound is 0.5 only works if the x-axis is [MT] free.

In Vary [A] mode, the x-axis can be set to either [A] total or [A] free.

Screen shot of x-axis A

Changing the x-axis mode will automatically close the active graph.

Number of Points
----------------

The number of points plotted may be specified.

Screen shot of number of points

The default number of points is 100. A larger number of points can be 
used if a smoother curve is desired. A smaller number of points will 
result in a faster calculation.

Binding Models
==============

MTBindingSim can plot curves for several binding models. For a detailed 
description of the math used to generate the curves, please see the 
`Binding Model Mathematics chapter <$(DOCS):BindingModels>`_. Note that 
all models use the dissociation constant, K\ :sub:`D`\ .

First Order Binding
-------------------

First order binding simulates binding under standard first order 
conditions where one A interacts with one MT, and all A-MT interactions 
are identical.

**Screen shot:** first order and inputs

For first order binding, you need to input the total concentration of A 
(or MT), the K\ :sub:`D`\ , and the binding ratio.  All of these must 
be positive numbers.

Traditional Cooperativity
-------------------------

Traditional cooperativity simulates binding where one A binding to one 
MT influences the binding of another A to a neighboring MT. For the 
purposes of this model only interactions between two As are considered.

**Screen shot:** cooperativity and inputs

For cooperativity, you need to input the total concentration of A (or 
MT), K\ :sub:`D`\, φ, which determines the dissociation constant for 
the second A, and the binding ratio. All inputs must be positive 
numbers.

Seam and Lattice Binding
------------------------

Seam and lattice binding simulates a scenario in which protein A binds 
to the MT seam with a different affinity than the MT lattice.

**Screen shot:** seam lattice and inputs

For this model you need to input the total concentration of A (or MT), 
the dissociation constants for the seam, K\ :sub:`S`\ , lattice, K\
:sub:`L`\ , and the binding ratio. All inputs must be positive numbers.

MAPs Bind MT-bound MAPs
-----------------------

In this model, once one A has bound to the MT, another A can bind to it 
without taking up another MT binding site.

**Screen shot:** MAPs binding and inputs

For this model, you need to input the total concentration of A (or MT), 
the dissociation constant for A binding to MT, K\ :sub:`M`\ , the 
dissociation constant for A binding to MT-bound A, K\ :sub:`A`\ , and the 
binding ratio. All inputs must be positive numbers.

Two MAPs Bind MT-bound MAPs
---------------------------

In this model, once one A has bound to the MT, two more As can bind to 
it without taking up additional MT binding sites.

**Screen shot:** 2MAP binding

For this model, you need to input the total concentration of A (or MT), 
the dissociation constant for A binding to MT, K\ :sub:`M`\ , the 
dissociation constant for A binding to MT-bound A, K\ :sub:`A`\ , and the 
binding ratio. All inputs must be positive numbers.

MAPs Dimerize
-------------

In this model, A can exist either as a monomer or as a dimer, and both the 
monomer and dimer forms can bind to MT.

**Screen shot:** dimer and inputs

For this model, you need to input the total amount of A (or MT), the 
dissociation constant for monomeric A binding MT, K\ :sub:`1`\ , the 
dissociation constant for dimeric A binding MT, K\ :sub:`2`\ , the 
dissociation constant for the A dimer, K\ :sub:`A`\ , and the binding 
ratio. All inputs must be positive numbers.

