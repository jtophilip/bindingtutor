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
defined n such that that binding ratio is n A : 1 tubulin dimer. However, we have differed from Ackaman *et. al.* in how we include the binding ratio in our binding equations. While they change the number of available binding sites based on the binding ratio, we do not change the number of available sites. We account for the binding ratio only in the mass balance for microtubules. This formulation assumes that the number of available binding sites is the number of free dimers, regardless of how many dimers an individual A binds.

This method will break down in an extreme boundary case where a single A 
binds so many tubulin dimers that a single MT polymer does not contain 
enough sites. In such a case, A would need to encounter two or more 
individual MT polymers, changing the binding model. However, such an 
extreme case is extraordinarily rare and would most likely occur if two 
different polymers were interacting with each other directly. 
MTBindingSim does not deal with such cases.


First Order Binding
===================

This model is simple first order binding.

.. image:: $(IMAGES)/First_order.pdf
   :width: 3in
   :align: center

In first order binding, the relationship between A and MT is:

.. latex-math::
   
   A + MT \rightleftharpoons AMT.

The dissociation constant is defined as:

.. latex-math::
   
   K_{AMT} = \frac{[A][MT]}{[AMT]}.

We can also write mass balances for total A and total MT:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AMT] = [A] + \frac{1}{K_{AMT}}[A][MT]

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n = [MT] + \frac{1}{K_{AMT}n}[A][MT].

We can rearrange the equation for total MT and solve for [MT] free:

.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A]}.

We now can substitute this equation into the equation for total A:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \frac{\frac{1}{K_{AMT}}[A][MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A]}.

The program numerically finds the value of [A] free that solves this 
equation, then uses that to calculate all other necessary parameters.

Seam and Lattice Binding
========================

In the seam and lattice binding model, it is assumed that there are two 
different kinds of binding sites on the MT: seam sites and lattice 
sites, which have different dissociation constants. The seam sites are 
1/13 of the total MT and the lattice sites are 12/13 of the total MT. 

.. image:: $(IMAGES)/Seam_lattice.pdf
   :width: 3in
   :align: center

The binding relationship is:

.. latex-math::
   
   A + S \leftrightharpoons AS, A + L \leftrightharpoons AL.

The disocciation constants for these interactions are:

.. latex-math::
   
   K_{AS} = [A][S]/[AS], K_{AL} = [A][L]/[AL].

We can write a mass balance for all three species:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AS] + [AL] = [A] + \frac{1}{K_{AS}}[A][S] + \frac{1}{K_{AL}}[A][L]

.. latex-math::
   
   [S]_{\mathrm{total}} = [S] + [AS]/n = [S] + \frac{1}{K_{AS}n}[A][S]

.. latex-math::
   
   [L]_{\mathrm{total}} = [L] + [AL]/n = [L] + \frac{1}{K_{AL}n}[A][L].

We now can solve for free L and free S:

.. latex-math::
   
   [S] = \frac{[S]_{\mathrm{total}}}{1 + \frac{1}{K_{AS}n}[A]}

.. latex-math::
   
   [L] = \frac{[L]_{\mathrm{total}}}{1 + \frac{1}{K_{AL}n}[A]}.

We now can plug these values into the equation for total A:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \frac{\frac{1}{K_{AS}}[A][S]_{\mathrm{total}}}{1 + \frac{1}{K_{AS}n}[A]} + \frac{\frac{1}{K_{AL}}[A][L]_{\mathrm{total}}}{1 + \frac{1}{K_{AL}n}[A]}.

This equation is numerically solved for free A and the result is used to 
calculate bound A and free and total MT.

MAPs Dimerize
=============

In this model, A can form a dimer with itself, and can bind to the MT in 
both the monomeric and dimeric forms with different disocciation 
constants. 

.. image:: $(IMAGES)/Dimer.pdf
   :width: 3in
   :align: center

The binding interaction for this model is:

.. latex-math::
   
   A + A \leftrightharpoons A_2, A + MT \leftrightharpoons AMT, A_2 + 2MT \leftrightharpoons A_2MT_2.

The disocciation constants for these interactions are:

.. latex-math::
   
   K_{AA} = [A][A]/[A_2], K_{AMT} = [A][MT]/[AMT], K_{AAMT} = \frac{[A_2][MT]}{[A_2MT_2]}.

We can write mass balances for A and MT:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + 2[A_2] + [AMT] + 2[A_2MT_2]

.. latex-math::
   
   = [A] + \frac{2}{K_{AA}}[A]^2 + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AAMT}}[A_2][MT]

.. latex-math::
   
   = [A] + \frac{2}{K_{AA}}[A]^2 + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AMT}K_{AA}}[A]^2[MT],

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n + 2[A_2MT_2]/n 

.. latex-math::
   
   = [MT] + \frac{1}{K_{AMT}n}[A][MT] + \frac{2}{K_{AAMT}n}[A_2][MT]

.. latex-math::
   
   = [MT] + \frac{1}{K_{AMT}n}[A][MT] + \frac{2}{K_{AAMT}K_{AA}n}[A]^2[MT].

We can now solve the MT mass balance for free MT to get:

.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A] + \frac{2}{K_{AAMT}K_{AA}n}[A]^2}.

We can plug this into the mass balance for A:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \frac{2}{K_{AA}}[A]^2 + \left( \frac{1}{K_{AMT}}[A] + \frac{2}{K_{AAMT}K_{AA}}[A]^2 \right)\frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A] + \frac{2}{K_{AAMT}K_{AA}n}[A]^2}.

This equation is numerically solved by the program for free A and the 
result is used to calculate bound A and free and bound MT.



.. Traditional Cooperativity
   =========================

.. In the traditional cooperativity model, the binding of the first MAP 
   changes the dissociation constant for a second MAP binding. 

.. commented
   image:: $(IMAGES)/Cooperativity.pdf
   :width: 3in
   :align: center

.. The binding relationship is:

.. commented
   latex-math::
   
   A + MT \leftrightharpoons AMT, A + AMT \leftrightharpoons A_2MT_2.

.. The dissociation constants for these interactions are:
	
.. commented
   latex-math::
   
   K_{AMT} = [A][MT]/[AMT], \phi K_{AMT} = [A][AMT]/[A_2MT_2].

.. The mass balance equations are:

.. commented
   latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AMT] + 2[A_2MT_2] = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{\phi K_{AMT}}[A][AMT]

.. commented
   latex-math::
   
   [A]_{\mathrm{total}} = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{\phi K_{AMT}^2}[A]^2[MT]

.. commented
   latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n + 2[A_2MT_2]/n \\ = [MT] + \frac{1}{K_{AMT}n}[A][MT] + \frac{2}{\phi K_{AMT}^2 n}[A]^2[MT].

.. Note that [A\ :sub:`2`\ MT\ :sub:`2`\ ] accounts for 2 MT monomers, but 
   there is only one instance of free MT in the dissociation constant 
   equations. This is due to the polymer nature of the MT: binding to one 
   free MT automatically brings the complex into contact with another free 
   MT.

.. We can now solve the MT total equation for free MT:
	
.. commented
   latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A] + \frac{2}{\phi K_{AMT}^2 n}[A]^2}.

.. This equation can be plugged into the A total equation:

.. commented
   latex-math::
   
   [A]_{\mathrm{total}} = [A] + \left( \frac{1}{K_{AMT}}[A] + \frac{2}{\phi K_{AMT}^2}[A]^2 \right) \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A] + \frac{2}{\phi K_{AMT}^2 n}[A]^2}.

.. This equation is numerically solved for [A] free and the resulting value 
   is used to calculate [A] bound as well as [MT] free and [MT] bound.


MAPs Bind MT-bound MAPs
=======================

In this model, A binds MT with a disocciation constant of K\ :sub:`AMT`\ ;
then, another A can bind the bound A with a disocciation constant of K\ 
:sub:`AA`\ . 

.. image:: $(IMAGES)/MAP_bind.pdf
   :width: 3in
   :align: center

The binding relationship is:

.. latex-math::
   
   A + MT \leftrightharpoons AMT, A + AMT \leftrightharpoons A_2MT.

The disocciation constants for these interactions are:

.. latex-math::
   
   K_{AMT} = [A][MT]/[AMT], K_{AA} = [A][AMT]/[A_2MT].

We can write the mass balances for this situation:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AMT] + 2[A_2MT] = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{1}{K_{AA}}[A][AMT] \\ = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{1}{K_{AMT} K_{AA}}[A]^2[MT]

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n + [A_2MT]/n = [MT] + \frac{1}{K_{AMT} n}[A][MT] + \frac{1}{K_{AMT} K_{AA} n}[A]^2[MT].

.. You may notice that this model is almost identical to the traditional 
   cooperativity model. The main difference occurs in the MT mass balance 
   equation, where A\ :sub:`2`\ MT has only one MT subunit, as opposed to 2 
   MT subunits in the traditional cooperativity model in the A\ :sub:`2`\     MT\ :sub:`2` complex.

We can solve the MT mass balance for free MT as follows:

.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT} n}[A] + \frac{1}{K_{AMT} K_{AA} n}[A]^2}.

We can then substitute this equation into the A mass balance to get:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \left( \frac{1}{K_{MT}}[A] + 2\frac{1}{K_{AMT} K_{AA}}[A]^2 \right) \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT} n}[A] + \frac{1}{K_{AMT} K_{AA} n}[A]^2}.

This equation is numerically solved by the program to find the value of 
free A, which is used to calculate bound A and free and bound MT.

Two MAPs Bind MT-bound MAPs
===========================

This model is very similar to the MAPs bind MT-bound MAPs model, except 
in this case two layers of bound MAP are possible on top of an MT-bound 
MAP. 

.. image:: $(IMAGES)/MAP_bind2.pdf
   :width: 3in
   :align: center

The binding relationships for this model are:

.. latex-math::
   
   A + MT \leftrightharpoons AMT, A + AMT \leftrightharpoons A_2MT, A + A_2MT \leftrightharpoons A_3MT.

The disocciation constants for this model are:

.. latex-math::
   
   K_{AMT} = [A][MT]/[AMT], K_{AA} = [A][AMT]/[A_2MT], K_{AA} = [A][A_2MT]/[A_3MT].

Note that the disocciation constant for the first and second MAP 
binding to the MT-bound MAP is the same. The mass balances for this 
model are:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + [AMT] + 2[A_2MT] + 3[A_3MT]

.. latex-math::
   
   = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AA}}[A][AMT] + \frac{3}{K_{AA}}[A][A_2MT] 

.. latex-math::
   
   = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AMT} K_{AA}} [A]^2[MT] + \frac{3}{K_{AA}^2}[A]^2[AMT] 

.. latex-math::
   
   = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AMT} K_{AA}} [A]^2[MT] + \frac{3}{K_{AMT} K_{AA}^2}[A]^3[MT],

.. latex-math::
   
   [MT]_{\mathrm{total}} = [MT] + [AMT]/n + [A_2MT]/n + [A_3MT]/n

.. latex-math::
   
    = [MT] + \frac{1}{K_{AMT}n}[A][MT] + \frac{1}{K_{AMT} K_{AA} n}[A]^2[MT] + \frac{1}{K_{AMT} K_{AA}^2 n}[A]^3[MT].

Notice that, as with the MAPs bind MT-bound MAPs model, all MT-A complexes 
contain a single MT unit. The MT mass balance can be solved for free MT:

.. latex-math::
   
   [MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT} n}[A] + \frac{1}{K_{AMT} K_{AA} n}[A]^2 + \frac{1}{K_{AMT} K_{AA}^2 n}[A]^3}.

This can then be substituted into the A mass balance equation, yielding:

.. latex-math::
   
   [A]_{\mathrm{total}} = [A] + \left( \frac{1}{K_{AMT}}[A] + \frac{2}{K_{AMT} K_{AA}}[A]^2 + \frac{3}{K_{AMT} K_{AA}^2}[A]^3 \right) \cdot \\ \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT} n}[A] + \frac{1}{K_{AMT} K_{AA} n}[A]^2 + \frac{1}{K_{AMT} K_{AA}^2 n}[A]^3}.

This equation is numerically solved by the program to get free A. This 
is then used to calculate bound A and free and bound MT.

