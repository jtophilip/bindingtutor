function [Frac, MTfree, Abound, Afree] = MAP2_binding(MTtot, Atot, KM, KA, N)
% A function which calculates the binding of A to MT assuming that A binds
% to MT with a disassociation constant of KM and that a second and third A can bind
% to an MT-bound A with a disassociation constant of KA

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


syms A 

% Gets the size of MTtot and creates an empty vector of the same size for
% Afree
[a,b] = size(MTtot);
Afree = zeros(a,b);

tolerance = 0.0001;

% Steps through MTtot calculating Afree at each point
for n = 1:b
    AF = solve(A + (A/KM + 2*A^2/(KA*KM) + 3*A^3/(KA^2*KM))*MTtot(n)*N/(1 + A/KM + A^2/(KM*KM) + A^3/(KA^2*KM)) - Atot, A);
    af = double(AF);
    if af(1) >= 0 && af(1) <= Atot && imag(af(1)) < tolerance
        Afree(n) = real(af(1));
    elseif af(2) >= 0 && af(2) <= Atot && imag(af(2)) < tolerance
        Afree(n) = real(af(2));
    elseif af(3) >= 0 && af(3) <= Atot && imag(af(3)) < tolerance
        Afree(n) = real(af(3));
    elseif af(4) >= 0 && af(4) <= Atot && imag(af(4)) < tolerance
        Afree(n) = real(af(4));
    else
        Afree = 0;
        Frac = 0;
        Abound = 0;
        MTfree = 0;
        return
    end
    n = n +1;
end

% Calculates Abound, Frac, and MTfree
Abound = Atot - Afree;

Frac = Abound./Atot;

MTfree = MTtot./(1 + Afree./KM + Afree.^2./(KM*KM) + Afree.^3./(KA^2*KM));

end