function setBitSelectionVector( this )
%LTEENCODER.SETBITSELECTIONVECTOR Sets the Pruning Pattern for Rate Matching.
%  This function sets the bit selection vectors containing the permutation
%  and pruning patterns according to 3GPP TS 36.212-v12.3.0. This pattern
%  will be used by rateMatching method of LteEncoder.
%   
%   Syntax: setBitSelectionVector(  )
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 19 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


for blockCount = 1 : this.numberOfCodeBlocks
    % Check the expected number of bits at Turbo Encoder's Output:
    numberOfBlockCodedBits = this.codeBlockSize(  blockCount ) / this.turboEncoder.codeRate;
    
   
    if blockCount == 1
        % If so, consider the filler bits:
        numberOfFillerBits = this.fillerBits / this.turboEncoder.codeRate;      
        auxBitPositionVector = zeros( 1, numberOfBlockCodedBits );
        
        % Create a vector with a Index for each bit in the encoded Block:
        auxBitPositionVector( numberOfFillerBits + 1 : end ) = ...
                            1 : ( numberOfBlockCodedBits - numberOfFillerBits);
    else
        % Create a vector with a Index for each bit in the encoded Block:
        auxBitPositionVector = 1 : numberOfBlockCodedBits;
    end
    
    %% Separate the code blocks into Sub-blocks, following 3GPP TS 36.212-v12.3.0
    % Page 16:
    numberOfSubBlocks = 1 / this.turboEncoder.codeRate;
    subBlocks = reshape( auxBitPositionVector, numberOfSubBlocks, [] ); 
    
    %% Rearrange the Subblocks in the Matrix Form:
    subBlocksColumns = 32; % Hard Coded, defined in: 3GPP TS 36.212-v12.3.0 
                           % Page 16.  
    subBlocksRows   = ceil( length( subBlocks ) / subBlocksColumns );
    
    % Load the Permutation Pattern:
    permutationPattern = lookupTables.modem.lte.getEncoderPermutationPattern();
    
    % Interleaved Code Block:
    interleavedCodeBlock = zeros(1,  numel( subBlocks ) );
    for subBlockCount = 1: numberOfSubBlocks;
        % Check if its needed to add Dummy Bits:
        dummyBits =  subBlocksColumns * subBlocksRows - length ( subBlocks ( subBlockCount, : ) );
        % Isolate the Sub-Block:
        subBlockAux = [ subBlocks( subBlockCount, : ), zeros( 1, dummyBits ) ];
        
        subBlockSize = length( subBlockAux );
        if subBlockCount ~= numberOfSubBlocks
            % Rearrange in the Matrix Form:
            subBlockAux = reshape( subBlockAux , subBlocksColumns, []  );
            subBlockAux = subBlockAux';
            
            % Performs the Permutation:
            subBlockAux = subBlockAux( : , permutationPattern + 1);
            subBlockAux = reshape( subBlockAux, 1, [] );
        else
            %Performs the permutation:
            indexes = 0 : subBlockSize - 1;
            permutColumns = permutationPattern( floor( indexes / subBlocksRows ) + 1 );
            permutRows = subBlocksColumns * mod( indexes, subBlocksRows ) + 1;
            tempIndexes = mod( permutColumns + permutRows , subBlockSize ) + 1;
            subBlockAux = subBlockAux( tempIndexes );
        end
        
        % Resultant Interleaved Code Block (after the subblock processing):
        interleavedCodeBlock( ( subBlockCount - 1 ) * subBlockSize + 1 : ...
            subBlockCount * subBlockSize ) = subBlockAux;

    end
    % Eliminate dummy bits:
    interleavedCodeBlock ( interleavedCodeBlock == 0 ) = [];
    % Store the Bit Selection Sequence:
    this.bitSelectionIndex { blockCount } = interleavedCodeBlock;
end

