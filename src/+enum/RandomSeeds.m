classdef RandomSeeds < uint32
%RANDOMSEEDS class defines random streams constants
%
%   Read-Only Public Properties:
%      NOISE - noise random stream enum
%      MULTIPATH_MODEL - multipath model random stream enum
%      SOURCE - source random stream enum
%      FRAME - frame random stream enum   
%
%   Author: Erika Portela Lopes de Almeida (EA)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org.br
%   History:
%       v1.0 05 Mar 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    enumeration
        
       NOISE (1)
       MULTIPATH_MODEL (2)
       SOURCE (3)
       ENCODER (4)
       FRAME (5)
        
    end
    
end