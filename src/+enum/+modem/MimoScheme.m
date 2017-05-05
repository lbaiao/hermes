classdef MimoScheme
%MIMOSCHEME class defines MIMO scheme type enumerated constants.
%
%	Read-Only Public Properties
%   	NONE - single antenna transmission
%   	TRANSMIT_DIVERSITY - MIMO transmit diversity
%       OPEN_LOOP - MIMO open-loop spatial multiplexing
%       GENERIC - user defined MIMO precoding matrix
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: <fadhil.firyaguna>@indt.org
%   History:
%       v1.1 22 Apr 2015 (FF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    enumeration
        
        NONE, ...
        TRANSMIT_DIVERSITY, ...
        OPEN_LOOP, ...
        CLOSED_LOOP, ...
        GENERIC
    
    end
    
end