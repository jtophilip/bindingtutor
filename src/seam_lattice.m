function [Frac, MTfree, Abound, Afree] = seam_lattice(MTtot, Atot, KS, KL)
% A function which calculates the binding of A to MT assuming that A binds
% to the seam of the MT with disassociation constant KS and the lattice of
% the MT with disassociatio nconstant KL.

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

% Declares symbolic variables to be used in the solver
syms A ks kl st lat at

% Calculates total concentrations of seam and lattice
ST = MTtot./13;
LT = MTtot.*12./13;

% Calculates free and bound A
A1 = solve(A + (1/ks)*A*st/(1 + (1/ks)*A) + (1/kl)*A*lat/(1 + (1/kl)*A) - at, A);
AF = subs(A1(1), {at st lat ks kl}, {Atot ST LT KS KL});
AB = Atot - AF;
Abound = real(AB);
Afree = real(AF);

% Calculates the fraction of A bound
f = Abound./Atot;
Frac = real(f);

% Calculates free seam and lattice
s = ST./(1+(1/KS).*Afree);
l = LT./(1 + (1/KL).*Afree);
MTfree = real(s) + real(l);

end