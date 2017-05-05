function setTrellis( this , codeGenerator, feedback )
% CONVOLUTIONALCODE.SETTRELLIS Creates the trellis for a Conv. Encoder.
%   setTrellis function is used to set the States Machine for the
%   convolutional encoder Trellis. It sets the attribute 'trellis'
%   to the CONVOLUTIONALCODE Class Object.
%
%   Syntax: setTrellis( this , codeGenerator )
%       Inputs: codeGenerator < K x N Octal > - Contains the generator
%           polynomial for the convolutional code, in Octal Form.
%           K : Number of Input Bits.
%           N : Number of Output Bits.
%               feedback < 1 x K Octal > Contains the feedback
%           connection for each input on the convolutional encoder
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

% Attributes Initialization

if ~(exist('feedback','var')) || isempty( feedback ) 
    noFeedback =  true;
else
    noFeedback = false;
end
[ this.trellis.inputBits , this.trellis.outputBits ] = size( codeGenerator );
this.codeRate = this.trellis.inputBits / this.trellis.outputBits; % Set Code Rate
this.trellis.octPolyGen = codeGenerator;
this.trellis.binPolyGen = cell( this.trellis.inputBits , 1 );
this.trellis.octFeedback = feedback;

% Set Binary Generator Polynomial
for input = 1 : this.trellis.inputBits;
    % Polynomial for each input Bit:
    this.trellis.binPolyGen{ input } = de2bi ( ...
        base2dec( num2str( this.trellis.octPolyGen (input, : )' ), 8 ), ...
                                                                'left-msb');
    % Number of State Registers for each input bit:
    this.trellis.numOfRegisters( 1 , input  ) = length( this.trellis.binPolyGen{ input }  ) - 1;
    % FeedBack Connection for Each Input:

    if noFeedback
        feedbackBinary{ input } = zeros( 1, this.trellis.numOfRegisters( input  ) + 1 );
        feedbackBinary{ input } ( 1 ) = 1;
    else
        feedbackConnectionAux = base2dec( num2str( this.trellis.octFeedback (input, : )' ), 8 );
        feedbackBinary{ input } = de2bi ( feedbackConnectionAux , ...
            this.trellis.numOfRegisters( input  ) + 1,  'left-msb');
    end
end


%Initialize States Machine Variables:
    % Number of States in registers memory
numOfStates = 2^( sum( this.trellis.numOfRegisters ) ); 
    % Initialization: transition to Next States
this.trellis.nextStates = zeros( numOfStates , 2^this.trellis.inputBits ); 
    % Initialization: transition to Next Output
this.trellis.nextOutput = zeros( numOfStates, 2^this.trellis.inputBits ); 

% List all possible Shift Registers States (binary form):
states(:,1) = 0: numOfStates-1; % All possible states (int form)
binStates = de2bi(states, sum( this.trellis.numOfRegisters ) , 'left-msb' ); % Binary Form

% Trellis Transition Calculation:
for symbolCount = 0: 2^this.trellis.inputBits - 1
    % Input Symbol in the binary form:
    inputSymbol = de2bi( symbolCount, this.trellis.inputBits, 'left-msb' ); 
  
    initialRegister = 1; % Index for 1st Shift Register for the 1st Input
    outputAux = 0;
    nextStateAux = circshift( binStates, [0 1]); % Preparation for Next State Calc.
    for inputCount = 1: this.trellis.inputBits
        % Select all shift registers related to this input:
        shiftRegisters = initialRegister : initialRegister + this.trellis.numOfRegisters( inputCount ) - 1;
        
        % ============= Input Bit Value after Feedback ===================
        inputBit = repmat( inputSymbol( inputCount ), numOfStates , 1);
        feedbackBit = [ inputBit binStates(:, shiftRegisters) ] * feedbackBinary{ inputCount }';
        inputAfterFeedback = mod( feedbackBit , 2 );
        
        % ====================== Next Output Calculation =================
        % Output = ( Systematic Bit + Shift Registers State ) * Gen.
        % Polynomial + Output Value Stored due to previous input bits
       	outputAux = [ inputAfterFeedback binStates(:, shiftRegisters) ] * ... 
                        this.trellis.binPolyGen{ inputCount }' + outputAux;
   
        % ================== Next State Calculation =======================
        nextStateAux( : ,  initialRegister ) = inputAfterFeedback;
        % Relative Position for 1st Shift Register of next
        % input bit:
        initialRegister = initialRegister + this.trellis.numOfRegisters( inputCount );
    end
    
    % Calculate Next State for Trellis:
        %Next State = Next State for all zeros input + State Change
    this.trellis.nextStates(:, symbolCount +  1) = bi2de( nextStateAux, 'left-msb' );
    
    % Next Outputs Vector:
    this.trellis.nextOutput(:, symbolCount+1) = bi2de( mod( outputAux , 2 ), 'left-msb' );
end


end

