function [Frac, MTfree] = MAP2_binding(MTtot, Atot, KM, KA, N)
% A function which calculates the binding of A to MT assuming that A binds
% to MT with a disassociation constant of KM and that a second and third A can bind
% to an MT-bound A with a disassociation constant of KA when [MT] is varied
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


% Determines the size of MTtot and creates an empty vector of the same size
% for Afree
[a,b] = size(MTtot);
Afree = zeros(a,b);

% Sets the interval for fzero
Xint = [0, Atot];

% Steps through MTtot calculating Afree at each point
for n = 1:b
    
    % Sets up the equation for Afree and calculates Afree
    f = @(A)A + (A/KM + 2*A^2/(KA*KM) + 3*A^3/(KA^2*KM))*MTtot(n)*N/(1 + A/KM + A^2/(KA*KM) + A^3/(KA^2*KM)) - Atot;
    [Afree(n), y, exit] = fzero(f, Xint);

    % Checks to make sure that fzero sucessfully calculated Afree and stops
    % calculation if it did not
    if isnan(Afree(n)) || exit ~= 1
        Frac = 0;
        MTfree = 0;
        return
    end

end

% Calculates Abound
Abound = Atot - Afree;

% Calculated the fraction of A bound
Frac = Abound./Atot;

% Calculated MTfree
MTfree = MTtot./(1 + Afree./KM + Afree.^2./(KM*KM) + Afree.^3./(KA^2*KM));

end