function dataBits = decode ( this, llrInput )
%CHANNELCODE.DECODE A simple dummy decoder that does not decode.
%   Detailed description is in class header.
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v1.0 23 Mar 2015 (FF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    % hard decision
    % positive LLR -> 1
    % negative LLR -> 0
	%     zero LLR -> 0
    dataBits = llrInput > 0;
    
end
