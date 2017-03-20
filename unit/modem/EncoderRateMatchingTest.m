%ENCODERRATEMATCHINGTEST script tests the EncoderRateMatching class
% This function test the creation of a EncoderRateMatching object and its
% methods
%
%   Syntax: EncoderRateMatching
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 30 June 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check class constructor
% Test constructor using a ConvolutionalCode. Code Rate = 1/2
polyGenerator = [10 13];
feedback = [];
codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );

expectedCodeRate = 1/2;

rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

puncturePattern = lookupTables.modem.wifi.getPuncturePattern( expectedCodeRate );
assert( rateMatchingObject.puncturePattern == puncturePattern );

%% Test 2: check class constructor
% Test constructor using a ConvolutionalCode. Code Rate = 3/4
polyGenerator = [10 13];
feedback = [];
codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );

expectedCodeRate = 3/4;

rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

puncturePattern = lookupTables.modem.wifi.getPuncturePattern( expectedCodeRate );
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 3: check class constructor
% Test constructor using a ConvolutionalCode. Code Rate = 2/3
polyGenerator = [10 13];
feedback = [];
codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );

expectedCodeRate = 3/4;

rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

puncturePattern = lookupTables.modem.wifi.getPuncturePattern( expectedCodeRate );
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 4: check class constructor
% Test constructor using a ConvolutionalCode. Code Rate = 2/3
polyGenerator = [10 13];
feedback = [];
codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );

expectedCodeRate = 5/6;

rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

puncturePattern = lookupTables.modem.wifi.getPuncturePattern( expectedCodeRate );
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 5: check class constructor
% Test constructor using a Dummy Channel Code. Code Rate = 1
codeObject = modem.ChannelCode;

expectedCodeRate = 1;
puncturePattern = 1;

rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );
assert( rateMatchingObject.puncturePattern == puncturePattern );

%% Test 6: check class constructor
% Test constructor using a User Defined Puncture Pattern.
polyGenerator = [10 13];
feedback = [];
codeObject = modem.ChannelCode;

expectedCodeRate = 1;
puncturePattern = [ 1 1 0 1; 0 1 0 1];

rateMatchingObject = modem.EncoderRateMatching( puncturePattern );
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 7: check method puncturing for Conv. Encoder. Rate: 1/2
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
packets= randi( [ 0 , 1 ], 1, packetSize );
expectedCodeRate = 1/2;

codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

encodedArray = codeObject.encode( packets );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

assert( length( puncturedArray ) == packetSize / expectedCodeRate  );

%% Test 8: check method puncturing for Conv. Encoder. Rate: 2/3
% Test constructor using a User Defined Puncture Pattern.
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
packets= randi( [ 0 , 1 ], 1, packetSize );
expectedCodeRate = 2/3;

codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

encodedArray = codeObject.encode( packets );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

assert( length( puncturedArray ) == packetSize / expectedCodeRate  );

%% Test 9: check method puncturing for Conv. Encoder. Rate: 3/4
% Test constructor using a User Defined Puncture Pattern.
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
packets= randi( [ 0 , 1 ], 1, packetSize );
expectedCodeRate = 3/4;

codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

encodedArray = codeObject.encode( packets );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

assert( length( puncturedArray ) == packetSize / expectedCodeRate  );

%% Test 10: check method puncturing for Conv. Encoder. Rate: 5/6
% Test constructor using a User Defined Puncture Pattern.
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
packets= randi( [ 0 , 1 ], 1, packetSize );
expectedCodeRate = 5/6;

codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

encodedArray = codeObject.encode( packets );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

assert( length( puncturedArray ) == packetSize / expectedCodeRate  );

%% Test 11: check method depuncturing for Conv. Encoder. Rate: 1/2
% Test constructor using a User Defined Puncture Pattern.
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
packets= randi( [ 0 , 1 ], 1, packetSize );
expectedCodeRate = 1/2;

codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

encodedArray = codeObject.encode( packets );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );
llrVector = sign( puncturedArray * 2 - 1 );
depuncturedArray = rateMatchingObject.depuncturing( llrVector );
depuncturedArray = depuncturedArray';

decodedArray = codeObject.decode( depuncturedArray );
assert( all( packets == decodedArray )  );

%% Test 12: check method depuncturing for Conv. Encoder. Rate: 2/3
% Test constructor using a User Defined Puncture Pattern.
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
packets= randi( [ 0 , 1 ], 1, packetSize );
expectedCodeRate = 2/3;

codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

encodedArray = codeObject.encode( packets );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );
llrVector = sign( puncturedArray * 2 - 1 );
depuncturedArray = rateMatchingObject.depuncturing( llrVector );
depuncturedArray = depuncturedArray';

decodedArray = codeObject.decode( depuncturedArray );
assert( all( packets == decodedArray )  );

%% Test 12: check method depuncturing for Conv. Encoder. Rate: 3/4
% Test constructor using a User Defined Puncture Pattern.
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
packets= randi( [ 0 , 1 ], 1, packetSize );
expectedCodeRate = 3/4;

codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

encodedArray = codeObject.encode( packets );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );
llrVector = sign( puncturedArray * 2 - 1 );
depuncturedArray = rateMatchingObject.depuncturing( llrVector );
depuncturedArray = depuncturedArray';

decodedArray = codeObject.decode( depuncturedArray );
assert( all( packets == decodedArray )  );

%% Test 13: check method depuncturing for Conv. Encoder. Rate: 5/6
% Test constructor using a User Defined Puncture Pattern.
polyGenerator = [10 13];
feedback = [];
packetSize = 300;
packets= randi( [ 0 , 1 ], 1, packetSize );
expectedCodeRate = 5/6;

codeObject = modem.ConvolutionalCode ( polyGenerator , feedback  );
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

encodedArray = codeObject.encode( packets );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );
llrVector = sign( puncturedArray * 2 - 1 );
depuncturedArray = rateMatchingObject.depuncturing( llrVector );
depuncturedArray = depuncturedArray';

decodedArray = codeObject.decode( depuncturedArray );
assert( all( packets == decodedArray )  );

%% Test 14: Check method depuncturing for Dummy Encoder.
codeObject = modem.ChannelCode;
packetSize = 300;
packets = cell( 1 );
packets{ 1 } = randi( [ 0 , 1 ], 1, packetSize );

expectedCodeRate = 1;

rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );
encodedArray = codeObject.encode( packets{ 1 } );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

assert( length( puncturedArray ) == packetSize / expectedCodeRate  );


%% Test 15: Check method depuncturing for Dummy Encoder.
codeObject = modem.ChannelCode;
packetSize = 300;
packets = cell( 1 );
packets{1} = randi( [ 0 , 1 ], 1, packetSize );

expectedCodeRate = 1;

rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );
encodedArray = codeObject.encode( packets{ 1 } );
puncturedArray = rateMatchingObject.puncturing( encodedArray' );
llrVector = sign( puncturedArray * 2 - 1 );
depuncturedArray = rateMatchingObject.depuncturing( llrVector );
depuncturedArray = depuncturedArray';

decodedArray = codeObject.decode( depuncturedArray );
assert( all( packets{ 1 } == decodedArray )  );

%% Test 16: check constructor for tubo code Rate: 1/3
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 1/3;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

%Expected Output:
puncturePattern = lookupTables.modem.fiveG.getTurboPuncturePattern( expectedCodeRate );

% Assert:
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 17: check constructor for tubo code Rate 1/2
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 1/2;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

%Expected Output:
puncturePattern = lookupTables.modem.fiveG.getTurboPuncturePattern( expectedCodeRate );

% Assert:
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 18: check constructor for tubo code Rate 2/5
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 2/5;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

%Expected Output:
puncturePattern = lookupTables.modem.fiveG.getTurboPuncturePattern( expectedCodeRate );

% Assert:
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 19: check constructor for tubo code Rate 2/3
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 2/3;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

%Expected Output:
puncturePattern = lookupTables.modem.fiveG.getTurboPuncturePattern( expectedCodeRate );

% Assert:
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 20: check constructor for tubo code Rate 3/4
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 3/4;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

%Expected Output:
puncturePattern = lookupTables.modem.fiveG.getTurboPuncturePattern( expectedCodeRate );

% Assert:
assert( isequal( rateMatchingObject.puncturePattern , puncturePattern  ) );

%% Test 21:  check puncturing method for tubo code Rate: 1/3
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 1/3;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

% Create Packet
packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );

%Create Interleaver:
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
[~ , deinterleaver ]= sort( interleaver, 'ascend');
codeObject.setInterleaver( interleaver, deinterleaver );

%Encode
encodedArray = codeObject.encode( packet );

% Puncture:
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

% Check if the punctured Vector has correct size:
aux = length( puncturedArray ) == packetSize / expectedCodeRate ;
% LLR:
receivedArray = ( puncturedArray * 2 ) - 1;

% Depuncture:
depuncturedArray = rateMatchingObject.depuncturing( receivedArray );

% Decode:
depuncturedArray = depuncturedArray';
decodedArray = codeObject.decode( depuncturedArray );

%Assert:
assert( all( packet == decodedArray )  );

%% Test 22:  check puncturing method for tubo code Rate: 1/2
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 1/2;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

% Create Packet
packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );

%Create Interleaver:
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
[~ , deinterleaver ]= sort( interleaver, 'ascend');
codeObject.setInterleaver( interleaver, deinterleaver );

%Encode
encodedArray = codeObject.encode( packet );

% Puncture:
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

% Check if the punctured Vector has correct size:
aux = length( puncturedArray ) == packetSize / expectedCodeRate ;
% LLR:
receivedArray = ( puncturedArray * 2 ) - 1;

% Depuncture:
depuncturedArray = rateMatchingObject.depuncturing( receivedArray );

% Decode:
depuncturedArray = depuncturedArray';
decodedArray = codeObject.decode( depuncturedArray );

%Assert:
assert( all( packet == decodedArray )  );

%% Test 23:  check puncturing method for tubo code Rate: 2/5
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 2/5;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

% Create Packet
packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );

%Create Interleaver:
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
[~ , deinterleaver ]= sort( interleaver, 'ascend');
codeObject.setInterleaver( interleaver, deinterleaver );

%Encode
encodedArray = codeObject.encode( packet );

% Puncture:
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

% Check if the punctured Vector has correct size:
aux = length( puncturedArray ) == packetSize / expectedCodeRate ;
% LLR:
receivedArray = ( puncturedArray * 2 ) - 1;

% Depuncture:
depuncturedArray = rateMatchingObject.depuncturing( receivedArray );

% Decode:
depuncturedArray = depuncturedArray';
decodedArray = codeObject.decode( depuncturedArray );

%Assert:
assert( all( packet == decodedArray )  );

%% Test 24:  check puncturing method for tubo code Rate: 2/3
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 2/3;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

% Create Packet
packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );

%Create Interleaver:
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
[~ , deinterleaver ]= sort( interleaver, 'ascend');
codeObject.setInterleaver( interleaver, deinterleaver );

%Encode
encodedArray = codeObject.encode( packet );

% Puncture:
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

% Check if the punctured Vector has correct size:
aux = length( puncturedArray ) == packetSize / expectedCodeRate ;
% LLR:
receivedArray = ( puncturedArray * 2 ) - 1;

% Depuncture:
depuncturedArray = rateMatchingObject.depuncturing( receivedArray );

% Decode:
depuncturedArray = depuncturedArray';
decodedArray = codeObject.decode( depuncturedArray );

%Assert:
assert( all( packet == decodedArray )  );

%% Test 25:  check puncturing method for tubo code Rate: 3/4
% Test constructor using a User Defined Puncture Pattern.

% Create Code Object.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
                           
% Create Rate Matching Object: 
expectedCodeRate = 3/4;
rateMatchingObject = modem.EncoderRateMatching( expectedCodeRate, codeObject );

% Create Packet
packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );

%Create Interleaver:
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
[~ , deinterleaver ]= sort( interleaver, 'ascend');
codeObject.setInterleaver( interleaver, deinterleaver );

%Encode
encodedArray = codeObject.encode( packet );

% Puncture:
puncturedArray = rateMatchingObject.puncturing( encodedArray' );

% Check if the punctured Vector has correct size:
aux = length( puncturedArray ) == packetSize / expectedCodeRate ;
% LLR:
receivedArray = ( puncturedArray * 2 ) - 1;

% Depuncture:
depuncturedArray = rateMatchingObject.depuncturing( receivedArray );

% Decode:
depuncturedArray = depuncturedArray';
decodedArray = codeObject.decode( depuncturedArray );

%Assert:
assert( all( packet == decodedArray )  );