# Binding Model Mathematics

This chapter describes the equations used to simulate the binding curves. Though some of these equations can be solved analytically, the calculations are performed numerically. The program breaks either the total [A] or total [MT] range into a user-defined number of points and then calculates the concentration of free and bound A and free and bound MT at each point.


## Polymer Nature of MT

Microtubules are polymers composed of tubulin dimers consisting of one alpha and one beta tubulin. A microtubule is formed by 13 filaments of tubulin dimers binding head to tail. For most of the microtubule, the lateral interactions are alpha-beta, but one set of interactions (the MT "seam") is alpha-alpha and beta-beta. For most binding calculations the polymeric nature of the MT can be ignored, however, in a few cases it must be taken into account, as described below.

### Concentration of MT

By convention, the concentration of MT is reported as the concentration of tubulin dimers. In most binding assays a microtubule stabilizer is used to make the concentration of free tubulin irrelevant in binding calculations. Should this not be the case, the contribution of free tubulin dimer both in decreasing the available polymer sites and in possibly competing with the polymerized tubulin for binding proteins must be taken into account. MTBindingSim does not deal with such cases.

### Binding Ratio

Some MT binding proteins appear to bind to MT with ratios other than 1 MT binding protein : 1 tubulin dimer. [Ackmann *et. al.*](http://dx.doi.org/10.1074/jbc.M002590200) have introduced the binding ratio, n, as an additional parameter that can be used in fitting binding data to accommodate non 1:1 binding ratios.

We have included the binding ratio n as a parameter that can be set in our binding curve calculations. Following Ackmann *et. al.*, we have defined n such that that binding ratio is n A : 1 tubulin dimer. However, we have differed from Ackmann *et. al.* in how we include the binding ratio in our binding equations. While they change the number of available binding sites based on the binding ratio, we do not change the number of available sites. We account for the binding ratio only in the mass balance for microtubules. This formulation assumes that the number of available binding sites is the number of free dimers, regardless of how many dimers an individual A binds.

This method will break down in an extreme boundary case where a single A binds so many tubulin dimers that a single MT polymer does not contain enough sites. In such a case, A would need to encounter two or more individual MT polymers, changing the binding model. However, such an extreme case is extraordinarily rare and would most likely occur if two different polymers were interacting with each other directly. MTBindingSim does not deal with such cases.


## First Order Binding

This model is simple first order binding.

![first_order](${IMAGES}/First_order.pdf){width=3in align=center}

In first order binding, the relationship between A and MT is:

$A + MT \rightleftharpoons AMT.$

The dissociation constant is defined as:

$K_{AMT} = \frac{[A][MT]}{[AMT]}.$

We can also write mass balances for total A and total MT:

$[A]_{\mathrm{total}} = [A] + [AMT] = [A] + \frac{1}{K_{AMT}}[A][MT]$

$[MT]_{\mathrm{total}} = [MT] + [AMT]/n = [MT] + \frac{1}{K_{AMT}n}[A][MT].$

We can rearrange the equation for total MT and solve for [MT] free:

$[MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A]}.$

We now can substitute this equation into the equation for total A:

$[A]_{\mathrm{total}} = [A] + \frac{\frac{1}{K_{AMT}}[A][MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A]}.$

The program numerically finds the value of [A] free that solves this equation, then uses that to calculate all other necessary parameters.

## Seam and Lattice Binding

In the seam and lattice binding model, it is assumed that there are two different kinds of binding sites on the MT: seam sites and lattice sites, which have different dissociation constants. The seam sites are 1/13 of the total MT and the lattice sites are 12/13 of the total MT.

![seam_lattice](${IMAGES}/Seam_lattice.pdf){width=3in align=center}

The binding relationship is:

$A + S \leftrightharpoons AS, A + L \leftrightharpoons AL.$

The disocciation constants for these interactions are:

$K_{AS} = [A][S]/[AS], K_{AL} = [A][L]/[AL].$

We can write a mass balance for all three species:

$[A]_{\mathrm{total}} = [A] + [AS] + [AL] = [A] + \frac{1}{K_{AS}}[A][S] + \frac{1}{K_{AL}}[A][L]$

$[S]_{\mathrm{total}} = [S] + [AS]/n = [S] + \frac{1}{K_{AS}n}[A][S]$

$[L]_{\mathrm{total}} = [L] + [AL]/n = [L] + \frac{1}{K_{AL}n}[A][L].$

We now can solve for free L and free S:

$[S] = \frac{[S]_{\mathrm{total}}}{1 + \frac{1}{K_{AS}n}[A]}$

$[L] = \frac{[L]_{\mathrm{total}}}{1 + \frac{1}{K_{AL}n}[A]}.$

We now can plug these values into the equation for total A:

$[A]_{\mathrm{total}} = [A] + \frac{\frac{1}{K_{AS}}[A][S]_{\mathrm{total}}}{1 + \frac{1}{K_{AS}n}[A]} + \frac{\frac{1}{K_{AL}}[A][L]_{\mathrm{total}}}{1 + \frac{1}{K_{AL}n}[A]}.$

This equation is numerically solved for free A and the result is used to calculate bound A and free and total MT.

## MAPs Dimerize

In this model, A can form a dimer with itself, and can bind to the MT in both the monomeric and dimeric forms with different disocciation constants.

![image](${IMAGES}/Dimer.pdf){width=3in align=center}

The binding interaction for this model is:

$A + A \leftrightharpoons A_2, A + MT \leftrightharpoons AMT, A_2 + 2MT \leftrightharpoons A_2MT_2.$

The disocciation constants for these interactions are:

$K_{AA} = [A][A]/[A_2], K_{AMT} = [A][MT]/[AMT], K_{AAMT} = \frac{[A_2][MT]}{[A_2MT_2]}.$

We can write mass balances for A and MT:

$[A]_{\mathrm{total}} = [A] + 2[A_2] + [AMT] + 2[A_2MT_2]$

$= [A] + \frac{2}{K_{AA}}[A]^2 + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AAMT}}[A_2][MT]$

$= [A] + \frac{2}{K_{AA}}[A]^2 + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AMT}K_{AA}}[A]^2[MT],$

$[MT]_{\mathrm{total}} = [MT] + [AMT]/n + 2[A_2MT_2]/n $

$= [MT] + \frac{1}{K_{AMT}n}[A][MT] + \frac{2}{K_{AAMT}n}[A_2][MT]$

$= [MT] + \frac{1}{K_{AMT}n}[A][MT] + \frac{2}{K_{AAMT}K_{AA}n}[A]^2[MT].$

We can now solve the MT mass balance for free MT to get:

$[MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A] + \frac{2}{K_{AAMT}K_{AA}n}[A]^2}.$

We can plug this into the mass balance for A:

$[A]_{\mathrm{total}} = [A] + \frac{2}{K_{AA}}[A]^2 + \left( \frac{1}{K_{AMT}}[A] + \frac{2}{K_{AAMT}K_{AA}}[A]^2 \right)\frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT}n}[A] + \frac{2}{K_{AAMT}K_{AA}n}[A]^2}.$

This equation is numerically solved by the program for free A and the result is used to calculate bound A and free and bound MT.

## Pseudocooperativity

Cooperative binding of MAPs cannot be modeled using the standard model of cooperative ligand binding. To model cooperative behavior we have implemented a "pseudocooperativity" model where the binding of an A to an MT site, with an affinity of K~AMT~, creates an MT\* site, which has an affinity of K~AMT~\* for A. MT\* sites are created by the binding of A to both MT and MT\* sites, so the total number of MT\* sites is equal to the total number of bound A proteins.

The binding relationships are:

$A + MT \leftrightharpoons AMT, A + MT* \leftrightharpoons AMT*.$

The dissociation constants for these interactions are:

$K_{AMT} = [A][MT]/[AMT], K_{AMT}* = [A][MT*]/[AMT*].$

We can write mass balances for this situation. Note that there is an additional mass balance for MT\*.

$[MT*]_{\mathrm{total}} = [MT*] + [AMT*] = [AMT] + [AMT*]$

This equation can be used to show that [MT\*] = [AMT], which we will use
later.

$[A]_{\mathrm{total}} = [A] + [AMT] + [AMT*]  = [A] + \frac{[A][MT]}{K_{AMT}} + \frac{[A][MT*]}{K_{AMT}*} \\ = [A] + \frac{[A][MT]}{K_{AMT}} + \frac{[A][AMT]}{K_{AMT}*}  = [A] + \frac{[A][MT]}{K_{AMT}} + \frac{[A][A][MT]}{K_{AMT}K_{AMT}*} \\ = [A] + [MT](\frac{[A]}{K_{AMT}} + \frac{[A]^2}{K_{AMT}K_{AMT}*})$

$[MT]_{\mathrm{total}} = [MT] + [AMT] + [MT*] + [AMT*]  = [MT] + [AMT] + [AMT] + [AMT*] \\ = [MT] + 2[AMT] + [AMT*]  = [MT] + \frac{2[A][MT]}{K_{AMT}} + \frac{[A][MT*]}{K_{AMT}*} \\ = [MT] + \frac{2[A][MT]}{K_{AMT}} + \frac{[A][AMT*]}{K_{AMT}} = [MT] + \frac{2[A][MT]}{K_{AMT}} + \frac{[A][A][MT]}{K_{AMT}K_{AMT}*}$

The MT mass balance can be solved for free MT as follows:

$[MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{2[A]}{K_{AMT}} + \frac{[A]^2}{K_{AMT}K_{AMT}*}}.$

This equation can then be substituted into the mass balance for A to
get:

$[A]_{\mathrm{total}} = [A] + \frac{[MT]_{\mathrm{total}}(\frac{[A]}{K_{AMT}} + \frac{[A]^2}{K_{AMT}K_{AMT}*})}{1 + \frac{2[A]}{K_{AMT}} + \frac{[A]^2}{K_{AMT}K_{AMT}*}}$

This equation is solved numerically by the program to calculate A bound and free and MT bound and free at each point.

## MAPs Bind MT-bound MAPs

In this model, A binds MT with a disocciation constant of K~AMT~; then, another A can bind the bound A with a disocciation constant of K ~AA~.

![image](${IMAGES}/MAP_bind.pdf){width=3in align=center}

The binding relationships are:

$A + MT \leftrightharpoons AMT, A + AMT \leftrightharpoons A_2MT.$

The dissociation constants for these interactions are:

$K_{AMT} = [A][MT]/[AMT], K_{AA} = [A][AMT]/[A_2MT].$

We can write the mass balances for this situation:

$[A]_{\mathrm{total}} = [A] + [AMT] + 2[A_2MT] = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{1}{K_{AA}}[A][AMT] \\ = [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{1}{K_{AMT} K_{AA}}[A]^2[MT]$

$[MT]_{\mathrm{total}} = [MT] + [AMT]/n + [A_2MT]/n = [MT] + \frac{1}{K_{AMT} n}[A][MT] + \frac{1}{K_{AMT} K_{AA} n}[A]^2[MT].$

We can solve the MT mass balance for free MT as follows:

$[MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT} n}[A] + \frac{1}{K_{AMT} K_{AA} n}[A]^2}.$

We can then substitute this equation into the A mass balance to get:

$[A]_{\mathrm{total}} = [A] + \left( \frac{1}{K_{MT}}[A] + 2\frac{1}{K_{AMT} K_{AA}}[A]^2 \right) \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT} n}[A] + \frac{1}{K_{AMT} K_{AA} n}[A]^2}.$

This equation is numerically solved by the program to find the value of free A, which is used to calculate bound A and free and bound MT.

## Two MAPs Bind MT-bound MAPs

This model is very similar to the MAPs bind MT-bound MAPs model, except in this case two layers of bound MAP are possible on top of an MT-bound MAP.

![image](${IMAGES}/MAP_bind2.pdf){width=3in align=center}

The binding relationships for this model are:

$A + MT \leftrightharpoons AMT, A + AMT \leftrightharpoons A_2MT, A + A_2MT \leftrightharpoons A_3MT.$

The disocciation constants for this model are:

$K_{AMT} = [A][MT]/[AMT], K_{AA} = [A][AMT]/[A_2MT], K_{AA} = [A][A_2MT]/[A_3MT].$

Note that the disocciation constant for the first and second MAP binding to the MT-bound MAP is the same. The mass balances for this model are:

$[A]_{\mathrm{total}} = [A] + [AMT] + 2[A_2MT] + 3[A_3MT]$

$= [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AA}}[A][AMT] + \frac{3}{K_{AA}}[A][A_2MT] $

$= [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AMT} K_{AA}} [A]^2[MT] + \frac{3}{K_{AA}^2}[A]^2[AMT] $

$= [A] + \frac{1}{K_{AMT}}[A][MT] + \frac{2}{K_{AMT} K_{AA}} [A]^2[MT] + \frac{3}{K_{AMT} K_{AA}^2}[A]^3[MT],$

$[MT]_{\mathrm{total}} = [MT] + [AMT]/n + [A_2MT]/n + [A_3MT]/n$

$= [MT] + \frac{1}{K_{AMT}n}[A][MT] + \frac{1}{K_{AMT} K_{AA} n}[A]^2[MT] + \frac{1}{K_{AMT} K_{AA}^2 n}[A]^3[MT].$

Notice that, as with the MAPs bind MT-bound MAPs model, all MT-A complexes contain a single MT unit. The MT mass balance can be solved for free MT:

$[MT] = \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT} n}[A] + \frac{1}{K_{AMT} K_{AA} n}[A]^2 + \frac{1}{K_{AMT} K_{AA}^2 n}[A]^3}.$

This can then be substituted into the A mass balance equation, yielding:

$[A]_{\mathrm{total}} = [A] + \left( \frac{1}{K_{AMT}}[A] + \frac{2}{K_{AMT} K_{AA}}[A]^2 + \frac{3}{K_{AMT} K_{AA}^2}[A]^3 \right) \cdot \\ \frac{[MT]_{\mathrm{total}}}{1 + \frac{1}{K_{AMT} n}[A] + \frac{1}{K_{AMT} K_{AA} n}[A]^2 + \frac{1}{K_{AMT} K_{AA}^2 n}[A]^3}.$

This equation is numerically solved by the program to get free A. This is then used to calculate bound A and free and bound MT.

## Two Binding Sites

This model assumes that each tubulin dimer contains two binding sites for protein A, sites 1 and 2, with different dissociation constants. It is assumed that the two sites do not interact.

The binding relationships for this model are:

$A + MT_1 \leftrightharpoons AMT_1, A + MT_2 \leftrightharpoons AMT_2.$

The dissociation constants for this model are:

$K_{AMT1} = [A][MT_1]/[AMT_1], K_{AMT2} = [A][MT_2]/[AMT_2].$

The mass balances for this model are:

$[A]_{\mathrm{total}} = [A] + [AMT_1] + [AMT_2] = [A] + [A][MT_1]/K_{AMT1} + [A][MT_2]/K_{AMT2},$

$[MT_1]_{\mathrm{total}} = [MT_1] + [AMT_1] = [MT_1] + [A][MT_1]/K_{AMT1},$

$[MT_2]_{\mathrm{total}} = [MT_2] + [AMT_2] = [MT_2] + [A][MT_2]/K_{AMT2}.$

The MT~1~and MT~2~mass balances can be solved for free MT~1~and MT~2~:

$[MT_1] = \frac{[MT_1]_{\mathrm{total}}}{1 + [A]/K_{AMT1}},$

$[MT_2] = \frac{[MT_2]_{\mathrm{total}}}{1 + [A]/K_{AMT2}}.$

These equations can be substituted into the mass balance for A to get:

$[A]_{\mathrm{total}} = [A] + \frac{[A][MT_1]_{\mathrm{total}}}{K_{AMT1}(1 +[A]/K_{AMT1})} + \frac{[A][MT_2]_{\mathrm{total}}}{K_{AMT2}(1 +[A]/K_{AMT2})}.$

This equation is numerically solved by the program to get free A, which is then used to calculate bound A and the fraction of A bound. Free MT is not calculated because this model cannot be graphed against free MT.
