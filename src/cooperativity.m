function [Frac, MTfree, Abound, Afree] = cooperativity(MTtot, Atot, KD, P)
% A function which calculates the binding of A to MT assuming cooperative
% binding where the total concentrations of A and MT are Atot and MTtot,
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
syms A kd mtt at p

% Calculates free and bound A
A1 = solve(A + ((2/kd)*A + (4/(p*(kd^2)))*A^2)*mtt/(1 + (2/kd)*A + (2/(p*(kd^2)))*A^2)-at, A);
AF = subs(A1(1), {kd at mtt p}, {KD Atot MTtot P});
AB = Atot - AF;
Abound = real(AB);
Afree = real(AF);

% Calculates the fraction of A bound
f = Abound./Atot;
Frac = real(f);

% Calculates free MT
mt = MTtot./(1 + (2/KD).*Afree + (2/(P*KD)).*Afree.^2);
MTfree = real(mt);

end

