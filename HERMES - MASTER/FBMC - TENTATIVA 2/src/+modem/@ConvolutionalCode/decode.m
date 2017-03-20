function decodedArray = decode( this, llrPacket )
%CONVOLUTIONALCODE.DECODE Decodes the Rx LLR Array with a Conv. Encoder
%   Detailed description can be found in class header.
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

% Initialize Constants for Decoder:
numOfStates = 2^sum( this.trellis.numOfRegisters );

inputSymbols = 2^this.trellis.inputBits;  % Number of Input Symbols

% Change the scale of LLR Packet to avoid overflow. LLR is in interval [-100 100]:
% Adjust the scale to avoid overflow, LLR is now in interval [-100 100]:
infPos = isinf( llrPacket ); % Find Values = +- INF
infSigns = sign( llrPacket( infPos ) ); % Find the sign of these values
llrPacket ( infPos ) = infSigns; % Remove those temporarily
llrPacket = 100 * llrPacket ./ max( abs( llrPacket ) ) ;
llrPacket( infPos ) = infSigns * 100; % Apply maximum values to those old INF positions

% Auxiliar Vector to Euclidian Distance Calculation of each Transition in the Trellis:
auxMetric( : , 1 ) =  0 : 2^this.trellis.outputBits - 1;
auxMetric = ( de2bi( auxMetric , 'left-msb' ) * 2 - 1 ) * ( -1 ) ;

vectorSize = length( llrPacket ) * this.trellis.inputBits / this.trellis.outputBits; % Output Size

%Reshape LLR vector according to the number of Output Bits in each stage in the Trellis:
measOutput =  reshape( llrPacket, this.trellis.outputBits, [] );
outputMetric = auxMetric * measOutput;
decodedArray = zeros( 1, vectorSize );
    
    % -------------------- Call Mex File ----------------------------------
    if this.mexFlag
        
        decodedArray = this.viterbiDecoderMex(outputMetric, this.trellis.nextStates, this.trellis.nextOutput);
        
    % ---------------------------------------------------------------------    
    else
        INF = 10e10;
        % Start the Viterbi Decoder:
        pathMetric = zeros( numOfStates, vectorSize + 1) + INF; % Initial Paths Metric
        pathMetric( 1 , 1 ) = 0;                         % Initial State Set to all zeros
        survivorState = zeros( numOfStates, vectorSize + 1); % Previous State in Survivor Path
        
        % Calculate the incoming Paths for each State
        for state = 0: numOfStates - 1;
            oldState( state + 1 , : ) = find( this.trellis.nextStates == state );
        end
        
        %Trellis Length:
        trellisLength = vectorSize / this.trellis.inputBits;
        
        % Calculate Trellis Paths
        for currentStep = 1 : trellisLength
            nextStep = currentStep + 1;
            % Metric for each possible output
            outputMetricAux = outputMetric(:, currentStep);
            % Metric for each State Transition
            statesMetric = outputMetricAux( this.trellis.nextOutput + 1 ) + repmat( pathMetric( : , currentStep ), 1, inputSymbols);
        
            % For each of Trellis Next States:
            for nextState = 0 : numOfStates - 1
                % Calculate the Survivor Path Leading to this State
                [survMetric, survIndex] = min( statesMetric( oldState( nextState + 1, : ) ) );
                % Update Path Metric
                pathMetric( nextState + 1 , nextStep  ) = survMetric( 1 );
                % Store Survivor Path
                survivorState( nextState + 1 , nextStep  ) = mod( oldState( nextState + 1, survIndex( 1 ) ) - 1, numOfStates ) ;
            end
        end
        
        %% Traceback Algorithm
        depth = vectorSize / this.trellis.inputBits + 1;
        % Determine Last Survivor in the Trellis:
        [~, currState] = min( pathMetric ( : , depth ) );
        
        
        for step = depth : -1 : 2
            % Previous State in Survivor Path
            survPath = survivorState( currState, step );
            % Input Symbol that lead from Previous to Current State:
            inputSymbol = find( this.trellis.nextStates( survPath + 1 ,: ) == currState - 1 ) - 1;
            % Update Output Array:
            decodedArray( step - 1 ) = inputSymbol;
            % Step Back in the trellis:
            currState = survPath + 1;
        end
        
    end
    

end
