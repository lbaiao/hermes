classdef ConvolutionalCode < modem.ChannelCode
    % CONVOLUTIONALCODE implements the class ConvolutionalCode
    % This class creates the object responsible to encode and decode a
    % stream of bits using a convolutional code.
    %  
    %   Read-Only Public Properties
    %         octPolyGen < K x N Octal > - Generator Polynomial Octal Form
    %         numOfRegisters < 1 x K  int> - Number of State Registers for
    %         each input bit.
    %         mexFlag < 1x1 boolean > -  Flag indicating if MEX function
    %         should be used in the decoder due to speed purposes.
    %         
    % METHODS
    %   Constructor:
    %       Syntax: this = ConvolutionalCode( codeGenerator, feedback, mexFlag)
    %       Inputs: codeGenerator < K x N Octal > - Contains the generator
    %           polynomial for the convolutional code, in Octal Form.
    %           K : Number of Input Bits.
    %           N : Number of Output Bits.
    %               feedback < 1 x K Octal > Contains the feedback
    %           connection for each input on the convolutional encoder
    %               mexFlag < 1x1 boolean > Indicates if the MEX Function
    %               shall be used for encode/decode methods.
    %     encode:
    %       Syntax: encodedBits =  encode( packets );
    %           Inputs: 
    %               packets: Cell-Array < 1 x N > carrying N packets with bits
    %           Output encoded Bits < 1 x K / R bits >: stream of encoded
    %           bits. Where K is the total number of input bits across all 
    %           input packets and R is the Code Rate.
    %
    %    decode:
    %       Syntax: rxBits = decoded ( llrEstimation )
    %           Inputs: 
    %               llrEstimation < 1 x K / R bits >: stream with log
    %           likelihood estimation ( llr ) for received bits.
    %           Outputs:
    %               rxBits < 1 x K bits >: stream of decoded Bits.
    %
    %   Author: Rafhael Medeiros de Amorim (RA)
    %   Work Address: INDT Brasília
    %   E-mail: < rafhael.amorim@indt.org.br >
    %   History:
    %       v2.0 31 Mar 2015 (RA) - created
    %
    %   Copyright (c) 2015 INDT - Institute of Technology Development.
    %
    %   The program may be used and/or copied only with the written
    %   permission of INDT, or in accordance with the terms and conditions
    %   stipulated in the agreement/contract under which the program has been
    %   supplied.
    
    properties ( GetAccess = 'public', SetAccess = 'protected' )
        trellis
        mexFlag
    end
    
    properties ( Access = 'protected' )

    end
    
    methods ( Access = 'public' )
        %constructor
        function this = ConvolutionalCode( codeGenerator, feedback, mexFlag )
            this.trellis = [];
            %  State Machine Calculation:
            this.setTrellis( codeGenerator, feedback );
                       
            if ~(exist( 'mexFlag' ) )
                this.mexFlag = true;
            else
                this.mexFlag = mexFlag;
            end
        end
        
        encodedArray = encode( this, bits );
        decodedBits = decode( this, llrEstimation );
        
    end
    methods ( Access = 'protected' )
        setTrellis( this, codeGenerator, feedback );
        decodedArray = viterbiDecoderMex(this, outputMetric, nextStates, nextOutput);
    end
    
end

