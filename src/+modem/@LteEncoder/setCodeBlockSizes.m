function setCodeBlockSizes( this, LTE )
%LTEENCODER.SETCODEBLOCKSIZES Sets parameters for code block segmentation.
%  This function sets the LTE Code Block Sizes expected after the transport
%  block is segmented into smaller code blocks. It also sets the
%  interleaver sequence to be used for the turbo encoder for each code
%  block.
%   
%   Syntax: setCodeBlockSizes( LTE )
%   Inputs: LTE < struct > contains the LTE parameters used for
%           determination of the Code Block Sizes, the attributes read from
%           the struct are:
%               .MCS: Modulation and Coding Scheme Index.
%               .ENABLE256QAM: Flag that allows the usage of 256 QAM in LTE
%                   Simulations.
%               .NUMBER_PRBS_PER_TRANSPORT_BLOCK: Number of PRBs used to
%                   transmit each transport block.
%               .NUMBER_OF_CRC_BITS < int >: CRC Sequence Size in Bits
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 16 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% ======= Read parameters that set the Expected Transport Block Size: ==============

mcs = LTE.MCS;                                   % Simulated MCS
enable256qam = LTE.ENABLE256QAM;                 % Flag enabling 256 QAM.
numOfPrbs = LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK; % Number of PRBs per Transport Block

% Get the Index for Transport Block Size: 
transportBlockSizeIndex = lookupTables.modem.lte.getTbsIndex( mcs, enable256qam);
% Get the Transport Block Size from the respective lookup Table:
transportBlockSize = ...
    lookupTables.modem.lte.getTransportBlockSize( transportBlockSizeIndex , numOfPrbs ); 

%% ====== Read LTE Encoder Parameters for interleaver and block Segmentation ========
% ( Table 5.1.3-3 at 3GPP TS 36.212 V12.4.0 ) :
[ codeBlockSizes , f1, f2] = lookupTables.modem.lte.turboCodeInterleaving();

maxTransBlockSize = max( codeBlockSizes ); 

% The LTE Code Block is appended with a CRC Sequence before Block
% Segmentation:
transportBlockSizeTemp = transportBlockSize + this.transportBlockCrcSize;

%% ============= Sets the Sizes for Code Block Segmentation: =======================

if transportBlockSizeTemp <= maxTransBlockSize
    % In this Case Transmit Only One Code Block:
    this.numberOfCodeBlocks = 1;
    % No new CRC is added:
    this.segmentedBlockCrcSize = 0;
    % Check expected Code Block Size :
    auxSize = transportBlockSizeTemp / this.numberOfCodeBlocks;
    % Find the Index for expected Block Size:
    codeBlockPlusIndex = find( codeBlockSizes >= auxSize, 1 , 'first' );
    % Code Block Size Plus ( Up to 2 code block Sizes are allowed at LTE.
    % K+ and K- ):
    codeBlockSizePlus = codeBlockSizes ( codeBlockPlusIndex );
    this.codeBlockSize = codeBlockSizePlus;
    
    % No other Code Block creation is required:
    numOfBlocksSizePlus = 1; % Only one code block with the defined size.
    numOfBlocksSizeMinus = 0; %There is no Code Block with different length
    codeBlockSizeMinus = 0; % There is no Code Block with different length
    
else
    % CRC is added to each new segmented code block:
    this.segmentedBlockCrcSize = LTE.NUMBER_OF_CRC_BITS;
    % Calculate the number of code blocks required:
    this.numberOfCodeBlocks = ceil( transportBlockSizeTemp ...
        / (maxTransBlockSize + this.segmentedBlockCrcSize) );
    % The total number of Tx Bits includes the new CRC
    % Attachments:
    transportBlockSizeTemp = transportBlockSizeTemp + ...
        this.numberOfCodeBlocks * this.segmentedBlockCrcSize;
    
    % Set the code block Sizes ( Up to 2 code block Sizes are allowed at LTE.
    % K+ and K- ):
    auxSize = transportBlockSizeTemp / this.numberOfCodeBlocks;
    % K+ Size ( Larger Blocks ):
    codeBlockPlusIndex = find( codeBlockSizes >= auxSize, 1 , 'first' );
    codeBlockSizePlus = codeBlockSizes (  codeBlockPlusIndex );
    % K- Size  ( Smaller Blocks ):
    codeBlockMinusIndex = codeBlockPlusIndex - 1;
    codeBlockSizeMinus = codeBlockSizes (  codeBlockMinusIndex );
    
    % Set the number of code blocks with each size:
        % Delta between superior and inferior size:
    deltaCodeBlockSize  = codeBlockSizePlus - codeBlockSizeMinus;
        % Number of Blocks with inferior Size:
    numOfBlocksSizeMinus = floor (  ( this.numberOfCodeBlocks * codeBlockSizePlus ...
        - transportBlockSizeTemp ) / deltaCodeBlockSize );
        % Number of Blocks with Superior Size
    numOfBlocksSizePlus = this.numberOfCodeBlocks - numOfBlocksSizeMinus;
    
    % Set the vector with Code Block Sizes
    this.codeBlockSize = [ ones( numOfBlocksSizeMinus , 1 ) * codeBlockSizeMinus ...
        ones( numOfBlocksSizePlus , 1 ) * codeBlockSizePlus ];
    
end
% Check whether it is necessary to add filler Bits to the 1st code
% Block:
this.fillerBits =  numOfBlocksSizePlus * codeBlockSizePlus + ...
    numOfBlocksSizeMinus * codeBlockSizeMinus - ...
    transportBlockSizeTemp;

%% ==============  Load Interleaver Sequences ==========================

% Initialization
this.interleavers = cell(1, this.numberOfCodeBlocks);
for blockCount = 1: this.numberOfCodeBlocks
    % Index of original Bits Positions on Systematic Vector
    tempIndexes =  0 : this.codeBlockSize ( blockCount ) - 1;
    % Load LTE Interleaver Parameters:

    if this.codeBlockSize( blockCount ) == codeBlockSizeMinus
        % 1) Code Blocks of Inferior Size:
        tempFirstVar = f1 ( codeBlockMinusIndex ); % 1st interleaver Constant
        tempSecondVar = f2 ( codeBlockMinusIndex ); % 2nd interleaver Constant
    else
        % 2) Code Blocks of Superior Size:
        tempFirstVar = f1 ( codeBlockPlusIndex ); % 1st interleaver Constant
        tempSecondVar = f2 ( codeBlockPlusIndex ); % 2nd interleaver Constant
    end
    % Create Interleaver Vector for this Code Block:
    this.interleavers{ blockCount } = ...
        mod( tempFirstVar * tempIndexes + tempSecondVar * tempIndexes.^2, ...
        this.codeBlockSize( blockCount) ) + 1 ;
    
    [ ~, this.deinterleavers{ blockCount } ]= ...
                        sort( this.interleavers {blockCount }, 'ascend' );
end