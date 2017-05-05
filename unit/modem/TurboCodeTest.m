%TURBOCODETEST script tests the TurboCode class
% This function test the creation of a TurboCode object and its
% methods
%
%   Syntax: TurboCodeTest
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 17 Jun 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check class constructor without Mex Flag
% Test constructor of Convolutional Channel Code Class
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;

codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );

assert( isa ( codeObject, 'modem.TurboCode' ) );

%% Test 2: Check Class Code Rate
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
numOfEncoders = size( polyGenerator, 1 );
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );

assert( isequal ( codeObject.codeRate , 1/(numOfEncoders + 1 ) ) );

 
%% Test 3: Check setInterleaver Method:
% Check for interleaver sequence only.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
numOfEncoders = size( polyGenerator, 1 );
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );

packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
codeObject.setInterleaver( interleaver, [] );

assert( isequal ( codeObject.interleavers , interleaver ) );

%% Test 4: Check setInterleaver Method #2:
% Check if deinterleaver sequence calculated by the method is correct.
polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
numOfEncoders = size( polyGenerator, 1 );
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );

packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
codeObject.setInterleaver( interleaver, [] );
[~ , deinterleaver ]= sort( interleaver, 'ascend');
assert( isequal ( codeObject.deinterleavers , deinterleaver ) );

%% Test 5: Check setInterleaver Method #3:
% Check if it is possible to set interleaver and deinterleaver sequence
% together.

polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
numOfEncoders = size( polyGenerator, 1 );
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );

packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
[~ , deinterleaver ]= sort( interleaver, 'ascend');

codeObject.setInterleaver( interleaver, deinterleaver );

aux  = isequal (codeObject.interleavers, interleaver );

if aux
    aux = isequal (codeObject.deinterleavers, deinterleaver );
end

assert( aux );

%% Test 6: Check encode-decode method (No Noise).
% Check if it is possible to set interleaver and deinterleaver sequence
% together.

polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
numOfEncoders = size( polyGenerator, 1 );
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );

packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );
[ ~, interleaver ] = sort( randn ( 1, packetSize ) );
[~ , deinterleaver ]= sort( interleaver, 'ascend');

codeObject.setInterleaver( interleaver, deinterleaver );

encodedArray = codeObject.encode( packet );

encodedArrayTx = ( encodedArray * 2 ) - 1;
decodedArray = codeObject.decode( encodedArrayTx );

assert( all ( packet == decodedArray) );


%% Test 7: Check encode-decode method ( Noisy Channel).
% Check if it is possible to set interleaver and deinterleaver sequence
% together.

polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
numOfEncoders = size( polyGenerator, 1 );
codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag );
seed = 100;
rnd = RandStream( 'mt19937ar', 'seed', seed );
ebno_dB = 1;                          
packetSize = 6000;

[ ~, interleaver ] = sort( rnd.randn ( 1, packetSize ) );
[~ , deinterleaver ]= sort( interleaver, 'ascend');

codeObject.setInterleaver( interleaver, deinterleaver );

% Test for Several Packets:
numOfPackets = 100;
numOfErrors = 0;
for counter = 1: numOfPackets
    packet = rnd.randi( [ 0 , 1 ] , 1 , packetSize );
    encodedArray = codeObject.encode( packet );
    % Emulate QPSK-Generic Constellation:
    Symbols = reshape(encodedArray,2,[]);
    Symbols = (Symbols*2-1)/sqrt(2);
    Symbols = Symbols(1,:) + i*Symbols(2,:);
    % Calculate Symbol Energy:
    Energy = sum( Symbols .* conj(Symbols) );
    EnergyBit = Energy / packetSize;
    % Calculate Noise:
    ebn0 = 10^( ebno_dB / 10 );
    
    no = EnergyBit / ebn0;
    noise = ( rnd.randn(size(Symbols)) + i * rnd.randn(size(Symbols))) * sqrt(no/2);
    noisy = Symbols + noise;
    
    llr = [ real(noisy); imag(noisy)];
    llr = reshape(llr, 1,[]);
    decodedBits = codeObject.decode( llr );
    numOfErrors = numOfErrors +  sum( bitxor( decodedBits , packet ) );
end

ber = numOfErrors / ( numOfPackets * packetSize );


assert( ber < 5*10^-4 );

%% Test 8: Check createInterleaver Method

polyGenerator = [13 15; 13 15];
feedback = [13; 13];
numOfIterations = 5;
interleavers = [];
mexFlag = true;
rnd = RandStream( 'mt19937ar' );

codeObject = modem.TurboCode ( polyGenerator , feedback, numOfIterations, ...
                               interleavers, mexFlag, rnd );

                           
packetSize = 6000;
packet = randi( [ 0 , 1 ] , 1 , packetSize );

codeObject.createInterleaver( packetSize );
% Check if the interleaver sequence is being applied:
indexes = 1:packetSize;
aux = any( codeObject.interleavers ~= packetSize );
% Check if it is a valid interleaver
if aux
    [ indexesTemp , deinterleaverTemp ] = sort( codeObject.interleavers , 'ascend' );
    aux = all( indexesTemp == indexes );
end
%Check deinterleaver Sequence:
assert( all ( deinterleaverTemp == codeObject.deinterleavers) );


