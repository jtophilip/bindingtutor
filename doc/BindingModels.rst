=========================
Binding Model Mathematics
=========================

This chapter describes the equations used to simulate the binding 
curves. Though some of these equations can be solved analytically, the 
calculations are performed numerically. The program breaks either the 
total [A] or total [MT] range into a user-defined number of points and 
then calculates the concentration of free and bound A and free and bound 
MT at each point.

.. raw:: wikir
   
   <wiki:toc max_depth="1" />
   


Polymer Nature of MT
====================

Microtubules are polymers composed of tubulin dimers consisting of one 
alpha and one beta tubulin. A microtubule is formed by 13 filaments of 
tubulin dimers binding head to tail. For most of the microtubule, the 
lateral interactions are alpha-beta, but one set of interactions (the MT 
"seam") is alpha-alpha and beta-beta. For most binding calculations the 
polymeric nature of the MT can be ignored, however, in a few cases it 
must be taken into account, as described below.

Concentration of MT
-------------------

By convention, the concentration of MT is reported as the concentration 
of tubulin dimers. In most binding assays a microtubule stabilizer is 
used to make the concentration of free tubulin irrelevant in binding 
calculations. Should this not be the case, the contribution of free 
tubulin dimer both in decreasing the available polymer sites and in 
possibly competing with the polymerized tubulin for binding proteins 
must be taken into account. MTBindingSim does not deal with such cases.

Binding Ratio
-------------

Some MT binding proteins appear to bind to MT with ratios other than 1 
MT binding protein : 1 tubulin dimer. Ackman *et. al.* have introduced 
the binding ratio, n, as an additional parameter that can be used in 
fitting binding data to accommodate non 1:1 binding ratios. [#ackman]_

.. [#ackman] Ackman, M., Wiech, H. and Mandelkow, E. 2000. *Journal of
   Biological Chemistry* 275(39):30335-30343.

We have included the binding ratio n as a parameter that can be set in 
our binding curve calculations. Following Ackman *et. al.*, we have 
defined n such that that binding ratio is n A : 1 tubulin dimer. The 
impact of n on the binding models can be seen below. Given that MT are 
polymeric, it is assumed that the binding ratio can be accounted for 
simply by changing the number of available MT binding sites for A.

This method will break down in an extreme boundary case where a single A 
binds so many tubulin dimers that a single MT polymer does not contain 
enough sites. In such a case, A would need to encounter two or more 
individual MT polymers, changing the binding model. However, such an 
extreme case is extraordinarily rare and would most likely occur if two 
different polymers were interacting with each other directly. 
MTBindingSim does not deal with such cases.


First Order Binding
===================

In first order binding, the relationship between A and MT is:

.. latex-math::
   
   A + MT/n \rightleftharpoons AMT.

The dissociation constant is defined as:

.. latex-math::
   
   K_D = \frac{[A]n[MT]}{[AMT]}.

We can also write mass balances for total A and total MT:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AMT] = [A] + \frac{1}{K_D}[A]n[MT]

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n = [MT] + \frac{1}{K_D}[A][MT].

We can rearrange the equation for total MT and solve for [MT] free:

.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_D}[A]}.

We now can substitute this equation into the equation for total A:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \frac{\frac{1}{K_D}[A]n[MT]_{\mathrm{total}}}{1 + \frac{1}{K_D}[A]}.

The program numerically finds the value of [A] free that solves this 
equation, then uses that to calculate all other necessary parameters.

Traditional Cooperativity
=========================

In the traditional cooperativity model, the binding of the first MAP 
changes the dissociation constant for a second MAP binding. The binding 
relationship is:

.. latex-math::
   
   A + MT/n \leftrightharpoons AMT, A + AMT \leftrightharpoons A_2MT_2.

The dissociation constants for these interactions are:
	
.. latex-math::
   
   K_D = [A]n[MT]/[AMT], \phi K_D = [A][AMT]/[A_2MT_2].

The mass balance equations are:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AMT] + 2[A_2MT_2] = [A] + \frac{1}{K_D}[A]n[MT] + \frac{2}{\phi K_D}[A][AMT]

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \frac{1}{K_D}[A]n[MT] + \frac{2}{\phi K_D^2}[A]^2n[MT]

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n + 2[A_2MT_2]/n \\ = [MT] + \frac{1}{K_D}[A][MT] + \frac{2}{\phi K_D^2}[A]^2[MT].

Note that [A\ :sub:`2`\ MT\ :sub:`2`\ ] accounts for 2 MT monomers, but 
there is only one instance of free MT in the dissociation constant 
equations. This is due to the polymer nature of the MT: binding to one 
free MT automatically brings the complex into contact with another free 
MT.

We can now solve the MT total equation for free MT:
	
.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_D}[A] + \frac{2}{\phi K_D^2}[A]^2}.

This equation can be plugged into the A total equation:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \left( \frac{1}{K_D}[A] + \frac{2}{\phi K_D^2}[A]^2 \right) \frac{n [MT]_{\mathrm{total}}}{1 + \frac{1}{K_D}[A] + \frac{2}{\phi K_D^2}[A]^2}.

This equation is numerically solved for [A] free and the resulting value 
is used to calculate [A] bound as well as [MT] free and [MT] bound.

Seam and Lattice Binding
========================

In the seam and lattice binding model, it is assumed that there are two 
different kinds of binding sites on the MT: seam sites and lattice 
sites, which have different dissociation constants. The seam sites are 
1/13 of the total MT and the lattice sites are 12/13 of the total MT. 
Thus, the binding relationship is:

.. latex-math::
   
   A + S/n \leftrightharpoons AS, A + L/n \leftrightharpoons AL.

The disocciation constants for these interactions are:

.. latex-math::
   
   K_S = [A]n[S]/[AS], K_L = [A]n[L]/[AL].

We can write a mass balance for all three species:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AS] + [AL] = [A] + \frac{1}{K_S}[A]n[S] + \frac{1}{K_L}[A]n[L]

.. latex-math::
   
   [S]_{\mathrm{total}} = [S] + [AS]/n = [S] + \frac{1}{K_S}[A][S]

.. latex-math::
   
   [L]_{\mathrm{total}} = [L] + [AL]/n = [L] + \frac{1}{K_L}[A][L].

We now can solve for free L and free S:

.. latex-math::
   
   [S] = \frac{[S]_{\mathrm{total}}}{1 + \frac{1}{K_S}[A]}

.. latex-math::
   
   [L] = \frac{[L]_{\mathrm{total}}}{1 + \frac{1}{K_L}[A]}.

We now can plug these values into the equation for total A:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \frac{\frac{1}{K_S}[A]n[S]_{\mathrm{total}}}{1 + \frac{1}{K_S}[A]} + \frac{\frac{1}{K_L}[A]n[L]_{\mathrm{total}}}{1 + \frac{1}{K_L}[A]}.

This equation is numerically solved for free A and the result is used to 
calculate bound A and free and total MT.


MAPs Bind MT-bound MAPs
=======================

In this model, A binds MT with a disocciation constant of K\ :sub:`MT`\ ;
then, another A can bind the bound A with a disocciation constant of K\ 
:sub:`A`\ . The binding relationship is:

.. latex-math::
   
   A + MT/n \leftrightharpoons AMT, A + AMT \leftrightharpoons A_2MT.

The disocciation constants for these interactions are:

.. latex-math::
   
   K_{MT} = [A]n[MT]/[AMT], K_A = [A][AMT]/[A_2MT].

We can write the mass balances for this situation:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AMT] + 2[A_2MT] = [A] + \frac{1}{K_{MT}}[A]n[MT] + \frac{1}{K_A}[A][AMT] \\ = [A] + \frac{1}{K_{MT}}[A]n[MT] + \frac{1}{K_{MT} K_A}[A]^2n[MT]

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n + [A_2MT]/n = [MT] + \frac{1}{K_{MT}}[A][MT] + \frac{1}{K_{MT} K_A}[A]^2[MT].

You may notice that this model is almost identical to the traditional 
cooperativity model. The main difference occurs in the MT mass balance 
equation, where A\ :sub:`2`\ MT has only one MT subunit, as opposed to 2 
MT subunits in the traditional cooperativity model in the A\ :sub:`2`\ MT\ 
:sub:`2` complex.

We can solve the MT mass balance for free MT as follows:

.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{MT}}[A] + \frac{1}{K_{MT} K_A}[A]^2}.

We can then substitute this equation into the A mass balance to get:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \left( \frac{1}{K_{MT}}[A] + 2\frac{1}{K_{MT} K_A}[A]^2 \right) \frac{n[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{MT}}[A] + \frac{1}{K_{MT} K_A}[A]^2}.

This equation is numerically solved by the program to find the value of 
free A, which is used to calculate bound A and free and bound MT.

Two MAPs Bind MT-bound MAPs
===========================

This model is very similar to the MAPs bind MT-bound MAPs model, except 
in this case two layers of bound MAP are possible on top of an MT-bound 
MAP. The binding relationships for this model are:

.. latex-math::
   
   A + MT/n \leftrightharpoons AMT, A + AMT \leftrightharpoons A_2MT, A + A_2MT \leftrightharpoons A_3MT.

The disocciation constants for this model are:

.. latex-math::
   
   K_{MT} = [A]n[MT]/[AMT], K_A = [A][AMT]/[A_2MT], K_A = [A][A_2MT]/[A_3MT].

Note that the disocciation constant for the first and second MAP 
binding to the MT-bound MAP is the same. The mass balances for this 
model are:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AMT] + 2[A_2MT] + 3[A_3MT]

.. latex-math::
   
   = [A] + \frac{1}{K_{MT}}[A]n[MT] + \frac{2}{K_A}[A][AMT] + \frac{3}{K_A}[A][A_2MT] 

.. latex-math::
   
   = [A] + \frac{1}{K_{MT}}[A]n[MT] + \frac{2}{K_{MT} K_A} [A]^2n[MT] + \frac{3}{K_A^2}[A]^2[AMT] 

.. latex-math::
   
   = [A] + \frac{1}{K_{MT}}[A]n[MT] + \frac{2}{K_{MT} K_A} [A]^2n[MT] + \frac{3}{K_{MT} K_A^2}[A]^3n[MT],

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n + [A_2MT]/n + [A_3MT]/n

.. latex-math::
   
    = [MT] + \frac{1}{K_{MT}}[A][MT] + \frac{1}{K_{MT} K_A}[A]^2[MT] + \frac{1}{K_{MT} K_A^2}[A]^3[MT].

Notice that, as with the MAPs bind MT-bound MAPs model, all MT-A complexes 
contain a single MT unit. The MT mass balance can be solved for free MT:

.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{MT}}[A] + \frac{1}{K_{MT} K_A}[A]^2 + \frac{1}{K_{MT} K_A^2}[A]^3}.

This can then be substituted into the A mass balance equation, yielding:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \left( \frac{1}{K_{MT}}[A] + \frac{2}{K_{MT} K_A}[A]^2 + \frac{3}{K_{MT} K_A^2}[A]^3 \right) \cdot \\ \frac{n[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{MT}}[A] + \frac{1}{K_{MT} K_A}[A]^2 + \frac{1}{K_{MT} K_A^2}[A]^3}.

This equation is numerically solved by the program to get free A. This 
is then used to calculate bound A and free and bound MT.

MAPs Dimerize
=============

In this model, A can form a dimer with itself, and can bind to the MT in 
both the monomeric and dimeric forms with different disocciation 
constants. The binding interaction for this model is:

.. latex-math::
   
   A + A \leftrightharpoons A_2, A + MT/n \leftrightharpoons AMT, A_2 + 2MT/n \leftrightharpoons A_2MT_2.

The disocciation constants for these interactions are:

.. latex-math::
   
   K_A = [A][A]/[A_2], K_1 = [A]n[MT]/[AMT], K_2 = \frac{[A_2]n/2[MT]}{[A_2MT_2]}.

We can write mass balances for A and MT:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + 2[A_2] + [AMT] + 2[A_2MT_2]

.. latex-math::
   
   = [A] + \frac{2}{K_A}[A]^2 + \frac{1}{K_1}[A]n[MT] + \frac{1}{K_2}[A_2]n[MT]

.. latex-math::
   
   = [A] + \frac{2}{K_A}[A]^2 + \frac{1}{K_1}[A]n[MT] + \frac{1}{K_2K_A}[A]^2n[MT],

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n + 2[A_2MT_2]/n 

.. latex-math::
   
   = [MT] + \frac{1}{K_1}[A][MT] + \frac{1}{K_2}[A_2][MT]

.. latex-math::
   
   = [MT] + \frac{1}{K_1}[A][MT] + \frac{1}{K_2K_A}[A]^2[MT].

We can now solve the MT mass balance for free MT to get:

.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_1}[A] + \frac{1}{K_2K_A}[A]^2}.

We can plug this into the mass balance for A:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \frac{2}{K_A}[A]^2 + \left( \frac{1}{K_1}[A] + \frac{1}{K_2K_A}[A]^2 \right)\frac{n[MT]_{\mathrm{total}}}{1 + \frac{1}{K_1}[A] + \frac{1}{K_2K_A}[A]^2}.

This equation is numerically solved by the program for free A and the 
result is used to calculate bound A and free and bound MT.

