function decodedArray = decode( this, llrVector )
%TURBOCODE.DECODE Decodes the Rx LLR Array with a Turbo Decoder
%   Detailed description can be found in class header.
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 29 Apr 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% Initialization of Encoder Constants:
numberOfBranches = length ( this.encodersArray ) ; % Number of Conv. Encoders
interleavers = zeros( numberOfBranches , length ( this.interleavers ) );
deinterleavers = zeros( numberOfBranches , length ( this.interleavers ) );

% Temp variable. Dummy interleaver for the First Constituent Encoder:
aux = 1 : length ( this.interleavers );
interleavers(1,: ) = aux;
deinterleavers(1,:) = aux;

interleavers( 2:end, : ) = this.interleavers;
deinterleavers( 2:end, : ) = this.deinterleavers;

% Initialization of Auxiliar Vector ( used for the calculation of 
%                               the weight of Each Metric Transition).
outputMetric = cell( numberOfBranches , 1 );

% Adjust the scale to avoid overflow, LLR is now in interval [-100 100]:
infPos = isinf( llrVector ); % Find Values = +- INF
infSigns = sign( llrVector( infPos ) ); % Find the sign of these values
llrVector ( infPos ) = infSigns; % Remove those temporarily
llrVector = 100 * llrVector ./ max( abs( llrVector ) ) ;
llrVector( infPos ) = infSigns * 100; % Apply maximum values to those old INF positions
% DECODE Process:

% Initialize the Extrinsic Info for the SOVA Decoder (All Zeros).
extrinsicInfo =  zeros ( numberOfBranches , length( interleavers ) ) ;
llrPacketAux =  reshape( llrVector , numberOfBranches + 1, [] ); % Auxiliar Vector.

%Determine the Channel Reliability ...
for encoderCount = 1:numberOfBranches % ... after decoding for each constituent encoder
    % Interleaver Indexes:
    tempIndexes = interleavers ( encoderCount , : );
    % Select current constituent Encoder:
    encoder = this.encodersArray{ encoderCount } ;
    
    % Create auxiliar vector to calculate the Euclidian Distance for
    % each transition in the trellis:
    auxMetric = zeros( 2^encoder.trellis.outputBits ,  1);
    auxMetric( : , 1 ) =  0 : 2^encoder.trellis.outputBits - 1;
    auxMetric = ( de2bi( auxMetric , 'left-msb' ) * 2 - 1 ) * ( -1 ) ;
    
    %Reshape LLR vector according to the the Constituent Encoders:
    measOutput(1, : ) = llrPacketAux( 1, tempIndexes ); % Systematic Bits
    measOutput(2, : ) = llrPacketAux( encoderCount + 1, : ); % Parity Bits
    % Auxiliar Euclidian Distance
    outputMetric{encoderCount} = auxMetric * measOutput;
    
end

    
% Determine the Reliability of the systematic Bit (iterative decoding):
encoderIndexes = 1 : numberOfBranches;
for loopCount = 1 : this.iterations; % For each iteration ...
    for encoderCount = 1:numberOfBranches % ... and Each Constituent Encoder:
        % Select the constituent Block Encoder:
        encoder = this.encodersArray{ encoderCount } ;
        % Index of the Previous Encoder in the iterative decoding process:
        indexTemp = circshift( encoderIndexes , [ 0 encoderCount]);
        indexTemp = indexTemp( 1 );
        % Auxiliar Vector for extrinsic information weight in the
        % trellis:
        auxInput( : , 1 ) = 0: 2^encoder.trellis.inputBits - 1;
        auxInput = ( de2bi( auxInput , 'left-msb' ) * 2 - 1 ) * ( -1 ) ;
        % Weight for extrinsic information in the trellis:
        extrinsicMetricsAux = auxInput * extrinsicInfo( indexTemp , interleavers( encoderCount , : ) );
        % SOVA Decoder. Calculate the reliability of output bits
        reliability = this.sovaDecoderMex( outputMetric{ encoderCount } , extrinsicMetricsAux.' ...
            , encoder.trellis.nextStates, encoder.trellis.nextOutput);
        
        reliability = reliability( deinterleavers( encoderCount , : ) );
        % Update the Extrinsic Information
        extrinsicInfo( encoderCount, : ) = reliability - extrinsicInfo( indexTemp , : ) - llrPacketAux ( 1 , : );
        extrinsicInfo( encoderCount, : ) = extrinsicInfo( encoderCount, : ) * encoder.codeRate;
        
    end
    
end
    % Decoded Bits for this Packet:
    outputBits = ( sign( reliability ) + 1 )/ 2;
    % Update decoded Stream:
    decodedArray = outputBits;

