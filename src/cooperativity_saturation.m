function [Abound, Afree] = cooperativity_saturation(MTtot, Atot, KD, P, N)
% A function which calculates the binding of A to MT assuming cooperative
% binding where the total concentrations of A and MT are Atot and MTtot,
% the disassociation constant for the first bound A is KD, and the
% disassociation constant for the second bound A is KD*P

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

[a,b] = size(Atot);
Afree = zeros(a,b);

Xguess = Atot(1)/2;

for n = 1:b
    
    f = @(A)A + ((2/KD)*A + (2/(P*(KD^2)))*A^2)*MTtot*N/(1 + (2/KD)*A + (2/(P*(KD^2)))*A^2)-Atot(n);
    Afree(n) = fzero(f,Xguess);
    
    if isnan(Afree(n))
        Afree = 0;
        Abound = 0;
        return
    end
    
    Xguess = Afree(n);
    n = n +1;
    
end

Abound = Atot - Afree;


end

