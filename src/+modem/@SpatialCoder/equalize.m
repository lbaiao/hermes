function [ equalizedSignal ] = equalize( this, mimoSignal, ...
                                               channel )
%SPATIALCODER.EQUALIZE method calls the specific equalizer of each scheme.
%   Detailed description at class header.
%   
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 23 Apr 2015 (FF) - created
%	
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%	
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

equalizedSignal = this.doEqualize( mimoSignal, channel );

end

