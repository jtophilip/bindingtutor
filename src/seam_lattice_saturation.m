function [Abound, Afree] = seam_lattice_saturation(MTtot, Atot, KS, KL, N)
% A function which calculates the binding of A to MT assuming that A binds
% to the seam of the MT with disassociation constant KS and the lattice of
% the MT with disassociation constant KL for an experiment where [A] is
% varied and [MT] is held constant.

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

% Calculates the total concentrations of seam and lattice
ST = MTtot.*N./13;
LT = MTtot.*N.*12./13;

% Determines the size of Atot and creates an empty vector of the same size
% for Afree
[a,b] = size(Atot);
Afree = zeros(a,b);

% Sets the inital guess for Afree
Xguess = Atot(1)/2;

% Steps through Atot, calculating the value of Afree at each point
for n = 1:b
    
    % Sets up the equation for Afree and calculates its value
    f = @(A)A + (1/KS)*A*ST/(1 + (1/KS)*A) + (1/KL)*A*LT/(1 + (1/KL)*A) - Atot(n);
    Afree(n) = fzero(f,Xguess);
    
    % Checks to make sure that fzeros sucessfully calculated Afree and ends
    % calculation if it did not
    if isnan(Afree)
        Abound = 0;
        Afree = 0;
        return
    end
    
    % Sets the guess for the next iteration to the calcualted value of
    % Afree
    Xguess = Afree(n);
    
end

% Calculates Abound
Abound = Atot - Afree;

end