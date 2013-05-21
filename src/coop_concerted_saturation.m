function [Abound, Afree] = coop_concerted_saturation(MTtot, Atot, KAM, n)
% A function which calculates the biding of A to MT assuming a concerted
% cooperative binding in which n molecules of MT bind to a single A at one
% time with a disociaiton constant of KAM. Here the total concentrations
% of MT and A are MTtot and Atot and in the experiment run MTtot is held
% constant and Atot is varied.

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


% Steps through Atot, calculating MTfree at each value
for m = 1:b
    
    % Sets the x interval for fzero
    Xint = [0,MTtot];
    
    % Sets us the function to calculate MTfree and calculates MTfree
    f = @(MT)MT + Atot(m)*n*MT^n/(KAM*(1 + MT^n/KAM)) - MTtot;
    [MTfree(m), y, exit] = fzero(f,Xint);
    
    % Checks to make sure that fzero has successfully calculated MTfree and
    % exits calculation if it has not
    if exit ~= 1 || isnan(MTfree(m))
        Abound = 0;
        Afree = 0;
        return
    end
    
end

% Calculates Afree
Afree = Atot./(1 + MTfree.^n./KAM);

% Calculates Abound
Abound = Atot - Afree;


end
