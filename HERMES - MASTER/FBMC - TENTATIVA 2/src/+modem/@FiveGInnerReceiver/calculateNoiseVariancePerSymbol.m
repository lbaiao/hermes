function noiseVariancePerSymbol = ...
    calculateNoiseVariancePerSymbol ( this, coefficients, noiseVariance )                     
%FIVEGINNERRECEIVER.CALCULATENOISEVARIANCEPERSYMBOL gets noise variance per
%  resource element
%
%  This method returns the noise variance at each resource element for
%  a 5G block receiver. The calculation of the noise variance depends on
%  the modulation method and on the equalization algorithm.
%
%   Syntax: noiseVariancePerSymbol = 
%       calculateNoiseVariancePerSymbol( coefficients, noiseVariance )
%
%   Input:
%       coefficients< BlockSize x NBl complex > - matrix containing the
%           equalizer coefficients for each sample, considering a block
%           modulation with NBl blocks of BlockSize elements
%       noiseVariance< double > - variance of the noise samples at the
%           receiver input

%   Output:
%       noiseVariancePerSymbol < NData x NBl double > - noise variance for
%           each modulation symbol of a block modulation with NData symbols
%           per block.
% 
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 18 Nov 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.                             

fftSize = this.demodulator.fftSize;

switch this.demodulator.waveform
    case enum.modem.fiveG.Waveform.OFDM
        
        noiseVariancePerSymbol = fftSize * noiseVariance .* ...
            ( real(coefficients).^2 + imag(coefficients).^2 );        
        
    case enum.modem.fiveG.Waveform.ZT_DS_OFDM
        
        usedSubcarriers = length( this.demodulator.subcarrierFreqMap );
        usefulDataLength =  usedSubcarriers - this.demodulator.samplesInPrefix - ...
                                              this.demodulator.samplesInTail;
        noiseVariancePerBlock = noiseVariance * fftSize / usedSubcarriers .* ...
            sum ( ( real(coefficients).^2 + imag(coefficients).^2 ) );
        noiseVariancePerSymbol = repmat( noiseVariancePerBlock, ...
                                         usefulDataLength, 1 );
    case enum.modem.fiveG.Waveform.FBMC
        
        usedSubcarriers = length( this.demodulator.subcarrierFreqMap );
        usefulDataLength =  usedSubcarriers/2;
        noiseVariancePerBlock = noiseVariance * fftSize / usedSubcarriers .* ...
            sum ( ( real(coefficients).^2 + imag(coefficients).^2 ) );
        noiseVariancePerSymbol = repmat( noiseVariancePerBlock, ...
                                         usefulDataLength, 1 );
end



end


    
