function [Frac, MTfree] = cooperativity_binding(MTtot, Atot, KAM, P, N)
% A function which calculates the binding of A to MT assuming cooperative
% binding where the total concentrations of A and MT are Atot and MTtot,
% the disassociation constant for the first bound A is KAM, and the
% disassociation constant for the second bound A is KAM*P for an experiment
% where [MT] is varied and [A] is held constant.

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

% Sets interval for fzero
Xint = [0,Atot];

% Steps through MTtot, calculation Afree at each point
for n = 1:b
    
    % Sets up the equation for calcualting Afree and preforms the
    % calcuation
    f = @(A)A + ((2/KAM)*A + (2/(P*(KAM^2)))*A^2)*MTtot(n)*N/(1 + (2/KAM)*A + (2/(P*(KAM^2)))*A^2)-Atot;
    [Afree(n), y, exit] = fzero(f,Xint);
    
    % Checks to make sure that fzero sucessfully calculated Afree and ends
    % calcualation if it did not
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

% Calculates free MT
MTfree = MTtot./(1 + (2/KAM).*Afree + (2/(P*KAM)).*Afree.^2);


end

