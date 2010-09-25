function [Frac] = competition(MTtot, Atot, Btot, KAM, KBM)
% A function which calculates the binding of A to MT assuming a competition
% assay where A binds to MT with a KD of KAM and B binds to MT with a KD of
% KBM. In this competition assay, Atot and MTtot are kept constant while
% Btot is varied.

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

% Determines the size of Btot and creates an empty vector of the same size
% for MTfree
[a,b] = size(Btot);
MTfree = zeros(a,b);

% Sets interval for fzero
Xint = [0, MTtot];

% Steps through Btot, calculating MTfree at each point
for n = 1:b
    % Sets up the function to calculate MTfree and does the calculation
    f = @(MT)MT + (1/KAM)*MT*Atot/(1 + (1/KAM)*MT) + (1/KBM)*MT*Btot(n)/(1 + (1/KBM)*MT) - MTtot;
    [MTfree(n), y, exit] = fzero(f, Xint);
    
    % Checks to make sure that fzero sucessfully calculated MTfree and ends
    % the caclculation if it did not
    if isnan(MTfree(n)) || exit ~= 1
        Frac = 0;
        return
    end

end

% Calculates A free
Afree = Atot./(1 + (1/KAM).*MTfree);

% Calculates A bound
Abound = Atot - Afree;

% Calculates the fraction of A bound
Frac = Abound./Atot;

end

