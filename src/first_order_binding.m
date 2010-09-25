function [Frac, MTfree] = first_order_binding(MTtot, Atot, KAM, N)
% A function which calculates the biding of A to MT assuming first order
% binding where the total concentrations of A and MT are Atot and Btot and
% the disassociation constant is KAM for an experiemnt where [MT] is varied
% and [A] is held constant.

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

% Determines the size of the MTtot vector and creates an empty vector of
% the same size for Afree
[a, b] = size(MTtot);
Afree = zeros(a,b);

% Sets interval for fzero
Xint = [0,Atot];

% Steps through MTtot, calculating Afree at each value
for n = 1:b
    
    % Creates a function of Afree and calculates the value of Afree
    f = @(A)A + (1/KAM)*A*MTtot(n)*N/(1 + (1/KAM)*A) - Atot;
    [Afree(n), y, exit] = fzero(f,Xint);
    
    % Checks to make sure that fzero has sucessfully calculated a value for
    % Afree and exits the calculation if it has not
    if isnan(Afree(n)) || exit ~= 1
        Frac = 0;
        MTfree = 0;
        return
    end
    
end

% Calculates Abound
Abound = Atot - Afree;

% Solves for fraciton of A bound
Frac = (Abound)./Atot;

% Solves for free MT
MTfree = MTtot./(1 + (1/KAM).*(Afree));


end
