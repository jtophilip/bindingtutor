function [Frac, Bfree, Abound] = cooperativity(Btot, Atot, KD, P)
% A function which calculates the biding of A to B assuming cooperative
% binding where the total concentrations of A and B are Atot and Btot and
% the disassociation constant for the first bound A is KD and then
% disassociation constant for the second bound A is KD*P
%
% Copywright 2010, University of Notre Dame
% Written by Julia Philip

% Declares variables, creating symbolic versions of KD, Atot, Btot, and p to
% be used in the solver
syms A kd bt at p

% Calculates free and bound A
A1 = solve(A + ((2/kd)*A + (4/(p*(kd^2)))*A^2)*bt/(1 + (2/kd)*A + (2/(p*(kd^2)))*A^2)-at, A);
Afree = subs(A1(1), {kd at bt p}, {KD Atot Btot P});
Abound = Atot - Afree;

% Calculates the fraction of A bound
f = Abound/Atot;
Frac = real(f);

% Calculates free B
b = Btot/(1 + (2/KD)*Afree + (2/(P*KD))*Afree^2);
Bfree = real(b);

end

