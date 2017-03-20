function updateStoppingCriteria( this, stoppingCriteriaVector )
%UPDATESTOPPINGCRITERIA this method update stopping criteria
%
%   Syntax: updateStoppingCriteria( stoppingCriteriaVector )
%
%   Inputs:
%     stoppingCriteriaVector - defines stoppping criteria vector
%
%   Author: Erika Portela Lopes de Almeida (EA), Fadhil Firyaguna (FF),
%           Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: erika.almeida@indt.org.br, fadhil.firyaguna@indt.org,
%           andre.noll@indt.org
%   History:
%       v1.0 10 Apr 2015 (EA, FF, ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

this.metStoppingCriteriaPerSNR = stoppingCriteriaVector | ...
    this.metStoppingCriteriaPerSNR;

end
