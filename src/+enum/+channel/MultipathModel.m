classdef MultipathModel
%MULTIPATHMODEL class defines the channel multipath model enumerated constants.
%
%   Read-Only Public Properties:
%     NONE - no multipath model will be considered
%     GENERIC - generic model - needs to set a power delay profile and
%               covariance matrix
%     COST259 - COST 259, as specified in 3GPP TR25.943 v12.0.0 Rel. 12
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

       NONE, ...
       GENERIC
       COST259

    end
end
