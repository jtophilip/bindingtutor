=========================
Binding Model Mathematics
=========================

This chapter describes the math used to simulate the binding curves. Though some of these equations can be solve analytically, the calculations are done numerically. The program breaks either the total [A] or total [MT] range into a user-defined number of points and then calculates the concentration of free and bound A and free and bound MT at each point numerically.

First Order Binding
===================

In first order binding the relationship between A and MT is:

	.. latex-math::
	A + MT \rightleftharpoons AMT.

K_D is defined as:

	.. latex-math::
	K_D = \frac{[A][MT]}{[AMT]}.

We can write mass balances for total A and total MT:

	.. latex-mat::
	[A]_{total} = [A] + [AMT] = [A] + \frac{1}{K_D}[A][MT]
	[MT]_{total} = [MT] + [AMT] = [MT] + \frac{1}{K_D}[A][MT].

We can rearrange the equation for total MT and solve for [MT] free:

	.. latex-math::
	[MT] = \frac{[MT]_{total}}{1 + \frac{1}{K_D}[A]}.

We now can substitute this equation into the equation for total A:

	.. latex-math::
	[A]_{total} = [A] + \frac{\frac{1}{K_D}[A][MT]_{total}}{1 + \frac{1}{K_D}[A]}.

The program numerically finds the value of [A] free that solves this equation, then uses that to calculate all other necessary parameters.

Traditional Cooperativity
=========================

In the traditional cooperativity model the binding of the first MAP changes the dissociation constant for a second MAP binding. The binding relationship is:

	.. latex-math::
	[A] + [MT] \leftrightharpoons [AMT], [A] + [AMT] \leftrightharpoons [A_2MT_2].

The dissociation constants for these interactions are:
	
	.. latex-math::
	K_D = [A][MT]/[AMT], \phi K_D = [A][AMT]/[A_2MT_2].

The mass balance equations are:
	
	.. latex-math::
	[A]_{total} = [A] + [AMT] + 2[A_2MT_2] = [A] + \frac{1}{K_D}[A][MT] + \frac{2}{\phi K_D}[A][AMT] = [A] + \frac{1}{K_D}[A][MT] + \frac{2}{\phi K_D^2}[A]^2[MT]
	[MT]_{total} = [MT] + [AMT] + 2[A_2MT_2] = [MT] + \frac{1}{K_D}[A][MT] + \frac{2}{\phi K_D^2}[A]^2[MT].

Note that [A_2MT_2] accounts for 2 MT monomers, but there is only one instance of free MT in the dissociation constant equations. This is due to the polymer nature of the MT--binding to one free MT automatically brings the complex into contact with another free MT.

We can now solve the MT total equation for free MT:
	
	.. latex-math::
	[MT] = \frac{[MT]_{total}}{1 + \frac{1}{K_D}[A] + \frac{2}{\phi K_D^2}[A]^2}.

This equation can be plugged into the A total equation:

	.. latex-math::
	[A]_{total} = [A] + (\frac{1}{K_D}[A] + \frac{2}{\phi K_D^2}[A]^2)\frac{MT_{total}}{1 + \frac{1}{K_D}[A] + \frac{2}{\phi K_D^2}[A]^2}.

This equation is numerically solved for [A] free and the resulting value is used to calculate [A] bound as well as [MT] free and [MT] bound.

Seam and Lattice Binding
========================

MAPs Bind MT-bound MAPs
=======================

2MAPs Bind MT-bound MAPs
========================

MAPs Dimerize
=============