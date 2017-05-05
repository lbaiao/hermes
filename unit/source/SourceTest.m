%SOURCETEST function tests the Source Class
%   This script test the creation of the Source Class
%
%   Syntax: SourceTest
%
%   Author: Erika Almeida (EA) 
%
%   Work Adress: INDT Brasilia
%   E-mail: < erika.almeida >@indt.org.br,
%   fadhil.firyaguna@indt.org
%   History:
%       v2.0 26 May 2015 - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check Class constructor
% Test constructor of LteSource Class
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
packetSize = randi([0,1500]);
sourceObject = source.Source( rnd, packetSize );

assert( isa ( sourceObject, 'source.Source' ) );

%% Test 2: check generatePackets method for number of Packets
% Test if generated Packets have Class property of numberOfPackets
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
packetSize = randi([0,1500]);
availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;

sourceObject = source.Source( rnd, packetSize );

expectedPackets = floor( availableDataSymbols * log2( modulationOrder) * ...
                         codeRate / packetSize );

packets = sourceObject.generatePackets( availableDataSymbols, ...
                                        modulationOrder, ...
                                        codeRate );

assert( isequal ( size( packets, 1 ) , expectedPackets ) == 1 );


%% Test 3: check calculateErrors method
% Test if received Packets have expected number of bit errors
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
packetSize = randi([0,1500]);
availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;

% generate packets
sourceObject = source.Source( rnd, packetSize );
packets = sourceObject.generatePackets( availableDataSymbols, ...
                                        modulationOrder, ...
                                        codeRate );

rxBits = [];
for packetIndex = 1 : length( packets )
    rxBits = [ rxBits; packets{ packetIndex }];
end

% generate 1 bit error in any packet
errorPos = randi( length( rxBits ),1  );
errorVector = zeros(length( rxBits ),1 );
errorVector( errorPos ) = 1;
rxBits = bitxor( rxBits, errorVector );

% calculate errors
[ numBitErrors ] = sourceObject.calculateErrors ( rxBits );

assert( isequal( numBitErrors, 1 ) == 1 );
    
%% Test 5: check calculateErrors method
% Test if received Packets have expected number of packet errors
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
packetSize = randi([0,1500]);
availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;

% generate packets
sourceObject = source.Source( rnd, packetSize );
packets = sourceObject.generatePackets( availableDataSymbols, ...
                                        modulationOrder, ...
                                        codeRate );

rxBits = [];
for packetIndex = 1 : length( packets )
    rxBits = [ rxBits; packets{ packetIndex }];
end

% generate 1 bit error in any packet
errorPos = randi( [ 1, length( rxBits ) ] );
errorVector = zeros( length( rxBits ), 1 );
errorVector( errorPos ) = 1;
rxBits = bitxor( rxBits, errorVector );

% calculate errors
[ numBitErrors, numPacketErrors ] = sourceObject.calculateErrors ( rxBits );

assert( isequal( numPacketErrors, 1 ) == 1 );
