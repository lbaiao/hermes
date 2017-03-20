function encodedBits = encode( this, packets )
%TURBOCODE.ENCODE Encodes the Tx Packets using a Turbo Encoder.
%   Detailed description can be found in class header.
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 29 Apr 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% Initialization:
numberOfBranches = length( this.encodersArray ); %Number of Constituent Conv. Encoders 

% ---------------- First Constituent Encoder ----------------
% Systematic Bit and Parity Bit for the first Convolutional Encoder on the
% turbo Encoder:
auxEncodedBits = this.encodersArray{ 1 }.encode( packets ); 

% Prepare for the output:
encodedBits = reshape( auxEncodedBits , 2 , [] );

%-------- Parallel Concatenated Constituent Encoders: ------
for encoderCount = 2 : length( this.encodersArray );
    % Interleaving: the sequence of Systematic Bits:
    interleavedBits = packets ( this.interleavers( encoderCount - 1 , : ) );
    
    % Pass all packets through the constituent encoder:
    auxEncodedBits = this.encodersArray{ encoderCount }.encode( interleavedBits );
    auxEncodedBits = reshape( auxEncodedBits , 2 , [] );
    % Select the non-systematic bit for the constituent encoder:
    encodedBits( encoderCount + 1,  : ) = auxEncodedBits( 2 , : );
end

% Append all outputs in the same bit stream:
encodedBits = reshape( encodedBits , 1 , [] );

end



