function noiseVariancePerSymbol = ...
    calculateNoiseVariancePerSymbol ( this, coefficients, noiseVariance )                     
%LTEINNERRECEIVER.CALCULATENOISEVARIANCEPERSYMBOL gets noise variance per
%   resource element
%
%  This method returns the noise variance at each resource element for an
%  LTE OFDM receiver.
%
%   Syntax: noiseVariancePerSymbol = 
%       calculateNoiseVariancePerSymbol( coefficients, noiseVariance )
%
%   Input:
%       coefficients< BlockSize x NBl complex > - matrix containing the
%           equalizer coefficients for each sample, considering a block
%           modulation with NBl blocks of BlockSize elements.
%       noiseVariance< double > - variance of the noise samples at the receiver
%           input

%   Output:
%       noiseVariancePerSymbol < NData x NBl double > - noise variance for each
%           modulation symbol of a block modulation with NData symbols per
%           block.
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

noiseVariancePerSymbol = fftSize * noiseVariance .* ( real(coefficients).^2 + ...
                                                      imag(coefficients).^2 );

end


    
