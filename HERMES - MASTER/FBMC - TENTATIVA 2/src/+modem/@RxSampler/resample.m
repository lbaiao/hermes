function signalOut = resample( this, signalIn )
%RXSAMPLER.RESAMPLE resamples tx signal to the rx sampling 
%   Detailed explanation in class header
%
%   Author: André Noll Barreto (ANB), Renato Barbosa Abreu (RBA)
%   Work Address: INDT Brasília/Manaus
%   E-mail: andre.noll@indt.org, renato.abreu@indt.org.br
%   History:
%       v1.0 06 Abr 2015 (ANB) - dummy created
%       v2.0 29 May 2015 (RBA) - resampling for different sample rates
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


if ~iscell( signalIn )
    error( 'signalIn must be a cell array')
end

numberOfTxSignals = length( signalIn );

% number of samples is the maximum of all input signals
numberOfSamples = 0;
for signalIndex = 1: numberOfTxSignals
    if size( signalIn{signalIndex}, 1 ) > numberOfSamples
        numberOfSamples = size( signalIn{signalIndex}, 1 );
    end
end

numberOfRxAntennas = size( signalIn{ 1 }, 2 );

if all( this.txSamplingRate == this.rxSamplingRate ) && ...
   all( this.txCenterFreq == this.rxCenterFreq )

    % add up all received signals
    signalOut = [ signalIn{1}; zeros( numberOfSamples - size( signalIn{ 1 }, 1 ), ...
                               numberOfRxAntennas) ] ;
    for signalIndex = 2: numberOfTxSignals
        signalOut = signalOut + ...
            [ signalIn{ signalIndex }; zeros( numberOfSamples - size( signalIn{ signalIndex }, 1 ), ...
                numberOfRxAntennas) ] ;
    end

else

    % Resample to higher sample rate
    upsampledTx = cell( 1, numberOfTxSignals );
    lengthUpsampledTx = zeros( 1, numberOfTxSignals );

    for signalIndex = 1 : numberOfTxSignals
        for rxIndex = 1 : numberOfRxAntennas
            upsampledTx{signalIndex}( :, rxIndex ) = resample( signalIn{signalIndex}( :, rxIndex ), this.interpolateFactorTx( signalIndex ), this.decimateFactorTx, this.resampleFiltersTx{signalIndex} );
        end
        lengthUpsampledTx(signalIndex) = length( upsampledTx{signalIndex} );
    end

    % Truncate to smaller signal size considering that it respects the
    % expected number of samples of the receiver
    for signalIndex = 1 : numberOfTxSignals
        upsampledTx{signalIndex} = upsampledTx{signalIndex}( 1 : min(lengthUpsampledTx), : );
    end

    % Shift to respective center frequencies
    freqShift = this.txCenterFreq - this.rxCenterFreq;
    radFreqShift = ( 2*pi*freqShift ) / this.oversampleRate;

    for signalIndex = 1 : numberOfTxSignals

        if ( radFreqShift( signalIndex ) ~= 0 )

            samplesIndex = ( 1 : length( upsampledTx{signalIndex} ) ).';
            expShift = exp( 1i*radFreqShift(signalIndex)*samplesIndex );

            for rxIndex = 1 : numberOfRxAntennas
                upsampledTx{signalIndex}( :, rxIndex ) = expShift .* upsampledTx{signalIndex}( :, rxIndex );
            end

        end

    end

    % Sum all TX signals to form the aggregate RX signal
    summedRx = zeros( length( upsampledTx{1} ), numberOfRxAntennas );

    for rxIndex = 1 : numberOfRxAntennas

        summedRx( :, rxIndex ) = upsampledTx{1}( :, rxIndex );

        for signalIndex = 2 : numberOfTxSignals
            summedRx( :, rxIndex ) = summedRx( :, rxIndex ) + upsampledTx{signalIndex}( :, rxIndex );
        end

    end

    % Resample to receiver frequency
    lrxSamples = ceil( length(summedRx) * this.interpolateFactorRx / this.decimateFactorRx );
    signalOut = zeros( lrxSamples, numberOfRxAntennas );

    for rxIndex = 1 : numberOfRxAntennas
        signalOut( :, rxIndex ) = resample( summedRx( :, rxIndex ), this.interpolateFactorRx, this.decimateFactorRx, this.resampleFilterRx );
    end

end

end
