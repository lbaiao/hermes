classdef StoppingCriteria
%STOPPINGCRITERIA class defines stopping criteria enumerated constants.
%   This class creates enumerated constants to define drops stopping criteria
%
%   Read-Only Public Properties:
%      MAX_DROPS - simulation stops with maximum number of drops
%      CONFIDENCE_INTERVAL_BER - simulation stops when all SNRs achieve a given
%               confidence interval in BER
%      CONFIDENCE_INTERVAL_BLER - simulation stops when all SNRs achieve a
%               given confidence interval in BLER
%
%   Author: Erika Portela Lopes de Almeida (EA)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org.br
%   History:
%       v1.0 03 Mar 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration

        MAX_DROPS, ...
        CONFIDENCE_INTERVAL_BER;
        CONFIDENCE_INTERVAL_BLER;

    end

end
