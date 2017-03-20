function metStoppingCriterion = checkStoppingCriterion( this, statistics, index )
%DROPLOOP.CHECKSTOPPINGCRITERION method check a simulation stopping criterion.
%   Stopping criteria are defined in simulation settings. Currently, there
%   are two options available: maximum number of drops and confidence
%   interval. More information can be found on DropLoop class.
%
%   Syntax: out = checkStoppingCriterion( statistics, index )
%
%   Inputs:
%       statistics < object > - object from class Statistics containing the
%                               blerPerSnr parameter
%       index < integer > - stopping criterion index to be checked. This is
%            used when more than one stopping criterion is defined in SETTINGS.
%
%   Outputs:
%       metStoppingCriterion < 1 x numberOfSnrValues double > vector that
%           is true for those values of SNR that don't need more samples
%           according to criterion.s true
%
%   Author: Erika Portela Lopes de Almeida (EA)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org.br
%   History:
%       v1.0 18 Feb 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


% get current drop
drop = this.currentDrop;

% get stopping criteria to be checked
currentStoppingCriterion = this.stoppingCriteria( index );

% find current stopping criteria
switch currentStoppingCriterion

    % if stopping criterion is the maximum number of drops
    case enum.drops.StoppingCriteria.MAX_DROPS

        metStoppingCriterion = ( drop >= this.maximumNumberOfDrops );

        % if stopping criterion is the confidence interval
    case enum.drops.StoppingCriteria.CONFIDENCE_INTERVAL_BER

        metStoppingCriterion = ( statistics.berErrorMargin <= ...
                                 this.errorMargin );

    case enum.drops.StoppingCriteria.CONFIDENCE_INTERVAL_BLER

        metStoppingCriterion = ( statistics.blerErrorMargin <= ...
                                 this.errorMargin );

end

end
