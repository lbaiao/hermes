function encodedBitsArray = encode(this, transportBlocks )
%LTEENCODER.ENCODE Encodes the information in the transport Block
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

% Current Subframe:
subframe = this.frameAssembler.subframeCount;
%Number of Packets in the Encoder's Input:
numberOfPackets = size( transportBlocks, 1 );
encodedBitsArray =  zeros ( 1, sum( sum( this.txBlockSize( 1:numberOfPackets , : , subframe) ) ) );

% Auxiliar Variable used as a Pointer to the output's current position:
index = 1;

if numberOfPackets > 0;
    % If there are packets to be transmitted:
    
    for packetCount = 1 : numberOfPackets
        % Isolate the Packet:
        packet  = transportBlocks{ packetCount };
        
        % Attach Dummy CRC bits to this packet:
        checkedPacket = [ packet; this.rnd.randi( [0, 1] , this.transportBlockCrcSize, 1 ) ];
        
        % Performs the Code Block Segmentation:
        segmentedBlocks = this.codeBlockSegmentation( checkedPacket );
        
        for blockCount = 1: this.numberOfCodeBlocks
            % Load Expected Code Block Size:
            blockSize = this.codeBlockSize ( blockCount );
            % Check if is necessary to update Turbo Code internal Interleaver
            % sequence to match packet size:
            if ( length( this.turboEncoder.interleavers ) ~= blockSize )
             this.turboEncoder.setInterleaver( this.interleavers{ blockCount }, ...
                                               this.deinterleavers{ blockCount} );
            end
            
            codeBlockAux = segmentedBlocks { blockCount };
            
            % Store the Coded Bits in a Temporary Variable:
            encodedBlock = this.turboEncoder.encode( codeBlockAux );
            encodedBlockSize = this.txBlockSize( packetCount, blockCount, subframe ) ;
            %% Performs the Rate Matching:
            % Buffer Size:
            bufferSize = length( this.bitSelectionIndex{blockCount} );
            % Create the indexes for each encoded bit:
            auxiliaryBitIndexes = mod( 0:encodedBlockSize-1, bufferSize  ) + 1;
            % Performs the Bit Selection:
            bitSelection = this.bitSelectionIndex{blockCount} ( auxiliaryBitIndexes ); 
            % Append the selected bits to the encoded Array:
            encodedBitsArray(  index  : index + encodedBlockSize - 1 ) = ...
                                encodedBlock( bitSelection );
            index = index + encodedBlockSize;

        end
                 
    end
    this.codeRate = sum( this.packetSize ) * numberOfPackets / length( encodedBitsArray );
    encodedBitsArray = encodedBitsArray.';
else
    encodedBitsArray = [];
end

end



