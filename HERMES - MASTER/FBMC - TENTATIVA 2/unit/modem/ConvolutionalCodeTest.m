%CONVOLUTIONALCODETEST script tests the ConvolutionalCode class
% This function test the creation of a ConvolutionalCode object and its
% methods
%
%   Syntax: ConvolutionalCodeTest
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 24 Apr 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check class constructor without Mex Flag
% Test constructor of Convolutional Channel Code Class
polyGenerator = [10 13];
feedback = 13;
packetSize = 300;
codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );

assert( isa ( codeObject, 'modem.ConvolutionalCode' ) );

%% Test 2: Check Class Code Rate
polyGenerator = [10 13];
packetSize = 300;
codeObject = modem.ConvolutionalCode ( polyGenerator , [] );

[ inputBits , outputBits ] = size( polyGenerator );

assert( isequal ( codeObject.codeRate , inputBits / outputBits ) );


%% Test 3: Check Constructor with Mex Flag Attribution
polyGenerator = [10 13];
packetSize = 300;
mexFlag = true; 
codeObject = modem.ConvolutionalCode ( polyGenerator , [] , mexFlag  );
aux = true;

aux = isequal ( codeObject.mexFlag , mexFlag );

mexFlag = false;

if aux 
    codeObject = modem.ConvolutionalCode ( polyGenerator , [], mexFlag );
    aux = isequal ( codeObject.mexFlag ,  mexFlag );
end

assert( aux );

%% Test 4: Check Encode-Decode Methods (Mex Flag True):
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
mexFlag = true; 
codeObject = modem.ConvolutionalCode ( polyGenerator , [] , mexFlag );
packets= randi( [ 0 , 1 ], 1, packetSize );

encodedArray = codeObject.encode( packets );
decodedArray = codeObject.decode( encodedArray );

aux = isequal ( packets, decodedArray);


assert(aux);

%% Test 5: Check Encoder Impulse Response.
polyGenerator = [10 13]; % Non Recursive Polynomial.
packetSize = 300;
mexFlag = true; 
codeObject = modem.ConvolutionalCode ( polyGenerator , [] , mexFlag );

[ inputBits , outputBits ] = size( polyGenerator );
codeRate = inputBits / outputBits; % Set Code Rate
octPolyGen = polyGenerator;
binPolyGen = cell( inputBits , 1 );


% Set Binary Generator Polynomial
for input = 1 : inputBits;
    % Polynomial for each input Bit:
    binPolyGen{ input } = de2bi ( base2dec( num2str( octPolyGen (input, : )' ), 8 ), 'left-msb');
    % Number of State Registers for this each input bit:
    numOfRegisters( 1 , input  ) = length( binPolyGen{ input }  ) - 1;
end

impulseResponseIndex = randi( [0 packetSize*0.8], 1, 1);

inputVector = zeros( 1 , packetSize);
inputVector( impulseResponseIndex ) = 1;

encodedArray = codeObject.encode( inputVector );

% Auxiliar Variable to check if all other outputs are equal to 0.
zeroIndexes = 1 : length( encodedArray ); 
outputCount = 0;
aux = true;
while (aux && outputCount < outputBits )
    outputCount = outputCount + 1;
    index = ( impulseResponseIndex - 1 ) / codeRate + outputCount;
    registerCount = 0;
    while( aux && registerCount < numOfRegisters + 1 )
        registerCount = registerCount + 1;
        aux = isequal( encodedArray( index ), binPolyGen{ 1 } ( outputCount, registerCount ) );
        zeroIndexes ( find( zeroIndexes == index ) ) = []; % This bit is not part of all zeros output
                                                           % It is impacted by the impulse response
        index = index + outputBits;
    end
end

index = 0;
while ( aux && index < length( zeroIndexes ) )
    index = index + 1;
    aux = isequal ( encodedArray ( zeroIndexes ( index ) ), 0 );
end

assert ( aux );

%% Test 6: Check Encode-Decode Methods (Mex Flag False):
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
mexFlag = false; 
codeObject = modem.ConvolutionalCode ( polyGenerator , [] , mexFlag );
packets= randi( [ 0 , 1 ], 1, packetSize );

encodedArray = codeObject.encode( packets );
decodedArray = codeObject.decode( encodedArray );

aux = isequal ( packets, decodedArray);


assert(aux);