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


[a,b] = size(MTtot);
Afree = zeros(a,b);

Xguess = MTtot(1);

% Steps through MTtot calculating Afree at each point
for n = 1:b
    f = @(A)A + (A/KM + 2*A^2/(KA*KM) + 3*A^3/(KA^2*KM))*MTtot(n)*N/(1 + A/KM + A^2/(KM*KM) + A^3/(KA^2*KM)) - Atot;
    Afree(n) = fzero(f, Xguess);

    if isnan(Afree(n))
        Frac = 0;
        MTfree = 0;
        return
    end
    Xguess = Afree(n);

end

% Calculates Abound, Frac, and MTfree
Abound = Atot - Afree;

Frac = Abound./Atot;

MTfree = MTtot./(1 + Afree./KM + Afree.^2./(KM*KM) + Afree.^3./(KA^2*KM));

end