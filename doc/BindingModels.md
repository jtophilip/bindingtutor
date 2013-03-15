# Binding Model Mathematics

This chapter describes the equations used to simulate the binding curves. Though some of these equations can be solved analytically, the calculations are performed numerically. The program breaks either the total [P] or total [L] range into a user-defined number of points and then calculates the concentration of free and bound A and free and bound MT at each point.


## First Order Binding

This model is simple first order binding.

In first order binding, the relationship between P and L is:

$P + L {\leftrightharpoons} PL.$

The dissociation constant is defined as:

$K_{D} = \frac{[P][L]}{[PL]}.$

We can also write mass balances for total P and total L:

$[P]_{\textup{total}} = [P] + [PL] = [P] + \frac{1}{K_{D}}[P][L]$

$[L]_{\textup{total}} = [L] + [PL] = [L] + \frac{1}{K_{D}n}[P][L] = [L](1 + \frac{1}{K_{D}n}[P][L]).$

We can rearrange the equation for total L and solve for [L] free:

$[L] = \frac{[L]_{\textup{total}}}{1 + \frac{1}{K_{D}}[P]}.$

We now can substitute this equation into the equation for total P:

$[P]_{\textup{total}} = [P] + \frac{\frac{1}{K_{D}}[P][L]_{\textup{total}}}{1 + \frac{1}{K_{D}}[P]}.$

The program numerically finds the value of [P] free that solves this equation, then uses that to calculate all other necessary parameters.


## Two Binding Sites

This model assumes that each ligand contains two binding sites for protein P, sites 1 and 2, with different dissociation constants. It is assumed that the two sites do not interact.

The binding relationships for this model are:

$P + L_1 {\leftrightharpoons} PL_1, P + L_2 {\leftrightharpoons} PL_2.$

The dissociation constants for this model are:

$K_{D1} = [P][L_1]/[PL_1], K_{D2} = [P][L_2]/[PL_2].$

The mass balances for this model are:

$[P]_{\textup{total}} = [P] + [PL_1] + [PL_2] = [P] + [P][L_1]/K_{D1} + [P][L_2]/K_{D2} = [P](1 + [L_1]/K_{D1} + [P][L_2]/K_{D2}),$

$[L_1]_{\textup{total}} = [L_1] + [PL_1] = [L_1] + [P][L_1]/K_{D1} = [L_1](1 + [P]/K_{D1}),$

$[L_2]_{\textup{total}} = [L_2] + [PL_2] = [L_2] + [P][L_2]/K_{D2} = [L_2](1 + [P]/K_{D2}).$

The L~1~ and L~2~mass balances can be solved for free L~1~ and L~2~:

$[L_1] = \frac{[L_1]_{\textup{total}}}{1 + [P]/K_{D1}},$

$[L_2] = \frac{[L_2]_{\textup{total}}}{1 + [P]/K_{D2}}.$

These equations can be substituted into the mass balance for P to get:

$[P]_{\textup{total}} = [P] + \frac{[P][L_1]_{\textup{total}}}{K_{D1}(1 +[P]/K_{D1})} + \frac{[P][L_2]_{\textup{total}}}{K_{D2}(1 +[P]/K_{D2})}.$

This equation is numerically solved by the program to get free P, which is then used to calculate bound P and the fraction of P bound. Free L is not calculated because this model cannot be graphed against free L.
