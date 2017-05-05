function [ modulatedSignal ] = map( this, bits2Transmit )
%MAP create symbols to be transmitted.
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

adicionalBits = rem( numberOfBits, wordSize );

if (adicionalBits ~= 0 )

    bits2Transmit(numberOfBits + 1 : ...
        numberOfBits +( wordSize - adicionalBits ) ) = 0;

    numberOfBits = length( bits2Transmit );
    numberOfSymbols = numberOfBits / wordSize;

end

% organize bits in symbols
symbols = reshape( bits2Transmit, wordSize, numberOfSymbols ).';

switch this.modulationOrder

    case 2
        Kmod = 1/sqrt(2);
        modulatedSignal =  Kmod * ( 1 - 2 * ...
            symbols( :, 1) + 1i * ( 1 - 2 * symbols( :, 1 ) ) );

    case 4
        Kmod = 1/sqrt(2);
        modulatedSignal =  Kmod * ( ( 1 - 2 * ...
            symbols( :, 1 ) ) + 1i * ( 1 - 2 * symbols( :, 2 ) ) );


    case 16
        Kmod = 1/sqrt(10);
        modulatedSignal = Kmod * ( ( 1 - 2 * ...
            symbols( :, 1 ) ) .* ( 1 + 2 * symbols( :, 3 ) ) + 1i * ...
            ( 1 - 2 * symbols( :, 2 ) ) .* ( 1 + 2 * symbols( :, 4 ) ) );

    case 64
        Kmod = 1/sqrt(42);
        modulatedSignal = Kmod * ( ( 2 * ...
            symbols( :, 1 ) -1 ) .* ( (1 -2 * symbols( :, 3 ) ) .* ...
            ( 1 + 2 * symbols( :, 5 ) ) -4 ) + 1i * ( ( 2 * ...
            symbols( :, 2 ) -1 ) .* ( ( 1 -2 * symbols(:,4) ) .* ...
            ( 1 + 2 * symbols( :, 6 ) ) -4 ) ) );
    case 256

        Kmod = 1/sqrt(170);
        modulatedSignal = Kmod * ( ( ( ( ( 1 - 2 * symbols( :, 5 ) ).* ...
            ( 1 + 2 * symbols( :, 7 ) ) - 4 ) .* ( -1 + 2 * symbols( :, 3) ) ) - 8 ) ...
            .* ( -1 + 2 * symbols(:,1) ) + 1i * ( ( ( ( 1 -2 * symbols(:,6) ) ...
            .* ( 1 + 2 * symbols(:,8) ) - 4 ) .* ( -1 + 2 * symbols(:,4) ) ) - 8 ) ...
            .* ( -1 + 2 * symbols(:,2) ) );

    otherwise

        error('Choose a valid modulation (BPSK, QPSK, 16-QAM, 64-QAM or 256-QAM)');
end


end
