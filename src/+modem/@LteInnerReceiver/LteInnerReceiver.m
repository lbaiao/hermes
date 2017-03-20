classdef LteInnerReceiver < modem.InnerReceiver
%LTEINNERRECEIVER class implements the inner receiver of an LTE modem.
%   This class is a subclass from InnerReceiver class
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: 
%   History:
%       v1.0 17 Mar 2015 (ANB) - created (no multipath)
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    
properties ( GetAccess = 'public', SetAccess = 'protected' )

end
    
    
methods ( Access = 'public' )

    %%
    % constructor
    function this = LteInnerReceiver( demodulator, ...
                                      channelEstimationAlgo, ...
                                      equalizationAlgo, ...
                                      noiseEstimationAlgo )
        this@modem.InnerReceiver( demodulator, channelEstimationAlgo, ...
                                  equalizationAlgo, noiseEstimationAlgo );
    end
    % end constructor
end

methods ( Access = 'protected' )
    %%
    channel = getChannelInFrequency ( this, impulseResponse, samplingTimes, ...
                                      receivedSignal, referenceSignal )
    noiseVariancePerSymbol = ...
        this.calculateNoiseVariancePerSymbol( coefficients, noiseVariance );                                     
    
end

end

