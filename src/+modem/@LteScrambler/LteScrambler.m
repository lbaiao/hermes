classdef LteScrambler < modem.Scrambler
% LTESCRAMBLER class implements the LTE Scrambler object.
% Scrambler object is responsible for scrambling and descrambling the 
% transmission signal. The methods scramble and descramble can handle 
% multiple packets per call. The implementation is based on TS 36.211
%
%   Methods
%
%   constructor
%       Assembles a scrambler object. Initializes the conditions of the 
%       first and the second polynomials.
%
%       Syntax
%           this = LteScrambler( frame )
%       Inputs
%           frame< LteFrameAssembler > - reference to frame assembler
%           object
%
%   update2ndPolyInitialValue
%       Updates the initialization value of the 2nd polynomial every
%       subframe.
%       Syntax
%           this.update2ndPolyInitializationValue( subframeNumber )
%       Input
%           subframeNumber < 1 x 1 integer >: subframe number within a
%           frame
%
%   scramble
%       This function scrambles input sequence as per defined in TR 36.211
%       sections 6.3.1 and 7.2. Pseudo-random sequences are defined by a
%       length-31 Gold sequence. 
%       Gold sequences are defined as binary sequences, with small
%       cross-correlations. They are generated with two sequences of
%       size 2^n-1, such that the absolute cross-correlation is <= 2^(
%       n+2)/2, n is the size of the Linear Feedback Shift register
%       used to generate the maximum length sequence. Gold, R. (October 
%       1967). "Optimal binary sequences for spread spectrum multiplexing 
%       (Corresp.)". IEEE Transactions on Information Theory 13            
%
%       Syntax
%           transmittedSequence = this.scramble( this, inputSequence )
%
%       Input
%           inputSequence < B x 1 bits >: contains a sequence of B bits 
%           
%
%       Output
%           transmittedSequence  < B x 1 bits >: contains a sequence of B
%           scrambled bits
%
%    descramble 
%           This function descrambles the input sequence, using the same 
%           gold sequence used in the scrambling process. For the sake of 
%           performance, the gold sequence is not generated again in the 
%           receiver. Since it uses the subframe number, RNTI and cell ID, 
%           which are the same values for the transmitter, it was decided 
%           to save the sequences as a property of the scrambler object.
%           
%
%           Syntax
%               receivedSequence = this.descramble( inputSequence )
%
%           Input
%               inputSequence < B x 1 llrs >: contains a sequence of B
%           scrambled llrs
%
%           Output
%               receivedSequence < B x 1 llrs >: contains a sequence of B
%           descrambled llrs
%
%   Author: Erika Almeida (EA)
%   Work Adress: INDT Brasilia
%   E-mail: erika.almeida@indt.org.br
%   History:
%       v2.0 06 May 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    properties ( Access = protected )
        frame
    end
   
    methods ( Access = public )
        
        % constructor
        function this = LteScrambler( frame )
            
            this.frame = frame;
            
            % hard coded parameters
            codewordNumber = 0;
            NcellID = 10;
            RNTI = 100;
            
            % initial subframe number
            subframeNumber = 0;
            
            % initialization of the 1st polynomial according to TR 36.211
            this.firstPolyInitialConditions = [ 1; zeros(30,1)];
            
            % initialization of the 2nd polynomial according to TR 36.211
            c_init = RNTI * ( 2^14 ) +  codewordNumber * ( 2^13 ) + ...
                floor( subframeNumber/2 ) * ( 2^9 ) + NcellID;
           
            this.secondPolyInitialConditions = de2bi( c_init, 31, 'right-msb')';
            
        end
        
        % methods definition
        
        % scramble
        transmittedSequence = scramble( this, inputSequence );
        % descramble
        receivedSequence = descramble( this, inputSequence );
        % update 2nd polynomial initialization
        update2ndPolyInitialValue( this,  subframeNumber );
        
    end
end