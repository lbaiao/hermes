classdef Cost259FadingChannel < channel.FadingChannel
%FADINGCHANNEL class implements a COST 259 fading wireless channel
%   This class defines a multipath fading channel, with multiple inputs and
%   multiple outputs, based on the COST 259 model.
%   This is based on the model implemented in channel.FadingChannel, with
%   the power delay profile as specified in 3GPP TR25.943 v12.0.0 Rel. 12
%
%   Constructor
%       Syntax: this = channel.Cost259FadingChannel
%           ( txAnts, rxAnts, randomGen, samplingRate, updatePeriod,
%             dopplerSpread, channelType,rxCov, txCov, nSin, 
%             interFrameInterf )
%       Inputs:
%           profile - described in Channel
%           txAnts - described in Channel
%           rxAnts - described in Channel
%           random - described in Channel
%           samplingRate - described in Channel
%           updatePeriod - described in Channel
%           dopplerSpread - described in FadingChannel
%           channelType< enum.channel.Cost259 > - type of the channel
%                                                 (urban, rural, hilly)
%           rxCov - described in FadingChannel
%           txCov - described in FadingChannel
%           nSin - described in FadingChannel
%           interFrameInterf - described in FadingChannel
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <andre.barreto>@indt.org.br
%   History:
%       v2.0 28 May 2015 (ANB) - created (no multipath)
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


methods
    
    % constructor
    function this = Cost259FadingChannel( txAnts, ...
                                          rxAnts, ...
                                          randomGen, ...
                                          samplingRate, ...
                                          updatePeriod, ...
                                          dopplerSpread, ...
                                          channelType, ...
                                          rxCov, txCov, nSin, ...
                                          interFrameInterf )
                               
        if ~exist( 'rxCov', 'var' )
            rxCov = [];
        end
        
        if ~exist( 'txCov', 'var' )
            txCov = [];
        end        
        
        if ~exist( 'nSin', 'var' )
            nSin = [];
        end        
        
        if ~exist( 'tailBiting', 'var' )
            interFrameInterf = [];
        end        
        
        
                                         
        switch channelType
            case enum.channel.Cost259.TYPICAL_URBAN
                delays_s = ...
                    [ 0 .217 .512 .514 .517 .674 .882 1.230 1.287 1.311 ...
                      1.349 1.533 1.535 1.622 1.818 1.836 1.884 1.943 ...
                      2.048 2.140 ] * 1e-6;
                powerDelayProfile_dB = ...
                    [ -5.7 -7.6 -10.1 -10.2 -10.2 -11.5 -13.4 -16.3 -16.9 ...
                      -17.1 -17.4 -19.0 -19.0 -19.8 -21.5 -21.6 -22.1 ...
                      -22.6 -23.5 -24.3 ];
                kRice_dB = -inf;
            
            case enum.channel.Cost259.RURAL_AREA
                delays_s = ...
                    [ 0 .042 .101 .129 .149 .245 .312 .410 .469 .528] * 1e-6;
                powerDelayProfile_dB = ...
                    [-5.2 -6.4 -8.4 -9.3 -10.0 -13.1 -15.3 -18.5 -20.4 -22.4];
                kRice_dB = -inf;
                
            case enum.channel.Cost259.HILLY_TERRAIN
                
                delays_s = ...
                    [ 0 .356 .441 .528 .546 .609 .625 .842 .916 .941 ...
                      15.0 16.172 16.492 16.876 16.882 16.978 17.615 ...
                      17.827 17.849 18.016 ] * 1e-6;
                powerDelayProfile_dB = ...
                    [ -3.6 -8.9 -10.2 -11.5 -11.8 -12.7 -13.0 -16.2 -17.3 ...
                      -17.7 -17.6 -22.7 -24.1 -25.8 -25.8 -26.2 -29.0 ...
                      -29.9 -30.0 -30.7 ];
                  
                nRayleighPaths = length( delays_s ) - 1;   
                kRice_dB = [ inf -inf( 1, nRayleighPaths ) ];
        end
        
        
        this@channel.FadingChannel (  txAnts, rxAnts, randomGen, ...
                                      samplingRate, updatePeriod, ...
                                      dopplerSpread, delays_s, ...
                                      powerDelayProfile_dB, kRice_dB, ...
                                      rxCov, txCov, nSin, interFrameInterf )
                                  
        if channelType == enum.channel.Cost259.RURAL_AREA
            this.losTheta(1) = acos(.7);
        end


    end
end

end