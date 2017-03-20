classdef Property
%ENUM.PARAMETERCHECK.PROPERTY class defines parameters properties
%
% It's an enumaration class with the following properties.
%   Read-Only Public Properties:
%      IS_VECTOR - parameter may be a vector
%      IS_CELL_ARRAY - parameter is a cell array
%      IS_MANDATORY - parameter is mandatory
%      IGNORE_SUBFIELDS - do not verify parameter subfields
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v2.0 28 Apr 2015 - created (AB)
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    enumeration
        
       IS_VECTOR
       IS_CELL_ARRAY
       IS_MANDATORY
       IGNORE_SUBFIELDS
        
    end
    
end