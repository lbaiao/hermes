function noiseVariance = estimateNoise ( this )                     
%INNERRECEIVER.ESTIMATENOISE estimates noise variance
%   This is a protected method of InnerReceiver that estimates noise
%   variance according to the assigned estimation method.
%   Currently, only ideal noise estimation is possible.
%
%   Syntax: noiseVariance = estimateNoise ( )
% 
%   Output:
%       noiseVariance < double > - noise variance
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v2.0 11 Jun 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.                             
                             


switch ( this.noiseEstimationAlgo )
    case enum.modem.NoiseEstimation.PERFECT
    
        
        noiseVariance = this.thermalNoise.variance;
        
    otherwise
        error('invalid noise estimation algorithm')
end

end