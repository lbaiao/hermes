function out = checkAllStoppingCriteria( this,  statistics )
%DROPLOOP.CHECKSTOPPINGCRITERIA method check all simulation stopping criteria.
%
%   Syntax: out = checkAllStoppingCriteria( statistics )
%
%   Inputs:
%       statistics < object > - object from class Statistics containing the
%                               blerPerSnr parameter
%   Outputs:
%       out < 1 x snrValues double > - vector containing true if a given
%                      snrValue does not need more samples to statistics
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

% get all stopping criteria
stopCriteria = this.stoppingCriteria;

% get current drop
thisDrop = this.currentDrop;

% initialize stoppingCriteria index (in case there is more than
% one )
index = 1;

hasMetStoppingCriteria = false;

hasCheckedAllStoppingCriteria = false;

% creates a vector <1 x #SNRvalues> of 0`s
currentStoppingStatus = this.metStoppingCriteriaPerSNR;

while ~hasMetStoppingCriteria && ~hasCheckedAllStoppingCriteria

    % if the number of drops is below the minimum, it doesn't
    % calculate check stopping criteria
    if thisDrop < this.minimumNumberOfDrops

        hasCheckedAllStoppingCriteria = true;

    else

        stoppingStatusAccordingToCriterion = ...
            this.checkStoppingCriterion( statistics, index );

        currentStoppingStatus = currentStoppingStatus | ...
            stoppingStatusAccordingToCriterion;

        % update object stopping status
        this.metStoppingCriteriaPerSNR = currentStoppingStatus;

        % has met stoppingCriteria for all values of SNR
        if sum( currentStoppingStatus ) == length( currentStoppingStatus )
            hasMetStoppingCriteria = true;
        end

        index = index + 1;

        % has finishing checking all stop criteria
        if index > length( stopCriteria )

            hasCheckedAllStoppingCriteria = true;

        end

    end

end

% update out variable with stopping status per SNR value
out = currentStoppingStatus;

end
