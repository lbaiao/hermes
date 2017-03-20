classdef FiveGInnerReceiver < modem.InnerReceiver
%FIVEGINNERRECEIVER class implements the inner receiver of a 5G modem.
%   This class is a subclass from InnerReceiver class
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v2.0 04 May 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    
properties ( Access = 'protected' )
    
frame
channelEstimationTime

end
    
    
methods ( Access = 'public' )

    %%
    % constructor
    function this = FiveGInnerReceiver( demodulator, ...
                                        channelEstimationAlgo, ...
                                        equalizationAlgo, ...
                                        noiseEstimationAlgo, frame )
        this@modem.InnerReceiver( demodulator, channelEstimationAlgo, ...
                                  equalizationAlgo, noiseEstimationAlgo );
                              
        this.frame = frame;
        
        % determine instant of reference signal
        this.channelEstimationTime = 0;
  
        found = false;
        for field = 1 : length( frame.frameFields )
            if frame.frameFields( field ) == ...
               enum.modem.fiveG.FrameMap.REF_SIGNAL;
                found = true;
                break
            end
            
            switch frame.frameFields( field )
                case enum.modem.fiveG.FrameMap.GUARD
                    this.channelEstimationTime = this.channelEstimationTime + ...
                        frame.fieldLength( field ) * frame.guardLength;
                case {enum.modem.fiveG.FrameMap.DL_CONTROL, ...
                      enum.modem.fiveG.FrameMap.UL_CONTROL, ...
                      enum.modem.fiveG.FrameMap.DATA }
                    this.channelEstimationTime = this.channelEstimationTime + ...
                        frame.fieldLength( field ) * frame.symbolLength;                   
            end
        end
        
        if ~found
            error('frame does not contain reference signal')
        end

                              
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

