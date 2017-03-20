classdef Channel < handle
%CHANNEL class implements a multipath fading wireless channel
%   This class defines a noiseless wireless channel with multiple inputs
%   and multiple outputs.
%   This is a superclass, that implements a time-invariant unit gain
%   channel only. Multipath channels are implemented in subclasses.
%
%   Read-Only Public Properties:
%       samplingRate - as described in constructor
%       timeStamp - <1 x 1 double> (s) time of last channel update. It is
%           initialized as 0.
%       nTxAntennas- <1x1 int> number of transmit antennas
%       nRxAntennas- <1x1 int> number of receive antennas
%       impulseResponseUpdatePeriod - as described in constructor
%
%   Constructor
%       Syntax: this = channel.Channel( txAnts, rxAnts, random,
%                       samplingRate, impulseResponseUpdatePeriod )
%       Inputs:
%           txAnts - <1 x N networkEntity.Antenna>  transmitting
%               antennas
%           rxAnts - <1 x N networkEntity.Antenna>  receiving antennas
%           random - < 1 x 1 RandomStream > - random number generator
%           samplingRate - <1 x 1 double> (Hz), sampling rate of the
%               input signal
%           impulseResponseUpdatePeriod - < 1 x 1 double > (s) periodicity 
%           of channel impulse response within a frame. If left empty, then
%           only the impulse response at the beginning of the frame is
%           returned each time.
%           This constructor instances a multipath channel with
%           information being transmitted from antennas 'txAnts' to
%           receiving antennas 'rxAnts'.
%
%   Public Methods
%       propagate
%           returns the channel response on a given input signal, 
%           starting at a given time.
%       Syntax: [ out, ...
%                 impulseResponse, ...
%                 channelSamplingInstants ] = propagate( in, t0 )
%       Inputs:
%           in - < M x Ntx complex> transmitted signal, a block of M
%               samples transmitted by Ntx transmit antennas. Ntx must 
%               be equal to Channel.nTxAntennas.
%           t0 - <double> (s) timestamp of the first sample in block 
%       Outputs:
%           out - < (M + L) x Nrx complex> received signal, a block of M+L
%               samples ( L>=0 is the maximum delay spread in samples )
%               received at Nrx receive antennas. Nrx is equal to
%               Channel.nRxAntennas.
%           impulseResponse - < Nt x (L+1) x NRx x NTx complex> is the
%               channel impulse response in the time domain for every pair
%               of transmit and receive antenna. For time-varying channels
%               the impulse responses at the times given in vector t are
%               returned. Nt is the size of t.
%           channelSamplingInstants < 1 x Nt double > is a vector
%               containing the instants at which the channel impulse
%               response is given.
%
%       update
%           updates the channel and returns the impulse responses at
%           given sampling instants
%       Syntax1: impulseResponse = Channel.update( t0, nSamples, 
%                                                  samplingRate )
%       Input:
%           t0 < double > - time of first sample
%           nSamples < uint > - number of samples
%           samplingRate< double > (optional) - sampling rate of channel
%               impulse response. If left empty, then the signal sampling
%               rate 'this.samplingRate' is considered.
%       Output:
%           impulseResponse - < nSamples x (L+1) x NRx x NTx complex> is 
%               the channel impulse response in the time domain for every
%               pair of 'Ntx' transmit and 'NRx' receive antennas. For
%               time-varying channels the impulse responses at nSamples
%               time samples is given. The impulse response has length L+1,
%               with L the maximum delay spread in signal samples, given in
%               this.maxDelay_samples.
%
%       Syntax2: impulseResponse = Channel.update( time )
%       Input:
%           time < nSamples x 1 double > - vector containing the sampling
%               instants of the channel impulse response
%       Output:
%           impulseResponse - same as in Syntax 1, but sampling instants
%           are given explicitly.
%
%       Channel.flip() changes transmitting direction of channel, i.e.,
%           transmitting nodes become receiving nodes and vice-versa.
%       Syntax: Channel.flip()
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 20 Feb 2015 (ANB) - created (no multipath)
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    
properties ( GetAccess = 'public', SetAccess = 'protected' )
    samplingRate;
    numberOfTxAntennas;
    numberOfRxAntennas;
    timeStamp;
    impulseResponseUpdatePeriod;
end
    
properties ( Access = 'protected' )
    random; % random number generator (RandStream)
    txAntennas; % transmitting antennas
    rxAntennas; % receiving antennas

end
    
methods ( Access = 'public' )

    %%
    % constructor
    function this = Channel( txAnts, ...
                             rxAnts, ...
                             randomGen, ...
                             samplingRate, impulseResponseUpdate )
        
        this.samplingRate = samplingRate;
 
        this.numberOfTxAntennas = length ( txAnts );
        this.numberOfRxAntennas = length ( rxAnts ); 
        
        this.timeStamp = 0;
        
        this.random = randomGen;       
                         
        this.txAntennas = txAnts;
        this.rxAntennas = rxAnts;
        
        if ~exist( 'impulseResponseUpdate', 'var' ) || ...
           isempty( impulseResponseUpdate )
            this.impulseResponseUpdatePeriod = inf;
        else
            this.impulseResponseUpdatePeriod = impulseResponseUpdate;
        end
    end
    
    % end constructor
    
    %%
    [ out, ...
      impulseResponse, ...
      channelSamplingInstants ] = propagate ( this, in, t0 );
    
    impulseResponse = update (this, t);
    
    flip (this);
    
end

end

