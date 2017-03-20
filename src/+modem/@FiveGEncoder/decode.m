function decodedBits = decode(this, llr )
%FIVEGENCODER.DECODE Decodes the information in the transport Block
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

% Initialization of pointer Variables:
rxArrayIndex = 1;
decodedPacketIndex = 1;
% Output Space Reservation:
decodedBits = zeros( this.numberOfPackets * this.packetSize , 1);

for packetCount = 1 : this.numberOfPackets
    % Isolate the Packet to be decoded:
    rxPacketSize = ( this.packetSize + this.tailBits + this.paddingBits ) / this.codeRate;
    rxPacket = llr( rxArrayIndex : rxArrayIndex + rxPacketSize - 1 );
    rxArrayIndex = rxArrayIndex + rxPacketSize;
    
    %Depuncture:
    depuncturedArray = this.rateMatching.depuncturing ( rxPacket );
    
    % Decode:
    decodedPacket = this.encoder.decode( depuncturedArray );
    
    %Store the decoded packet in the decoded Array:
    decodedBits ( decodedPacketIndex : decodedPacketIndex + this.packetSize - 1 ) = ...
                                 decodedPacket( 1 : this.packetSize );
    decodedPacketIndex = decodedPacketIndex + this.packetSize;
end

end



