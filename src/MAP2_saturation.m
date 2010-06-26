function [Abound, Afree] = MAP2_saturation(MTtot, Atot, KM, KA, N)
% A function which calculates the binding of A to MT assuming that A binds
% to MT with a disassociation constant of KM and that a second and third A can bind
% to an MT-bound A with a disassociation constant of KA when [A] is varied
% and [MT] is held constant.

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

% Gets the size of Atot and creates an empty vector of the same size for
% Afree
[a,b] = size(Atot);
Afree = zeros(a,b);


% Steps through Atot calculating Afree at each point
for n = 1:b
    
    % Sets the interval for fzero
    Xint = [0, Atot(n)];
    
    % Sets up the equation for Afree and calculates its value
    f = @(A)A + (A/KM + 2*A^2/(KA*KM) + 3*A^3/(KA^2*KM))*MTtot*N/(1 + A/KM + A^2/(KM*KM) + A^3/(KA^2*KM)) - Atot(n);
    [Afree(n), y, exit] = fzero(f, Xguess);

    % Checks to make sure fzero sucessfully calculated Afree and ends
    % calculation if it didn't
    if isnan(Afree(n)) || exit ~= 1
        Afree = 0;
        Abound = 0;
        return
    end

end

% Calculates Abound
Abound = Atot - Afree;

end