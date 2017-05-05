function encodedBitsArray = encode(this, packets)
%FIVEGENCODER.ENCODE Encodes the information in the transport Block
%   Further Description in Class Header
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%   	v2.0 7 Jul 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%Number of Packets in the Encoder's Input:
this.numberOfPackets = size( packets, 1 );
encodedBitsArray =  zeros ( this.numberOfPackets * ...
    ( this.packetSize + this.tailBits + this.paddingBits ) / this.codeRate , 1 );

% Auxiliar Variable used as a Pointer to the output's current position:
index = 1;


for packetCount = 1 : this.numberOfPackets
    % Create all-zeros vector. Size: packet Size + tailbits + padding
    % bits:
    packet = zeros( 1, this.packetSize + this.tailBits + this.paddingBits );
    % Isolate the packet from the cell-array:
    packet( 1 : this.packetSize )  = packets{ packetCount };
    % Encode the packet.
    encodedPacket = this.encoder.encode( packet );
    % Perform the puncture:
    puncturedArray = this.rateMatching.puncturing( encodedPacket );
    % Store the variable in Output Array:
    encodedPacketSize = length( puncturedArray );
    encodedBitsArray ( index : index + encodedPacketSize - 1) = puncturedArray;
    index = index + encodedPacketSize;
    
end


end



