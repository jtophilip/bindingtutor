function [Frac, MTfree] = coop4_binding(MTtot, Atot, K1, K2, K3, K4)
% A function which calculates the biding of A to MT assuming a sequential
% cooperativity where 4 MTs can bind to one A, with the first MT binding
% with a dissocition constant of K1, the second MT binding with a
% dissocation constant K2, the third MT binding with a disociation constant
% of K3, and the fourth MT binding with a disocation constant K4. Where the
% total concentrations of MT and A are MTtot and Atot for an experiment
% where MT is varied an A is held constant.

% This file is part of MTBindingSim.
%
% Copyright (C) 2010-2013  University of Notre Dame
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

% Determines the size of the MTtot vector and creates an empty vector of
% the same size for Afree
[a, b] = size(MTtot);
MTfree = zeros(a,b);



% Steps through MTtot, calculating MTfree at each value
for m = 1:b
    
    % Sets interval for fzero
    Xint = [0,MTtot(m)];
    
    % Creates a function of MTfree and calculates the value of MTfree
    f = @(MT)MT + Atot*(4*MT/K1 + 24*MT^2/(K1*K2) + 72*MT^3/(K1*K2*K3) + 96*MT^4/(K1*K2*K3*K4))/(1 + 4*MT/K1 + 12*MT^2/(K1*K2) + 24*MT^3/(K1*K2*K3) + 24*MT^4/(K1*K2*K3*K4)) - MTtot(m);
    [MTfree(m), y, exit] = fzero(f,Xint);
    
    % Checks to make sure that fzero has sucessfully calculated a value for
    % MTfree and exits the calculation if it has not
    if isnan(MTfree(m)) || exit ~= 1
        Frac = 0;
        MTfree = 0;
        return
    end
    
end

% Calculates the fraction of A sites with an MT bound
Frac = (4*MTfree./K1 + 24*MTfree.^2./(K1*K2) + 72*MTfree.^3./(K1*K2*K3) + 96*MTfree.^4./(K1*K2*K3*K4))./(4 + 16*MTfree./K1 + 48*MTfree.^2./(K1*K2) + 96*MTfree.^3./(K1*K2*K3) + 96*MTfree.^4./(K1*K2*K3*K4));


end
