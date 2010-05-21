function [Frac, MTfree, Abound, Afree] = MAP_bind(MTtot, Atot, KM, KA, N)
% A function which calculates the binding of A to MT assuming that A binds
% to MT with a disassociation constant of KM and that a second A can bind
% to an MT-bound A with a disassociation constant of KA

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

% Declares symbolic variables
syms A at mtt ka km

% Calculates free and bound A
A1 = solve(A + (A/km + 2*A^2/(ka*km))*mtt/(1 + A/km + A^2/(km*ka)) - at, A);
AF = subs(A1(1), {at mtt km ka}, {Atot MTtot*N KM KA});
AB = Atot - AF;
Abound = real(AB);
Afree = real(AF);

% Calculates the fraction bound
F = Abound./Atot;
Frac = real(F);

% Calculates free MT
mt = MTtot./(1 + Afree./KM + Afree.^2./(KM*KA));
MTfree = real(mt);

end

