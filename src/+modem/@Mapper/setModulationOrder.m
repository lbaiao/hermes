function setModulationOrder( this, modulationOrder )
%MAPPER.SETMODULATIONORDER changes the current modulation order.
% Detailed description can be found in class header.
%
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Brasilia
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 10 Apr 2015 - (ANB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


bitsPerSymbol = log2( modulationOrder );
if isempty( this.symbolAlphabet{ bitsPerSymbol } )
    error('invalid modulation order')
end

this.modulationOrder = modulationOrder;
