function gain = calculateGain( this , maxGain_dBi, azimuthAngle_rad, ...
    elevationAngle_rad )
%ANTENNA.CALCULATEGAIN calculates isotropic antenna gain.
%   Detailed description is in class header.
%
%   Author: Erika Portela Lopes de Almeida (EA)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org.br
%   History:
%       v1.0 16 Mar 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% for an isotropic antenna, the gain is always 1.
gain = 1;

end


