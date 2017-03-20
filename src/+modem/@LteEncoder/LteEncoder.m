classdef LteEncoder < modem.ChannelCode
% LteEncoder class implements the LTE Turbo Coding for PDSCH Channels.
%
%   The CodeBlock Segmentation, Rate Matching and Interleavers for LTE
%   Encoder may be found in Reference: 3GPP TS 36.212 V12.4.0.
%
%   Read-Only Public Properties:
%       numberOfCodeBlocks < int > Contains the number of Code Blocks
%       turboEncoder < 1 x 1 modem.turboEncoder > Turbo Encoder Object used
%           in the LTE Encoder.
%       packetSize < int > Expected Packet ( or Transport Block) Size in bits.
%
%   Methods
%   Constructor:
%       Syntax: this = LteEncoder( LTE, frameAssembler, rnd, harq )
%       Inputs: 
%               LTE < struct > Containing the LTE Parameters needed for the
%           LTE Encoder Creation such as:
%                   .ENCODER.TURBO.GENERATOR_POLYNOMIAL < M x N Octal > - 
%                       Contains the generator polynomial for the 
%                       convolutional code, Octal Form.
%                       M : Number of Parallel Concatenated Encoders.
%                       N : Number of Output Bits for each Parallel Encoder.
%                   .ENCODER.TURBO.ITERATIONS < int > Number of Decoder
%                       Iterations
%                   .ENCODER.TURBO.FEEDBACK_CONNECTION < 1 x M Octal > -
%                       Polynomial for the feedback connection on each
%                       constituent convolutional encoder.
%                   .MEX_FLAG < boolean > Indicates the permission for use 
%                       HERMES Mex Functions for Encode/Decode.
%                   .MCS: Modulation and Coding Scheme Index.
%                   .ENABLE256QAM: Flag that allows the usage of 256 QAM in LTE
%                       Simulations.
%                   .NUMBER_PRBS_PER_TRANSPORT_BLOCK: Number of PRBs used to
%                       transmit each transport block.
%                   .NUMBER_OF_CRC_BITS < int >: CRC Sequence Size in Bits
%               frameAssembler < 1x1 modem.LteFrameAssembler >
%               rnd < 1 x 1  RandStream object>
%               harq < 1x1 modem.Harq > Used to control HARQ Processes.
%   encode: 
%       Syntax: encodedBitsArray = encode( transportBlocks )
%       Inputs: transportBlocks < 1 x M cell Array  >: Contain the M 
%                   transport blocks to be encoded. 
%       Outputs: < 1 x N bits > Number of bits encoded after all encoded
%       packets are appended to the output vector.
%
%   decode: 
%       Syntax: decodedBits = decode( llr )
%       Inputs: llr < 1 x N double >: Vector with estimated LLR per bit.
%       Output: decodedBits < 1 x M Cell-Array >: Cell array wit the M
%           decoded packets.
%   
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v2.0 6 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    properties ( GetAccess = 'public', SetAccess = 'protected')
        numberOfCodeBlocks    
        turboEncoder
        packetSize
    end
    
    properties ( GetAccess = 'protected', SetAccess = 'protected')
        transportBlockCrcSize % # of CRC bits applied over the Transport Block.
        
        segmentedBlockCrcSize % # of CRC bits applied over the Segmented Blocks,
                              % when segmentation is required tue to
                              % Transport Block Size.
                              
        fillerBits            % # of Filler Bits used to fill the first segmented 
                              % block, when it is needed to make it fit on
                              % LTE Code Block allowed sizes.
        rnd
        txBlockSize = [];     % < C x N int >( N = Number of Packets, C = Number 
                              % of Code Blocks). Store the size of each Tx Block 
                              
        interleavers          % < 1 x C cell-array > ( C = Number of Code Blocks )
                              % Contains the turbo encoder interleaver
                              % sequence for each code block.
        deinterleavers
        
        frameAssembler        % Used for extract puncturing information.
                              % < 1 x 1 modem.LteFrameAssembler >
        
        bitSelectionIndex
        
        harq                  % modem.Harq Object. 
        buffer              % Redundancy Versions 
    end
    %%
    methods ( Access = public )
        
        %% constructor
        function this = LteEncoder( LTE, frameAssembler, rnd, harq )
            % Number of Bits to be Attached to the Transport Block
            this.transportBlockCrcSize = LTE.NUMBER_OF_CRC_BITS;
            % rnd attribute:
            this.rnd = rnd;
            % Frame Assembler Pointer:
            this.frameAssembler = frameAssembler; 
            
            %% ============= Expected Transport Block Size ==============
            % Get Transport Block Size Index:
            mcs = LTE.MCS;
            enable256qam = LTE.ENABLE256QAM;
            transportBlockSizeIndex = ...
                lookupTables.modem.lte.getTbsIndex( mcs, enable256qam);
            % Get Number of PRBs
            numOfPrbs = LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK ;
            % Get Transport Block Size:
            this.packetSize = ...
                lookupTables.modem.lte.getTransportBlockSize( ...
                transportBlockSizeIndex , numOfPrbs );
            %% ======== Set Simulation Code Block Sizes: ================
            this.setCodeBlockSizes ( LTE );
            
            %% ============== Create Turbo Encoder:   ===================
            % Polynomial Generator:
            codeGenerator = LTE.ENCODER.TURBO.GENERATOR_POLYNOMIAL;
            % Number of Decoder Iterations
            iterations = LTE.ENCODER.TURBO.ITERATIONS;
            % Interleavers for each Code Block (Initialization)
            interleavers = [];
            % Feedback Connection:
            feedback = LTE.ENCODER.TURBO.FEEDBACK_CONNECTION;
            % MEX Flag
            mexFlag = LTE.MEX_FLAG;
            
            if ~mexFlag
                error('Turbo Code cannot be set without allowing the usage of MEX Functions' );
            end
            % Create Turbo Code Attribute:
            this.turboEncoder = modem.TurboCode( codeGenerator , ...
                feedback, ...
                iterations, ...
                interleavers, ...
                mexFlag);
            this.codeRate = this.turboEncoder.codeRate;
            
            %% === Expected Encoded Packet Size after Rate Matching =======
             modulationOrder = ...
                lookupTables.modem.lte.getModulationOrder( mcs, enable256qam );
            
            this.setEncodedPacketSize( LTE, frameAssembler, modulationOrder );
            
            % ======= Set Bit Selection Vector for Rate Matching ==========
            this.setBitSelectionVector( );
            % =========== Set HARQ Object  ==============
            if ~exist('harq','var' )
                this.harq = [];
                this.buffer = [];
            else
                this.harq = harq;
                % Buffer dummy Initialization as a cell-array 
                this.buffer = cell( this.numberOfCodeBlocks , this.harq.numberOfUes, ...
                                    this.harq.numberOfHarqProcess ); 
                              
            end
        end
        
 
    end
    %%
    methods( Access = 'protected' )
       setCodeBlockSizes( this, LTE )
       codeBlocks = codeBlockSegmentation( this, transportBlock )
       setBitSelectionVector( this, LTE )
       setEncodedPacketSize( this, LTE, frameAssembler, modulationOrder )
    end
end