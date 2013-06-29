function [Abound, Afree] = coop2_saturation(MTtot, Atot, K1, K2)
% A function which calculates the biding of A to MT assuming a cooperative
% binding where 2 MTs bind to each A. The first MT binds with a disociation
% constant of K1 and the second MT binds with a disociation constant of K2.
% Here the total concentrations of MT and A are MTtot and Atot and in the
% experiment run MTtot is held constant and Atot is varied.

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


% Gets the size of Atot and creates an empty vector of the same size for
% Afree
[a, b] = size(Atot);
MTfree = zeros(a,b);
Frac = zeros(a,b);
Afree = zeros(a,b);
Abound = zeros(a,b);

% Steps through Atot, calculating MTfree at each value
for m = 1:b
    
    % Sets the x interval for fzero
    Xint = [0,MTtot];
    
    % Sets us the function to calculate MTfree and calculates MTfree
    f = @(MT)MT + Atot(m)*(2*MT/K1 + 4*MT^2/(K1*K2))/(1 + 2*MT/K1 + 2*MT^2/(K1*K2)) - MTtot;
    [MTfree(m), y, exit] = fzero(f,Xint);
    
    % Checks to make sure that fzero has successfully calculated MTfree and
    % exits calculation if it has not
    if exit ~= 1 || isnan(MTfree(m))
        Abound = 0;
        Afree = 0;
        return
    end
    
    % Calculates the fraction of A sites with an MT bound
    Frac(m) = (MTfree(m)/K1 + 2*MTfree(m)^2/(K1*K2))/(1 + 2*MTfree(m)/K1 + 2*MTfree(m)^2/(K1*K2));

    % Calculates Abound
    Abound(m) = Atot(m)*Frac(m);
    
end

% Calculates Afree
Afree = Atot - Abound;



end
