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

### Concerted Cooperativity

In this model n Ls bind to one P at the same time with a dissociation constant of $K_D$.

The binding relationship for this model is:

$P + nL {\leftrightharpoons} PL_n.$

The dissociation constant is:

$K_D = [P][L]^n/[PL_n].$

The mass balances for this situation are:

$[P]_{\textup{total}} = [P] + [PL_n] = [P] + [P][L]^n/K_D = [P](1 + [L]^n/K_D).$

$[L]_{\textup{total}} = [L] + n[PL_n] = [L] + n[P][L]^n/K_D.$

The mass balance for P can be solved for P free and then substituted into the mass balance for L as follows:

$[P] = [P]_{\textup{total}}/(1 + [L]^n/K_D),$

$[L]_{\textup{total}} = [L] + n[P]_{\textup{total}}[L]^n/K_D(1 + [L]^n/K_D).$

This equation is numerically solved for free L at each point. This value is then used to calculate the fraction of P sites occupied, $\theta$, as follows:

$\theta = \frac{n[PL_n]}{n([P] + [PL_n])} = \frac{[P][L]^n/K_D}{[P] + [P][L]^n/K_D} = \frac{[L]^n/K_D}{1 + [L]^n/K_D}.$

This is then used to calculate the amount of free and bound P sites.

### 2 Site Sequential Cooperativity

In this model each P contains 2 identical binding sites for L. The first L that binds to a P has a dissociation constant of $K_{D1}$ and the second L that binds to a P has a dissociation constant of $K_{D2}.$

The binding relationships are:

$P + L {\leftrightharpoons} PL, PL + L {\leftrightharpoons} PL_2.$

The dissociation constants are:

$K_{D1} = \frac{2[P][L]}{[PL]}, K_{D2} = \frac{[PL][L]}{[PL_2]}.$

The mass balances for this model are:

$[P]_{\textup{total}} = [P] + [PL] + [PL_2] = [P] + 2[P][L]/K_{D1} + 2[P][L]^2/K_{D1}K_{D2}$

$[P]_{\textup{total}} = [P](1 + 2[L]/K_{D1} + 2[L]^2/K_{D1}K_{D2}).$

$[L]_{\textup{total}} = [L] + [PL] + 2[PL_2] = [L] + 2[P][L]/K_{D1} + 4[P][L]^2/K_{D1}K_{D2}.$

The mass balance for P can be solved for free P, then substituted into the mass balance for L as follows:

$[P] = [P]_{\textup{total}}/(1 + 2[L]/K_{D1} + 2[L]^2/K_{D1}K_{D2}),$

$[L]_{\textup{total}} = [L] + \frac{[P]_{\textup{total}}(2[L]/K_{D1} + 4[L]^4/K_{D1}K_{D2})}{1 + 2[L]/K_{D1} + 2[L]^2/K_{D1}K_{D2}}.$

This equation is numerically solved for free L at each point. That value is then used to calculate the fraction of P sites occupied, $\theta$, as follows:

$\theta = \frac{[PL] + 2[PL_2]}{2([P] + [PL] + [PL_2])} = \frac{2[P][L]/K_{D1} + 4[P][L]^2/K_{D1}K_{D2}}{2[P] + 4[P][L]/K_{D1} + 4[P][L]^2/K_{D1}K_{D2}} = \frac{[L]/K_{D1} + 2[L]^2/K_{D1}K_{D2}}{1 + 2[L]/K_{D1} + 2[L]^2/K_{D1}K_{D2}}.$

This is then used to calculate the amount of free and bound P. 

### 4 Site Sequential Cooperativity

In this model each P contains 4 identical binding sites for L. The first L that binds to a P has a dissociation constant of $K_{D1}$, the second L that binds to a P has a dissociation constant of $K_{D2}$, the third L that binds to a P has a dissociation constant of $K_{D3}$, and the fourth L that binds to a P has a dissociation constant of $K_{D4}$.

The binding relationships are:

$P + L {\leftrightharpoons} PL, PL + L {\leftrightharpoons} PL_2, PL_2 + L {\leftrightharpoons} PL_3, PL_3 + L {\leftrightharpoons} PL_4.$

The dissociation constants are:

$K_{D1} = \frac{4[P][L]}{[PL]}, K_{D2} = \frac{3[PL][L]}{[PL_2]}, K_{D3} = \frac{2[PL_2][L]}{[PL_3]}, K_{D4} = \frac{[PL_3][L]}{[PL_4]}.$

The mass balances for this model are:

$[P]_{\textup{total}} = [P] + [PL] + [PL_2] + [PL_3] + [PL_4] = [P] + 4[P][L]/K_{D1} + 12[P][L]^2/K_{D1}K_{D2} + 24[P][L]^3/K_{D1}K_{D2}K_{D3} + 24[P][L]^4/K_{D1}K_{D2}K_{D3}K_{D4}$

$[P]_{\textup{total}} = [P](1 + 4[L]/K_{D1} + 12[L]^2/K_{D1}K_{D2} + 24[L]^3/K_{D1}K_{D2}K_{D3} + 24[L]^4/K_{D1}K_{D2}K_{D3}K_{D4}).$

$[L]_{\textup{total}} = [L] + [PL] + 2[PL_2] + 3[PL_3] + 4[PL_4] = [L] + 4[P][L]/K_{D1} + 24[P][L]^2/K_{D1}K_{D2} + 72[P][L]^3/K_{D1}K_{D2}K_{D3} + 96[P][L]^4/K_{D1}K_{D2}K_{D3}K_{D4}.$

The mass balance for P can be solved for free P, then substituted into the mass balance for L as follows:

$[P] = [P]_{\textup{total}}/(1 + 4[L]/K_{D1} + 12[L]^2/K_{D1}K_{D2} + 24[L]^3/K_{D1}K_{D2}K_{D3} + 24[L]^4/K_{D1}K_{D2}K_{D3}K_{D4}),$

$[L]_{\textup{total}} = [L] + \frac{[P]_{\textup{total}}(4[L]/K_{D1} + 24[L]^4/K_{D1}K_{D2} + 72[L]^3/K_{D1}K_{D2}K_{D3} + 96[L]^4/K_{D1}K_{D2}K_{D3}K_{D4})}{1 + 4[L]/K_{D1} + 12[L]^2/K_{D1}K_{D2} + 24[L]^3/K_{D1}K_{D2}K_{D3} + 24[L]^4/K_{D1}K_{D2}K_{D3}K_{D4}}.$

This equation is numerically solved for free L at each point. That value is then used to calculate the fraction of P sites occupied, $\theta$, as follows:

$\theta = \frac{[PL] + 2[PL_2] + 3[PL_3] + 4[PL_4]}{4([P] + [PL] + [PL_2] + [PL_3] + [PL_4])}$

$\theta = \frac{4[P][L]/K_{D1} + 24[P][L]^4/K_{D1}K_{D2} + 72[P][L]^3/K_{D1}K_{D2}K_{D3} + 96[P][L]^4/K_{D1}K_{D2}K_{D3}K_{D4}}{4[P] + 16[P][L]/K_{D1} + 48[P][L]^2/K_{D1}K_{D2} + 96[P][L]^3/K_{D1}K_{D2}K_{D3} + 96[P][L]^4/K_{D1}K_{D2}K_{D3}K_{D4}} $

$\theta = \frac{4[L]/K_{D1} + 24[L]^4/K_{D1}K_{D2} + 72[L]^3/K_{D1}K_{D2}K_{D3} + 96[L]^4/K_{D1}K_{D2}K_{D3}K_{D4}}{4 + 16[L]/K_{D1} + 48[L]^2/K_{D1}K_{D2} + 96[L]^3/K_{D1}K_{D2}K_{D3} + 96[L]^4/K_{D1}K_{D2}K_{D3}K_{D4}}.$

This is then used to calculate the amount of free and bound P. 
