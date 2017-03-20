classdef AntennaType
%ANTENNATYPE class defines enumerated constants for antenna type
%
%   Read-Only Public Properties:
%       OMNI - defines omnidirectional type
%       ISOTROPIC - defines isotropic type
%       USER_DEFINED - type is defined by user
%
%   Author: Lilian Freitas
%   Work Address: INDT Manaus
%   E-mail: lilian.freitas@indt.org.br
%   History:
%      v1.0 10 Apr 2015 (LCF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration
        OMNI
        ISOTROPIC
        USER_DEFINED
    end
end
