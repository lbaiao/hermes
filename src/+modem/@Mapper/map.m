function [ modulatedSignal ] = map( this, bits2Transmit )
%MAPPER.MAP create symbols to be transmitted.
% Detailed description can be found in class header.
%
%   Author: Lilian Freitas (LCF), Andre Noll Barreto (ANB)
%   Work Address: INDT Manaus/Brasilia
%   E-mail: <lilian.freitas>@indt.org.br, andre.noll@indt.org
%   History:
%       v1.0 10 Apr 2015 - (LCF, ANB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


wordSize =  log2( this.modulationOrder );

numberOfBits = length( bits2Transmit );

numberOfSymbols = ( numberOfBits / wordSize);

% In case of number of bits < wordSize, zeros bits are included

additionalBits = rem( numberOfBits, wordSize );

if (additionalBits ~= 0 )

    bits2Transmit(numberOfBits + 1 : ...
                  numberOfBits +( wordSize - additionalBits ) ) = 0;

    numberOfBits = length( bits2Transmit );
    numberOfSymbols = numberOfBits / wordSize;

end

% organize bits in symbols
symbols = reshape( bits2Transmit, wordSize, numberOfSymbols ).'; 

indexBitTable = bin2dec( num2str( symbols ) );

modulatedSignal = this.symbolAlphabet{ wordSize }( indexBitTable + 1 );

end
