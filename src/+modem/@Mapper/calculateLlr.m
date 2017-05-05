function [receivedLlr] = calculateLlr( this, receivedSymbols, noiseVariance )
%MAPPER.CALCULATELLR returns Log Likelihood Ratio soft bits.
% Detailed description can be found in class header.
%
%   Author: Lilian Freitas (LCF), Andre Noll Barreto (ANB)
%   Work Address: INDT Manaus/Brasilia
%   E-mail: <lilian.freitas>@indt.org.br, andre.noll@indt.org
%   History:
%       v1.0 10 Apr 2015 (LCF, ANB) - created
%       v2.0 21 May 2015 (LCF, ANB) - include different LLR methods
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

bitsPerSymbol = log2( this.modulationOrder );

if ~exist('noiseVariance','var')

    % estimate noise variance
    noiseVariance = max( mean( real(receivedSymbols).^2 + ...
                               imag(receivedSymbols).^2 ) - ...
                         this.symbolEnergy( bitsPerSymbol ), 0 );

end

% maximum LLR without overflow
switch this.llrMethod
    case enum.modem.LlrMethod.IDEAL_AWGN
        maxLLR = log( realmax );
    case enum.modem.LlrMethod.NEAREST_AWGN
        maxLLR = realmax / 10;
end

symbolAlphabet = transpose(this.symbolAlphabet{bitsPerSymbol});

zerosIndex = this.zerosIndex{bitsPerSymbol};

onesIndex = this.onesIndex{bitsPerSymbol};

receivedSymbols = transpose(receivedSymbols);

bitMatrix = zeros( bitsPerSymbol, length( receivedSymbols ) );

% number of constellation points for each bit
numberOfPointsPerBitValue = size( onesIndex, 2 );

for cntBit = 1: 1: bitsPerSymbol
    
    for cntPoint = 1: 1: numberOfPointsPerBitValue
        bitOne = symbolAlphabet( onesIndex( cntBit, cntPoint ) );
        pointDiff = receivedSymbols - bitOne;
        normTo1( :, cntPoint ) = real( pointDiff ).^2 + imag( pointDiff ).^2;

        bitZero = symbolAlphabet( zerosIndex( cntBit, cntPoint ) );
        pointDiff = receivedSymbols - bitZero;
        normTo0( :, cntPoint ) = real( pointDiff ).^2 + imag( pointDiff ).^2;
    end
    
    switch this.llrMethod
        case enum.modem.LlrMethod.IDEAL_AWGN
            % Log likelihood of bit = 1
            LL1 = log( sum( exp(- bsxfun(@rdivide, normTo1, noiseVariance ) ), 2 ) );
            
            % Log likelihood of bit = 0
            LL0 = log( sum( exp(- bsxfun(@rdivide, normTo0, noiseVariance ) ), 2 ) );
            
        case enum.modem.LlrMethod.NEAREST_AWGN
            
            LL1 = max( - bsxfun(@rdivide, normTo1, noiseVariance ), [], 2 );
            LL0 = max( - bsxfun(@rdivide, normTo0, noiseVariance ), [], 2 );
            
        otherwise
            error('LLR calculation method not supported')
    end
    
    LLR = LL1 - LL0;
    
    if any( isnan( LLR ) )
        nanIndex = isnan( LLR );
        minDist1 = min( normTo1, [], 2);
        minDist0 = min( normTo0, [], 2);
        % overflow
        LLR( nanIndex ) = ( 2* ( minDist1 ( nanIndex ) < ...
                                 minDist0 ( nanIndex ) ) - 1 ) * maxLLR;
    end
    
    bitMatrix( cntBit, : ) = LLR;
end


receivedLlr = reshape( bitMatrix, bitsPerSymbol * ...
                                  length( receivedSymbols ), 1 );
