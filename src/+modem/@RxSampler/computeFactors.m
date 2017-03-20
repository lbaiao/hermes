function computeFactors( this )
%RXSAMPLER.COMPUTEFACTORS Compute factors and filters for resampling
%   This function calculates the interpolation factor (I) and decimation
%   factor (D) for resampling the transmitted signals, the factors to
%   resample the combined received signals and the oversampling rate.
%   Based on the computed factors, it also calculates the coefficients
%   for the low pass filters needed for resampling.
%   The function updates the respective private properties of the class.
%
%   Author: Renato Barbosa Abreu (RBA)
%   Work Address: INDT Manaus
%   E-mail: renato.abreu@indt.org.br
%   History:
%       v2.0 29 May 2015 (RBA) - compute factors for resampling
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if any( this.txSamplingRate ~= this.rxSamplingRate ) || ...
        any( this.txCenterFreq ~= this.rxCenterFreq )

    % Compute interpolation and decimation factors for resampling
    centerFreqs = [ this.txCenterFreq this.rxCenterFreq ];
    samplingRates = [ this.txSamplingRate this.rxSamplingRate ];

    minFreq = min( centerFreqs - samplingRates/2 );
    maxFreq = max( centerFreqs + samplingRates/2 );

    % Two times, according Nyquist theorem
    upsampleRateMin = 2 * max(maxFreq - this.rxCenterFreq, this.rxCenterFreq - minFreq);

    % Least common multiple of sampling rates and the needed upsample rate
    lengthRates = length( samplingRates );
    if lengthRates > 1
        leastCommonMultipleOfRates = samplingRates(1);
        for rateIndex  = 2 : lengthRates
            leastCommonMultipleOfRates = lcm( leastCommonMultipleOfRates, samplingRates(rateIndex) );
        end
    end

    % Compute interpolation (I) and decimation (D) factors
    % WARNING: Number of samples can increase too much
    minOverCommonRate = upsampleRateMin / leastCommonMultipleOfRates;

    if minOverCommonRate <= 1
        upsampleRate = leastCommonMultipleOfRates;
        this.interpolateFactorTx = upsampleRate ./ this.txSamplingRate;
        this.decimateFactorTx = floor( 1/minOverCommonRate );
    else
        upsampleRate = leastCommonMultipleOfRates * ceil( minOverCommonRate );
        this.interpolateFactorTx = upsampleRate ./ this.txSamplingRate;
        this.decimateFactorTx = 1;
    end

    this.oversampleRate = this.txSamplingRate .* this.interpolateFactorTx ./ this.decimateFactorTx;

    if any( this.oversampleRate < upsampleRateMin )
        error('Error on oversampling rate calculation. It should not be lower than the minimum oversampling rate!');
    end

    if all( this.oversampleRate == this.oversampleRate(1) )
        this.oversampleRate = this.oversampleRate(1);
    else
        error('Error on oversampling rate calculation. All values should be the same!');
    end

    this.interpolateFactorRx = this.decimateFactorTx;
    this.decimateFactorRx = round( this.oversampleRate * this.decimateFactorTx / this.rxSamplingRate );

    % Compute coefficients for resampling filters with default parameters
    % (the same parameters as default call of Matlab resample function).
    % Modify this parameters for performance or use other filter design
    % method may be considered in future.
    kaiserBeta = 5;
    multiplier = 10;
    filterLenghtLimit = 1000000;

    % filters for transmitted signals:
    numberOfTxFilters = length( this.interpolateFactorTx );
    interpolateFactorTxReduced = zeros( 1, numberOfTxFilters );

    for filterIndex = 1 : numberOfTxFilters
        % reduce the terms
        [interpolateFactorTxReduced(filterIndex), decimateFactorTxReduced] = rat( this.interpolateFactorTx(filterIndex) / this.decimateFactorTx, 1e-12 );
    end

    maxFactor = max( interpolateFactorTxReduced, decimateFactorTxReduced );
    cutoffFreq = 1 ./ maxFactor;
    filterLength = 2 * multiplier .* maxFactor + 1;
    if filterLength > filterLenghtLimit
        % This may happen if the configured Tx center frequencies are too
        % far from each other or sampling rates are uncommonly high
        error('The transmitted signals can not be resampled. Filter lenght needed would be very high.');
    end

    this.resampleFiltersTx = cell(1, numberOfTxFilters);
    for filterIndex = 1 : numberOfTxFilters
        this.resampleFiltersTx{filterIndex} = interpolateFactorTxReduced(filterIndex) ...
            * firls( filterLength(filterIndex)-1, [0 cutoffFreq(filterIndex) cutoffFreq(filterIndex) 1], [1 1 0 0] ) ...
            .* kaiser( filterLength(filterIndex), kaiserBeta )' ;
    end

    % filters for received signals:
    [interpolateFactorRxReduced, decimateFactorRxReduced] = rat( this.interpolateFactorRx/this.decimateFactorRx, 1e-12 );
    maxFactor = max( interpolateFactorRxReduced, decimateFactorRxReduced );
    cutoffFreq = 1 / maxFactor;
    filterLength = 2 * multiplier * maxFactor + 1;
    if filterLength > filterLenghtLimit
        error('The transmitted signals can not be resampled. Filter lenght needed would be very high.');
    end

    this.resampleFilterRx = interpolateFactorRxReduced ...
        * firls( filterLength-1, [0 cutoffFreq cutoffFreq 1], [1 1 0 0] ) ...
        .* kaiser( filterLength, kaiserBeta )' ;

end

end

