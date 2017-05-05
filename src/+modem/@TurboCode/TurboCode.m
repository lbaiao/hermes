classdef TurboCode < modem.ChannelCode
% TURBOCODE implements the class ConvolutionalCode
% This class creates the object responsible to encode and decode a
% stream of bits using a Turbo Encoder code.
%  
%   Read-Only Public Properties
%         encodersArray < 1 x M modem.ConvolutionalCode > -
%           Array of Parallel Concatenated Convolutional Encoders
%         interleavers < (M - 1) x K  int> - Interleaver Vectors for
%           the parallel concatenated Convolutional Encoders.
%         deinterleavers < (M - 1) x K  int > - Deinterleavers vectors
%           capable of undo the interleaver process.
%         iterations < int > - Number of Iteratios used in the decoding
%         process
%         
% METHODS
%   Constructor
%       Syntax: this = TurboCode( codeGenerator, feedback
%       iterations, interleavers, mexFlag , rnd )
%       Inputs: codeGenerator < M x N Octal > - Contains the generator
%                   polynomial for the convolutional code, Octal Form.
%                   M : Number of Parallel Concatenated Encoders.
%                   N : Output Bits for each Parallel Encoder.
%                   Current Inplementations expects N to be equals to 2.
%                   And Constituent Convolutional Encoders
%                   with one input bit.
%   ¨           feedback < M x 1 > - Contains the Feedback connection
%                   for the input of each parallel concatenated 
%                   Convolutional Encoder 
%               iterations < int > - Number of Iteratios used in the 
%                   decoding process.
%               interleavers < (M - 1) x K  int> Interleaver Vectors
%                   for the parallel concatenated Convolutional 
%                   Encoders.
%               mexFlag < 1x1 boolean > Indicates if the MEX Function
%           is allowed to be used for encode/decode methods. It must be
%           set to true.
%               rnd < 1 x 1  RandStream object>
%     encode
%       Encodes the information contained in the bits Array using the
%       parallel concatenated convolutional encoders.
%       Syntax: encodedBits =  encode( bits );
%           Inputs: 
%               bits  < 1 x P > Stream of P bits.
%           Output: 
%               encodedBits < 1 x P / codeRate > Encoded bit array.
%
%    decode
%       Decodes the received LLR in bits, using a SOVA Decoder.
%       Syntax: rxBits = decoded ( llrEstimation )
%           Inputs: 
%               llrEstimation < 1 x S / codeRate bits >: stream with log
%           likelihood estimation ( llr ) for received bits.
%           Outputs:
%               rxBits < 1 x S bits >: stream of decoded Bits.
%
%    setInterleaver 
%       Sets the Interleaver for the Turbo Encoder.
%       Syntax: setInterleaver( interleaver, deinterleaver )
%           Inputs: interleaver < 1 x L int > Contains the interleaver
%           vector for a code block of size L.
%               deinterleaver < 1 x L int > Contains the deinterleaver
%           vector for a code block of size L.
%
%    createInterleaver 
%       The interleaver sequence is generated using a quadratic polynomial
%       from the form ( b.x^2 + a.x)mod_N , where N is the interleaver size,
%       as stated in [ 1 ]. The optimizations of a and b values depends on 
%       the cyclic length of the encoder generator and exaustive computation.
%       Due to computational processing complexity, this optimization is not
%       performed here. The values of a and b are taken from the delimited
%       research region defined in [ 1 ] by the rules:
%       1) The interleaver polynomial is from the form ( bx^2 + ax )mod_N  
%       2) Consider the i prime factors of N: p_0, p_1, ..., p_i
%       3) b has the same prime factors than N, and o_b[p_i] <= o_i[p_i] 
%           for all i, where o_N[ p_x ] is the order of the prime factor 
%           p_x, in the factorization of N. In other words: 
%           N = p_0^(o_N[p_0]) * p_1^(o_N[p_1]) * ... * p_i^(o_N[p_i]).
%       4) o_b[p_i] >= 1, for all i.
%       5) a is coprime with all p_i.
%       6) 1 <= a <= 2b 
%   [ 1 ] Interleavers for Turbo Codes Using Permutation Polynomials Over
%   Integer Rings. Jing Sun, Oscar Y. Takeshita. IEEE Transactions of
%   Information Theory, vol. 51, January 2005. 
%       Syntax: createInterleaver( packetSize )
%           Inputs: packetSize < 1 x 1 int >: number of bits to be encoded. 
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 31 Mar 2015 (RA) - created
%       v2.0 6 Jul 2015 (RA ) - Method "createInterleaver" implemented.
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.    

    
    properties ( GetAccess = 'public', SetAccess = 'protected' )
        encodersArray
        interleavers
        deinterleavers
        iterations
    end
    
    properties ( GetAccess = 'protected', SetAccess = 'protected' )
        rnd = [];
    end
    methods ( Access = 'public' )
        %constructor
        function this = TurboCode( codeGenerator, ...
                                    feedback, ...
                                    iterations, ...
                                    interleavers, ...
                                    mexFlag, ...
                                    rnd)
            numberOfEncoders = size( codeGenerator , 2 );
            
            % Create the Array of Parallel Concatenated Convolutional Encoders:
            for encoderCount = 1 : numberOfEncoders
                generator = codeGenerator( encoderCount , :);
                newEncoder = modem.ConvolutionalCode( generator , feedback, mexFlag );
                this.encodersArray{ encoderCount } = newEncoder;
            end
            
            %Number of Decoder Iterations:
            this.iterations = iterations;
            if exist( 'interleavers', 'var' )
                this.interleavers = interleavers;
                [~ , this.deinterleavers ] = sort( this.interleavers, 'ascend');
                
            else
                this.interleavers = [];
                this.deinterleavers = [];
            end
            
            this.codeRate = 1 / ( numberOfEncoders + 1 );
            
            if exist( 'rnd' ) && ~isempty( rnd )
                this.rnd = rnd;
            end
        end
        
        % Class Methods:
        encodedBits = encode( this, packets )
        decodedArray = decode( this, llrVector )
        setInterleaver( this, interleaver, deinterleaver )
        createInterleaver( this, packetSize )
    end   
end

