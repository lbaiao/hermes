classdef Scrambler < handle
% SCRAMBLER class implements the scrambler object.
% Scrambler object is responsible for scrambling input sequences and
% descrambling the sequence at the receiver.
%
%   Read-Only Public Property
%       scramblingSequences - < 1 x numberOfPackets cell >: scrambling
%       sequences. Each element in the cell contains the scrambling
%       sequence in each packet.
%       firstPolyInitialConditions - < 1 x 31 binary >: values of the input
%       sequence of the first polynomial.
%       secondPolyInitialConditions- < 1 x 31 binary >: values of the input
%       sequence of the second polynomial.
%
%   Methods
%   constructor
%       Used to generate the initial values of input sequences of 1st and
%       2nd polynomials.
%           
%           Syntax
%               this = Scrambler( );
%
%   scramble
%       Used to scramble input sequence. The signal is scrambled using a 
%       Gold sequences, defined as binary sequences, with small 
%       cross-correlations. They are generated with two sequences of
%       size 2^n-1, such that the absolute cross-correlation is <= 2^(
%       n+2)/2, n is the size of the Linear Feedback Shift register
%       used to generate the maximum length sequence. Gold, R. (October 
%       1967). "Optimal binary sequences for spread spectrum multiplexing 
%       (Corresp.)". IEEE Transactions on Information Theory 13       
%       
%           Syntax
%               transmittedSignal = this.scramble( inputSequence )
%
%           Input
%               inputSequence < numberOfBits x 1 >: array of bits to be
%               scrambled
%                                       
%           Output
%               receivedSignal < numberOfBits x 1 >: array of scrambled 
%               bits
%
%   descramble
%       Used to descramble input sequence.
%
%           Syntax
%               receivedSignal = this.descramble( inputSequence )
%
%           Input
%               inputSequence < numberOfLlrs x 1 >: array of bits to be
%               descrambled
%                                       
%           Output
%               receivedSignal < numberOfLlrs x 1 >: array of descrambled
%               bits
%
%   Author: Erika Almeida (EA)
%   Work Adress: INDT Brasilia
%   E-mail: erika.almeida@indt.org.br
%   History:
%       v2.0 05 May 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    % properties definition
    properties ( GetAccess = 'public', SetAccess = 'protected' )
        scramblingSequences
        firstPolyInitialConditions
        secondPolyInitialConditions
    end
    
    properties ( Access = 'protected' )
        rnd
    end    
    
    % methods definition
    methods
        % constructor
        function this = Scrambler( rnd )
            
            if ~exist( 'rnd', 'var' )
                this.rnd = RandStream.getGlobalStream;
            else
                this.rnd = rnd;
            end
            
            % random initial conditions
            firstPolyInitialCondition = 1;
            secondPolyInitialCondition = this.rnd.randi( [0,1], [5,1] );
            
            % initialization of the 1st polynomial 
            this.firstPolyInitialConditions = [firstPolyInitialCondition...
                                                ; zeros(30,1)];
            % initialization of the 2nd polynomial                                 
            this.secondPolyInitialConditions = [secondPolyInitialCondition ...
                                                ; zeros(25,1)];
            
        end
        % other methods
        transmittedSignal = scramble( this, inputSequence );
        receivedSignal = descramble( this, inputSequence );
    end

end
