function decodedBits = decode(this, llr )
%LTEENCODER.DECODE Decodes the information in the transport Block
%   Further Description in Class Header
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%   	v2.0 6 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if ~isempty( llr )
    % Check the current Subframe:
       subframe = this.frameAssembler.subframeCount -  1;
    if subframe == 0
        subframe = this.frameAssembler.numberOfSubframes;
    end
    
    % Set Number Of Packets
    numberOfPackets = size( this.txBlockSize, 1 );
    % Total Number of Information Received Bits:
    bitsPerPacket = ( sum( this.codeBlockSize ) - this.segmentedBlockCrcSize * size( this.codeBlockSize, 2 ) );
    totalBits = ( bitsPerPacket - this.transportBlockCrcSize - this.fillerBits ) * numberOfPackets;
    % Variable for store the decoded packets:
    decodedBits = zeros( totalBits , 1 ) ;
    
    % Pointers Initialization:
    indexEncodedPacket = 1;
    indexDecodedPacket = 1;
    
    for packetCount = 1: numberOfPackets
        indexDecodedBlock = 1;
        decodedPacket  = zeros(  1, sum( this.codeBlockSize ) );
        for blockCount = 1: this.numberOfCodeBlocks
            blockSize = this.txBlockSize ( packetCount, blockCount, subframe );
            % Isolate the CodeBlock:
            llrPacket = llr( indexEncodedPacket: indexEncodedPacket + blockSize - 1);
            % Update auxiliar index
            indexEncodedPacket = indexEncodedPacket + blockSize;
            % Rearrange the Received Packet re-introducing the bits removed
            % in rate matching:
            receivedPacket = zeros( this.codeBlockSize( blockCount ) / this.turboEncoder.codeRate , 1 );
            
            bufferSize = length( this.bitSelectionIndex{blockCount} );
            
            tempIndex = 1;
            % Use a loop for the cases where some encoded bits are
            % transmitted more than once. 
            for count = 1 : ceil ( blockSize / bufferSize )
                bitIndexes = tempIndex : min( tempIndex + bufferSize - 1, ...
                                              blockSize );
                tempIndex = tempIndex + bufferSize;
                auxiliaryBitIndexes = mod( bitIndexes - 1, bufferSize  ) + 1;
                rxBitsIndexes = this.bitSelectionIndex{ blockCount } ( auxiliaryBitIndexes );
                receivedPacket( rxBitsIndexes ) = receivedPacket( rxBitsIndexes ) + ...
                                                  llrPacket( bitIndexes );
            end
            % Check if is necessary to update Turbo Code internal Interleaver
            % sequence to match packet size:
            if ( length( this.turboEncoder.interleavers ) ~= blockSize )
                this.turboEncoder.setInterleaver( this.interleavers{ blockCount }, ...
                                                  this.deinterleavers{ blockCount } );
            end
            
            % Decode the Packets
            decodedBitsAux  = this.turboEncoder.decode( receivedPacket );
            
            % Detach the CRC
            decodedBitsAux = decodedBitsAux( 1 : length( decodedBitsAux ) - ...
                this.segmentedBlockCrcSize );
            
            % Remove filler bits when the rule applies:
            if blockCount == 1
                decodedBitsAux = decodedBitsAux( 1 + this.fillerBits : end );
            end
            % Update Decoded Packet:
            decodedBlockSize = length( decodedBitsAux );
            decodedPacket ( indexDecodedBlock : indexDecodedBlock + decodedBlockSize - 1) = decodedBitsAux ;
            indexDecodedBlock = indexDecodedBlock + decodedBlockSize;
            
        end
        % Remove CRC Bits attached to this packet.
        decodedPacket = decodedPacket(  1: length( decodedPacket ) - this.transportBlockCrcSize );
        % Update the output:
        packetSize = length ( decodedPacket );
        decodedBits( indexDecodedPacket : indexDecodedPacket + packetSize - 1 ) = decodedPacket;
        % Update Index
        indexDecodedPacket = indexDecodedPacket + packetSize;
    end
end

end



