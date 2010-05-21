function [Frac, MTfree, Abound, Afree] = first_order(MTtot, Atot, KD, N)
% A function which calculates the biding of A to MT assuming first order
% binding where the total concentrations of A and MT are Atot and Btot and
% the disassociation constant is KD.

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


% Declares variables, creating symbolic versions of KD, Atot, and Btot to
% be used in the solver
syms A kd mtt at

% Solves for free and bound A
A1 = solve(A + (1/kd)*A*mtt/(1 + (1/kd)*A)- at, A);
AF = subs(A1(1), {kd mtt at}, {KD MTtot*N Atot});
AB = Atot - AF;
Abound = real(AB);
Afree = real(AF);

% Solves for fraciton of A bound
f = (Abound)./Atot;
Frac = real(f);

% Solves for free MT
mt = MTtot./(1 + (1/KD).*(Afree));
MTfree = real(mt);

end
