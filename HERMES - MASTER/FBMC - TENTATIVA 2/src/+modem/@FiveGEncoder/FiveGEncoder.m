classdef FiveGEncoder< modem.ChannelCode
% FiveGEncoder class implements the encoder for the FiveG Technologies.
%  There is no defined encoder for 5G Technologies yet. In Hermes the user
%  may select three options for the encoder: NONE, CONVOLUTIONAL and TURBO.
%  MCS created for 5G in hermes are defined in
%  lookuptables/fiveG/getMcsParam.
%
%   Read-Only Public Properties:
%       encoder < encoder Object > Contains the encoder Object. It may be
%           from 3 classes: modem.ChannelCode, modem.ConvolutionalCode, 
%           modem.TurboCode.
%       rateMatching < 1 x 1 modem.EncoderRateMatching > Object responsible
%           to perform the puncturing in the encoded packet to increase the
%           code rate.
%       tailbits < int > Number of Tail Bits used per packet.
%       paddingBits < int > Number of padding bits used in each packet to
%       adapt to the modulation size.
%   Methods
%   Constructor:
%       Syntax: this = FiveGEncoder( fiveG, rnd, harq )
%       Inputs: 
%               fiveG < struct > Containing the 5G Parameters needed for the
%           5G Encoder Creation such as:
%                   .TRANSPORT_BLOCK_SIZE_BITS < int > : packet size.
%                   .CODE.TURBO.POLYNOMIAL < M x N Octal > - 
%                       Contains the generator polynomial for the 
%                       convolutional code, Octal Form.
%                       M : Number of Parallel Concatenated Encoders.
%                       N : Number of Output Bits for each Parallel Encoder.
%                   .CODE.TURBO.ITERATIONS < int > Number of Decoder
%                       Iterations
%                   .CODE.TURBO.FEEDBACK< 1 x M Octal > -
%                       Polynomial for the feedback connection on each
%                       constituent convolutional encoder.
%                   .CODE.CONVOLUTIONAL.POLYNOMIAL < 1 x N Octal > -
%                       Contains the generator polynomial for the 
%                       convolutional code, Octal Form.
%                   .CODE.CONVOLUTIONAL.FEEDBACK < 1x1 octal > Polynomial
%                       for the feedback connection 
%               rnd < 1 x 1  RandStream object>
%               harq < 1x1 modem.Harq > HARQ object, responsible to control
%                   HARQ Processes.
%
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
%   
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v2.0 2 Jul 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

properties ( GetAccess = 'public', SetAccess = 'protected')
    encoder
    rateMatching
    tailBits
    paddingBits
end

properties ( GetAccess = 'protected', SetAccess = 'protected')
    packetSize  % Tx Packet Size
    rnd    % RandStream Object
    numberOfPackets 
    harq   % modem.Harq Object  
    buffer % Used for HARQ. Store the received RV for each packet.
end
%%
methods ( Access = public )

    %% constructor
    function this = FiveGEncoder( fiveG, rnd, harq )
        this.packetSize = fiveG.TRANSPORT_BLOCK_SIZE_BITS;

        switch fiveG.CODE.TYPE
            case enum.modem.CodeType.NONE
                this.encoder = modem.ChannelCode;
                this.codeRate = 1;
                this.tailBits = 0;

            case enum.modem.CodeType.CONVOLUTIONAL
                this.encoder = modem.ConvolutionalCode( fiveG.CODE.CONVOLUTIONAL.POLYNOMIAL, ...
                                                        fiveG.CODE.CONVOLUTIONAL.FEEDBACK );
                this.codeRate = fiveG.CODE.CODE_RATE;
                this.tailBits = this.encoder.trellis.numOfRegisters;
            case enum.modem.CodeType.TURBO
                mexFlag = true;
                interleavers = [];
                this.rnd = rnd;
                this.encoder = modem.TurboCode( fiveG.CODE.TURBO.POLYNOMIAL, ...
                                                fiveG.CODE.TURBO.FEEDBACK, ...
                                                fiveG.CODE.TURBO.ITERATIONS, ...
                                                interleavers, ...
                                                mexFlag, ...
                                                this.rnd );

                this.codeRate = fiveG.CODE.CODE_RATE; 
                this.tailBits = fiveG.CODE.TURBO.TAILBITS;
    

        end
        % Create the Rate Matching feature for this encoder:
        this.rateMatching = modem.EncoderRateMatching( this.codeRate , this.encoder );

        %% Calculating padding bits 
        bitsPerSymbol = fiveG.MODULATION_ORDER;
        % Number of Output bits per atomic part of puncture pattern:
        outputPuncturePatternSize = sum( sum( this.rateMatching.puncturePattern ) );
        % Minimum number of Puncture Patterns needed to have a integer
        % number of mapped symbols:
        minMultAtomicPuncturePatterns = lcm( outputPuncturePatternSize , bitsPerSymbol ) ...
                                                / outputPuncturePatternSize;
        puncturePatternInputBits = size(  this.rateMatching.puncturePattern , 2 );
        % Calculate the min value A, such as:
        % ( Number Of Bits ) % A = 0;
        minMultInputBits = puncturePatternInputBits * minMultAtomicPuncturePatterns; 

        % Check the need for padding bits:
        if rem( this.packetSize + this.tailBits , minMultInputBits ) == 0
            %No padding bits needed:
            this.paddingBits = 0;
        else
            % Padding bits:
            this.paddingBits = minMultInputBits - rem( this.packetSize + this.tailBits , minMultInputBits );
        end

        if fiveG.CODE.TYPE == enum.modem.CodeType.TURBO
            % Set the interleaver for Turbo Code, if needed:
            this.encoder.createInterleaver( this.packetSize + this.tailBits + this.paddingBits );
        end
        % Set HARQ Object:
        if ~exist('harq','var' )
            this.harq = [];
            this.buffer = [];
        else
            this.harq = harq;
            % Buffer dummy Initialization as a cell-array 
            this.buffer = cell( this.harq.numberOfUes , this.harq.numberOfHarqProcess);
        end 
    end
        

end
%%
end