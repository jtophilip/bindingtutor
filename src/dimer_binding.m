function [Frac, MTfree] = dimer_binding(MTtot, Atot, KAM, KAAM, KAA, N)
% A function which calculates the binding of A to MT assuming that A can
% bind to MT either as a monomer, with a KD of KAM, or as a dimer with a KD of KAAM.
% The dimerization KD is KAA.

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

% Determines the size of MTtot and creates an empty vector of the same size
% for Afree
[a,b] = size(MTtot);
Afree = zeros(a,b);

% Sets the interval for fzero
Xint = [0, Atot];

% Steps through MTtot calculating Afree at each point
for n = 1:b
    
    % Sets up the equation for Afree and calculates Afree
    f = @(A)A + 2*A^2/KAA + (A/KAM + 2*A^2/(KAA*KAAM))*MTtot(n)/(1 + A/(KAM*N) + 2*A^2/(KAA*KAAM*N)) - Atot;
    [Afree(n), y, exit] = fzero(f, Xint);

    % Checks to make sure that fzero sucessfully calculated Afree and stops
    % calculation if it did not
    if isnan(Afree(n)) || exit ~= 1
        Frac = 0;
        MTfree = 0;
        return
    end

end

% Calculates Abound
Abound = Atot - Afree  - 2*Afree.^2./KAA;

% Calculated the fraction of A bound
Frac = Abound./Atot;

% Calculated MTfree
MTfree = MTtot./(1 + Afree./(KAM*N) + 2*Afree.^2./(KAA*KAAM*N));
