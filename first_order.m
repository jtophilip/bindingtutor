function [Frac, Bfree, Abound] = first_order(Btot, Atot, KD)
% A function which calculates the biding of A to B assuming first order
% binding where the total concentrations of A and B are Atot and Btot and
% the disassociation constant is KD.
%
% Copywright 2010, University of Notre Dame
% Written by Julia Philip

% Declares variables, creating symbolic versions of KD, Atot, and Btot to
% be used in the solver
syms A kd bt at

% Solves for free and bound A
A1 = solve(A + (1/kd)*A*bt/(1 + (1/kd)*A)- at, A);
Afree = subs(A1(1), {kd bt at}, {KD Btot Atot});
Abound = Atot - Afree;

% Solves for fraciton of A bound
f = (Abound)/Atot;
Frac = real(f);

% Solves for free B
b = Btot/(1 + (1/KD)*(Afree));
Bfree = real(b);

end