function codeBlocks = codeBlockSegmentation(this, packet )
%LTEENCODER.CODEBLOCKSEGMENTATION Performs Transport Block Segmentation.
%   Syntax: codeBlocks = codeBlockSegmentation( packet )
%       Inputs:
%           packet < 1 x K bits >  the packet to be
%               encoded with K bits
%       Output:
%           codeBlocks <  1 x C cell-array > The Segmented code Blocks.
%               Where "C" is the number of Code Blocks. Code Block Sizes
%               follow the values defined in the class properties. 
%               * CRC Dummy bits are appended to each code block and Filler
%               Bits are appended to the first block whenever its
%               applicable ( see 3GPP TS 36.212 V12.4.0. ).
%               
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%   	v2.0 18 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% Output Initialization
codeBlocks = cell( 1, this.numberOfCodeBlocks );
% Auxiliary variable used as a pointer to the current position in the
% packet:
packetIndex = 1;

for codeBlockCount = 1 : this.numberOfCodeBlocks
    % Expected Size for this code Block:
    blockSize = this.codeBlockSize( codeBlockCount );
    
    % The first Code Block is appended in the beggining with filler bits when
    % the rule applies ( check 3GPP TS 36.212 V12.4.0. ):
    if codeBlockCount == 1
        % Check the number of TB Bits segmented in this block:
        % Filler Bitts and CRC bits will be added to this code block
        bitsCount = blockSize - this.fillerBits - this.segmentedBlockCrcSize;
        % Auxiliary Variable:
        codeBlockAux = zeros( 1, blockSize ); % Initialization
        % Filler Bits:
        codeBlockAux( 1 : this.fillerBits ) = zeros( 1 , this.fillerBits );
        % Packet bits:
        codeBlockAux( this.fillerBits + 1 : this.fillerBits + bitsCount ) = ...
            packet( packetIndex : packetIndex + bitsCount - 1 );
        % CRC Dummy bits:
        codeBlockAux( this.fillerBits + bitsCount + 1 : end ) = this.rnd.randi( [0,1], ...
            1, this.segmentedBlockCrcSize );
        
        % Code Block Assingment:
        codeBlocks{ codeBlockCount } = codeBlockAux;
        % Index Update:
        packetIndex = packetIndex + bitsCount;
    else       
        % Check the number of TB Bits segmented in this block:
        % CRC bits will be added to this code block
        bitsCount = blockSize - this.segmentedBlockCrcSize;
        % Auxiliary Variable:
        codeBlockAux = zeros( 1, blockSize );
        % TB Bits:
        codeBlockAux(  1 : bitsCount ) =  ...
            packet( packetIndex : packetIndex + bitsCount - 1 );
        % CRC Dummy Bits:
        codeBlockAux( bitsCount + 1: end ) =  ...
                     this.rnd.randi( [0,1] , 1, this.segmentedBlockCrcSize );
        
        codeBlocks{ codeBlockCount } = codeBlockAux;
        % Index Update:
        packetIndex = packetIndex + bitsCount;
    end
end


end



