classdef (Abstract) InnerReceiver < handle
%INNERRECEIVER class implements the inner receiver of a wireless modem.
%   The inner receiver is responsible for auxiliary functions in a wireless
%   receiver, such as automatic gain control, synchronization, channel
%   estimation, equalization, among others.
%   This is an abstract class, actual implementations must be defined for
%   each particular technology.
%
%   Read-Only Public Properties:
%       demodulator - as described in constructor
%       channelEstimationAlgo -  as described in constructor
%       equalizationAlgo -  as described in constructor
%       noiseEstimationAlgo - as described in constructor 
%
%   Constructor
%       Syntax: this = modem.InnerReceiver( demodulator, ...
%                                           channelEstimationAlgo, ...
%                                           equalizationAlgo, ...
%                                           noiseEstimationAlgo )
%       Input:
%           demodulator < BlockModulation > - demodulates the received
%               signal according to the algorithms in BlockModulation  
%           channelEstimationAlgo <enum.modem.ChannelEstimation > - channel
%               estimation algorithm
%           equalizationAlgo < enum.modem.Equalization > - equalization
%               algorithm
%           noiseEstimationAlgo < enum.modem.NoiseEstimation > - noise
%               estimation algorithm
% 
%   Public Methods:
%       demodulate
%           This method extracts the complex symbols from a received
%           time-domain signal, performing equalization, synchronization
%           (optional) and channel estimation, using the demodulation
%           scheme from 'demodulator'.
%       Syntax: [ demodSymbols,
%                 noiseVariance ] = demodulate( rxSignal, impulseResponse, 
%                                               samplingInstants )
%       Inputs:
%           rxSignal < Nsamp x Nrx complex > - is the baseband received
%               signal, with NRx the number of receive antennas and Nsamp
%               the number of time samples.
%           impulseResponse < Ncs x  L+1 complex x NRx x NTx > is the known
%               channel impulse response, to be used in case ideal channel
%               estimation is considered. Ncs is the number of channel
%               samples (different from Nsamp), NRx the number of receive
%               antennas, NTx the number of transmit antennas and L the
%               channel delay in time samples.
%           samplingInstants < 1 x Ncs double > (s) is a vector containing
%               the instants at which the channel impulse responses where
%               obtained.
%       Outputs:
%           demodSymbols < Nsubc x Nsymb x Nrx complex > -  received
%               symbols, where Nsubc is the number of subcarriers and Nsymb
%               the number of symbols in the frame.
%           noiseVariance < Nsubc x Nsymb x Nrx double > noise variance at
%               each subcarrier
%
%       setThermalNoise
%           Associates the thermal noise with the inner receiver. 
%       Syntax: setThermalNoise( thermalNoise ) 
%    
%       Inputs:
%           thermalNoise < channel.Noise > noise object associated to this
%           receiver.
%
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 17 Mar 2015 (ANB) - created (no multipath)
%       v2.0 25 Jun 2015 (ANB) - added noise calculation
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    
properties ( GetAccess = 'public', SetAccess = 'protected' )
    demodulator;
    channelEstimationAlgo;
    equalizationAlgo;
    noiseEstimationAlgo;
end
   
properties ( Access = protected )
    thermalNoise;
end
    
methods ( Access = 'public' )

    %%
    % constructor
    function this = InnerReceiver( demodulator, channelEstimationAlgo, ...
                                   equalizationAlgo, noiseEstimationAlgo )
        this.demodulator = demodulator;
        this.channelEstimationAlgo = channelEstimationAlgo;
        this.equalizationAlgo = equalizationAlgo;
        this.noiseEstimationAlgo = noiseEstimationAlgo;
    end
    
    % end constructor


    %%
    [ demodSymbols, ...
      noiseVariance ] = demodulate( this, rxSignal, impulseResponse, ...
                                    samplingInstants )

    setThermalNoise( this, noise )
end

methods ( Access = 'protected' )
    %%
    channel = getChannelInFrequency ( this, impulseResponse, samplingTimes, ...
                                      receivedSignal, referenceSignal )
    [ signalOut, equalizerCoefficients ] = equalize ( this, signalIn, channel, ...
                                                      noiseVariance )
    
    noiseVariance = this.estimateNoise( noiseVariance, equalizerCoefficients );
    
end

methods( Abstract,  Access = 'protected' )
    noiseVariancePerSymbol = ...
        this.calculateNoiseVariancePerSymbol( coefficients, noiseVariance );
end
end

