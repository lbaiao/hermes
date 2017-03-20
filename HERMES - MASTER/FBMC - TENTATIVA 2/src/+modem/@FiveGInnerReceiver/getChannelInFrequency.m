function channel = getChannelInFrequency ( this, receivedSignal, ...
                                           impulseResponse, ...
                                           samplingInstantsIn )                     
%INNERRECEIVER.GETCHANNELINFREQUENCY returns the channel estimation.
%   This is a protected method of FiveGInnerReceiver that returns the channel
%   estimate in the frequency domain, according to the algorithm given in 
%   this.channelEstimationAlgo. The estimate is given for every LTE OFDM 
%   symbol.Currently only ideal channel estimation is supported. In this
%   case the following inputs are considered:
%   
%   Syntax: channel = getChannelInFrequency ( receivedSignal, 
%                                             impulseResponse,
%                                             samplingInstants )
%   Input:        
%           impulseResponse < Ncs x (L+1)x NRx x NTx complex > - impulse
%               response of duration L+1 samples between two antennas. Ncs
%               is the number of channel samples, NRx the number of receive
%               antennas, and NTx the number of transmit antennas.
%           samplingInstants < 1 x Ncs double > - instants at which the
%               channel is sampled. It is assumed the the smallest instant
%               is when the frame starts.
%           If a non-ideal estimation is used, then the following
%           information is used:
%           receivedSignal < NRx x Nsamp complex> - received
%               signal. NRx is the number of receive antennas and Nsamp the
%               complex samples.
%   Output:
%           channel < Nsubc x Nsymb x NRx x NTx complex > - the channel
%           gain at each symbol and subcarrier, with Nsymb the number of
%           symbols in a frame and Nsubc the number of non-zero
%           subcarriers.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 26 Mar 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.                             
                             
switch ( this.channelEstimationAlgo )
    case enum.modem.ChannelEstimation.PERFECT
       
        % obtain channel response at the instants 'samplingInstantsIn'
        fftSize = this.demodulator.fftSize;
        sampledChannel = fft( impulseResponse, fftSize, 2 );
          
        
        % interpolate, get a single sample, during reference signal
        nRxAnts = size( sampledChannel, 3);
        nTxAnts = size( sampledChannel, 4 );
        nInstants = this.frame.numberOfUsefulBlocks;
        
        channelEstimationTime = this.channelEstimationTime + ...
                                samplingInstantsIn(1);
        
        for rxAnt = 1 : nRxAnts
            for txAnt = 1 : nTxAnts
                if size( sampledChannel, 1 ) > 1
                    channel = ...
                        interp1 ( samplingInstantsIn, ...
                        sampledChannel( :, :, rxAnt, txAnt ), ...
                        channelEstimationTime, 'pchip', 'extrap' ).';
                    channel = repmat( channel, 1, nInstants);
                    
                else
                    % ALTERED 05/Jun/2016
                    channel = repmat( sampledChannel, nInstants, 1 ).'; 
                end
            end
        end
        
        channel = channel( this.demodulator.subcarrierFreqMap, :, :, : );
        
    otherwise
        error('invalid channel estimation algorithm')
end

end