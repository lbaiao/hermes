function mainStatistics = getMainStatistics( this )
% STATISTICS.UPDATEDROP add new frame statistics to a drop.
%   Detailed information in class header.
%
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 08 Apr 2015 - ( ANB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

mainStatistics.snrVector = this.snrVector;
mainStatistics.confidenceLevel = this.confidenceLevel;
mainStatistics.berMean = this.berMean;
mainStatistics.blerMean = this.blerMean;
mainStatistics.berErrorMargin = this.berErrorMargin;
mainStatistics.blerErrorMargin = this.blerErrorMargin;
mainStatistics.throughput = this.numberOfEffectiveBits ./ ...
                           this.simulatedTime;

end
