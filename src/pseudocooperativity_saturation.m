function [Abound, Afree] = pseudocooperativity_saturation(MTtot, Atot, KAM, KAMP, N)
% A function which calculates the biding of A to MT assuming a
% pseudocoopeartive situtation where for every A bound to MT another MT
% sites is changed to an MT prime site which has a dissocaiton constant of
% KAMT prime. Here MTtot is a vector of MT total values, Atot is the
% contsant A total, KAM is the dissociation binding constant for A binding
% to normal MT sites, KAMP is the dissociation binding constant for A
% binding to MT prime sites, and N is the binding ratio.

% This file is part of MTBindingSim.
%
% Copyright (C) 2010-2011  University of Notre Dame
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

% Determines the size of the Atot vector and creates an empty vector of
% the same size for Afree
[a, b] = size(Atot);
Afree = zeros(a,b);



% Steps through Atot, calculating Afree at each value
for n = 1:b
    
    % Sets interval for fzero
    Xint = [0,Atot(n)];
    
    % Creates a function of Afree and calculates the value of Afree
    f = @(A)A + ((A/KAM) + A^2/(KAM*KAMP))*MTtot/(1 + 2*A/(KAM*N) + A^2/(KAM*KAMP*N)) - Atot(n);
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


end
