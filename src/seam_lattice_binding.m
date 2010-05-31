function [Frac, MTfree] = seam_lattice_binding(MTtot, Atot, KS, KL, N)
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

% Calculates total concentrations of seam and lattice
ST = MTtot.*N./13;
LT = MTtot.*N.*12./13;

[a,b] = size(MTtot);
Afree = zeros(a,b);

Xguess = MTtot(1);

for n = 1:b
    f = @(A)A + (1/KS)*A*ST(n)/(1 + (1/KS)*A) + (1/KL)*A*LT(n)/(1 + (1/KL)*A) - Atot;
    Afree(n) = fzero(f,Xguess);
    
    if isnan(Afree)
        Frac = 0;
        MTfree = 0;
        return
    end
    
    Xguess = Afree(n);
    
end

Abound = Atot - Afree;

% Calculates the fraction of A bound
Frac = Abound./Atot;

% Calculates free seam and lattice
s = ST./(1+(1/KS).*Afree);
l = LT./(1 + (1/KL).*Afree);
MTfree = s  + l;

end