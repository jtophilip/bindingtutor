function [Abound, Afree] = cooperativity_saturation(MTtot, Atot, KD, P, N)
% A function which calculates the binding of A to MT assuming cooperative
% binding where the total concentrations of A and MT are Atot and MTtot,
% the disassociation constant for the first bound A is KD, and the
% disassociation constant for the second bound A is KD*P for an experiment
% where [A] is varied and [MT] is held constant.

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

% Determines the size of Atot and creates an empty vector of the same size
% for Afree
[a,b] = size(Atot);
Afree = zeros(a,b);

% Sets the initial guess for Afree to Atot/2
Xguess = Atot(1)/2;

% Steps through Atot, calculating the value of Afree at each point
for n = 1:b
    
    % Sets up the equation for Afree and calculates it
    f = @(A)A + ((2/KD)*A + (2/(P*(KD^2)))*A^2)*MTtot*N/(1 + (2/KD)*A + (2/(P*(KD^2)))*A^2)-Atot(n);
    Afree(n) = fzero(f,Xguess);
    
    % Checks to make sure that fzero sucessfully calculated Afree and ends
    % calculation if it did not
    if isnan(Afree(n))
        Afree = 0;
        Abound = 0;
        return
    end
    
    % Sets the guess for the next iteration to the calculated value of
    % Afree
    Xguess = Afree(n);
    n = n +1;
    
end

% Calculates Abound
Abound = Atot - Afree;


end

