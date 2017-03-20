classdef CodeType
%CODETYPE class defines channel code type enumerated constants.
%
%   Read-Only Public Properties
%      NONE - no channel code will be used
%      CONVOLUTIONAL - Convolutional Code will be used
%      TURBO - Convolutional Turbo Code will be used
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: <fadhil.firyaguna>@indt.org
%   History:
%       v1.0 06 Mar 2015 (FF) - created
%       v2.0 8  Jul 2015 (RA) - Convolutional Code added.
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration

        NONE, ...
        CONVOLUTIONAL, ...
        TURBO;

    end
end
