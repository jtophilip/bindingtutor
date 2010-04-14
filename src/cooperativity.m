function [Frac, Bfree, Abound] = cooperativity(Btot, Atot, KD, P)
% A function which calculates the binding of A to B assuming cooperative
% binding where the total concentrations of A and B are Atot and Btot,
% the disassociation constant for the first bound A is KD, and the
% disassociation constant for the second bound A is KD*P

% This file is part of MTBindingSim.
%
% Copyright (C) 2010  University of Notre Dame
%
% MTBindingSim is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% MTBindingSim is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with MTBindingSim.  If not, see <http://www.gnu.org/licenses/>.

% Author:
%   Julia Philip <jphilip@nd.edu>
%
% Version history:
% - 0.5: Initial version


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

