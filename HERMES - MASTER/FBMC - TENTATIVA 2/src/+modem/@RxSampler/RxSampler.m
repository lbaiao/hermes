classdef RxSampler < handle
%RXSAMPLER implements a Rx Sampling Rate Matching to be used by a modem obj
%   Objects of this class are responsible to perform the rate matching
%   between receiver and transmitter/intergering modems. It is also
%   responsible for the center frequency matching of received signals
%
%   Properties:
%       rxSamplingRate < double > - Receiver Sampling Rate (Hz)
%       txSamplingRate < 1 x M double > - Transmitter Sampling Rate
%           (Hz) for each of the M Tx modems.
%       rxCenterFreq < double > - Receiver Center Frequency (Hz)
%       txCenterFreq < 1x M double > - Tx Center Frequency (Hz) for each of
%           the M Tx modems.
%
%   Methods:
%       constructor
%
%           Syntax: this = modem.RxSampler ( rxSamplingRate, rxCenterFreq );
%
%           Inputs:
%               rxSamplingRate < double > - Receiver Sampling Rate (Hz)
%               rxCenterFreq < double > - Receiver Center Frequency (Hz)
%
%       setTxSamplingRate 
%           Set this attribute into the object.
%
%           Syntax: setTxSamplingRate( txSamplingRate, txCenterFreq );
%           
%           Inputs:
%               txSamplingRate < double > - Transmitter Sampling Rate (Hz)
%               txCenterFreq < double > - Transmitter Center Frequency (Hz)
%
%       resample
%           Resamples the signal
%
%           Syntax: signalOut = resample( signalIn )
%           
%           Input:
%               signalIn < 1 x M cell array > is a cell array containing  
%               signals at the channel output for each transmitting modem.
%               The signal in each cell is an Nsamp(m) x NRx matrix of
%               Nsamp(m) time samples at the NRx receive antennas, with m 
%               the modem index. The center frequency and the sampling rate 
%               are specified in txCenterFreq and txSamplingRate.
%           
%           Output:
%               signalOut< Nsamp x NRx > contains the sum of all the signal
%               in signalOut, resampled at the receiver sampling rate and 
%               center frequency.
%
%   Author: Rafhael Amorim (RA), Andre Noll Barreto (ANB),
%           Renato Barbosa Abreu (RBA)
%   Work Address: INDT Brasília/Manaus
%   E-mail: rafhael.amorim@indt.org.br, andre.noll@indt.org,
%           renato.abreu@indt.org.br
%   History:
%       v1.0 23 Mar 2015 (RA,ANB) - created
%       v2.0 29 May 2015 (RBA) - resampling for different sample rates
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    properties ( GetAccess = 'public', SetAccess = 'protected' )

        rxSamplingRate
        rxCenterFreq
        txSamplingRate
        txCenterFreq

    end

    properties ( Access = 'private' )

        oversampleRate
        interpolateFactorTx
        decimateFactorTx
        interpolateFactorRx
        decimateFactorRx
        resampleFiltersTx
        resampleFilterRx

    end

    methods ( Access = 'public' )

        %% Class constructor
        function this = RxSampler( rxSamplingRate, rxCenterFreq )
            this.rxSamplingRate = rxSamplingRate;
            this.txSamplingRate = [];
            this.rxCenterFreq = rxCenterFreq;
            this.txCenterFreq = [];
        end

        %% Public methods
        setTxSamplingRate (this, txSamplingRate, txCenterFreq )
        signalOut = resample( this, signalIn )
    end

    methods ( Access = 'private' )
        computeFactors( this )
    end

end
