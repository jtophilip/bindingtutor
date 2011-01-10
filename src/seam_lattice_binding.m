function [Frac, MTfree] = seam_lattice_binding(MTtot, Atot, KAS, KAL, N)
% A function which calculates the binding of A to MT assuming that A binds
% to the seam of the MT with dissociation constant KAS and the lattice of
% the MT with dissociation constant KAL for an experiment where [MT] is
% varied and [A] is held constant.

% This file is part of MTBindingSim.
%
% Copyright (C) 2010-2011  University of Notre Dame
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

% Calculates vectors for the total concentrations of seam and lattice
ST = MTtot./13;
LT = MTtot.*12./13;

% Determines the size of MTtot and creates an empty vector of the same size
% for Afree
[a,b] = size(MTtot);
Afree = zeros(a,b);

% Sets the interval for fzero
Xint = [0, Atot];

% Steps through MTtot, calculating Afree at each point
for n = 1:b
    
    % Sets up the equation for Afree and calculates it
    f = @(A)A + (1/KAS)*A*ST(n)/(1 + (1/(KAS*N))*A) + (1/KAL)*A*LT(n)/(1 + (1/(KAL*N))*A) - Atot;
    [Afree(n), y, exit] = fzero(f,Xint);
    
    % Checks to make sure that fzero sucessfully calculated Afree and ends
    % calculation if it did not
    if isnan(Afree(n)) || exit ~= 1
        Frac = 0;
        MTfree = 0;
        return
    end
    
end

% Calculates Abound
Abound = Atot - Afree;

% Calculates the fraction of A bound
Frac = Abound./Atot;

% Calculates free seam, lattice, and total MT
s = ST./(1+(1/(KAS*N)).*Afree);
l = LT./(1 + (1/(KAL*N)).*Afree);
MTfree = s  + l;

end
