%LTESOURCETEST function tests the LteSource Class
%   This script test the creation of the LteSource Class
%
%   Syntax: LteSourceTest
%
%   Author: Artur Rodrigues (AR), Rafhael Medeiros de Amorim (RMA),
%           Fadhil Firyaguna (FF)
%   Work Adress: INDT Brasilia
%   E-mail: < artur.rodrigues, rafhael.amorim >@indt.org.br,
%   fadhil.firyaguna@indt.org
%   History:
%       v1.0 23 Mar 2015 - created
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
lteSimulationSettings;
LTE.MCS = randi([0,20]);
lteParamTable = parameterCheck.loadLteParametersTable;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable );
sourceObject = source.LteSource( rnd, LTE );

assert( isa ( sourceObject, 'source.LteSource' ) );

%% Test 2: check generatePackets method for number of Packets
% Test if generated Packets have Class property of numberOfPackets
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
lteSimulationSettings;
LTE.MCS = randi([0,20]);
lteParamTable = parameterCheck.loadLteParametersTable;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable );

availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;


sourceObject = source.LteSource( rnd, LTE );

%Number of Packets 
numOfPackets = floor( LTE.N_PRB / LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK );

packets = sourceObject.generatePackets( availableDataSymbols, ...
                                        modulationOrder, ...
                                        codeRate );

assert( isequal ( size( packets, 1 ) , numOfPackets ) == 1 );

%% Test 3: check generatePackets method for size of Packets
% Test if generated Packets have Class property of packetSize_bits
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;
lteSimulationSettings;
LTE.MCS = randi([0,20]);
lteParamTable = parameterCheck.loadLteParametersTable;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable );

sourceObject = source.LteSource( rnd, LTE );
packets = sourceObject.generatePackets( availableDataSymbols, ...
                                        modulationOrder, ...
                                        codeRate );
checkedPackets = 0;
mcs = LTE.MCS;
enable256qam = LTE.ENABLE256QAM;
transportBlockSizeIndex = lookupTables.modem.lte.getTbsIndex( mcs, enable256qam);
numOfPrbs = LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK;
%Transport Block Index
transportBlockSize = ...
    lookupTables.modem.lte.getTransportBlockSize( transportBlockSizeIndex , numOfPrbs );
expectedPacketSize = transportBlockSize;

for cnt = 1 : sourceObject.numberOfPackets
    if ( length( packets {cnt} )  == expectedPacketSize )
        checkedPackets = checkedPackets + 1;
    end
end

assert( isequal ( checkedPackets , sourceObject.numberOfPackets ) == 1 );

%% Test 4: check calculateErrors method
% Test if received Packets have expected number of bit errors
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
lteSimulationSettings;
LTE.MCS = randi([0,20]);
lteParamTable = parameterCheck.loadLteParametersTable;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable );

availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;

% generate packets
sourceObject = source.LteSource( rnd, LTE );
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
[ numBitErrors, numPacketErrors ] = sourceObject.calculateErrors ( rxBits );

assert( isequal( numBitErrors, 1 ) == 1 );
    
%% Test 5: check calculateErrors method
% Test if received Packets have expected number of packet errors
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
lteSimulationSettings;
LTE.MCS = randi([0,20]);
lteParamTable = parameterCheck.loadLteParametersTable;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable );

availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;

% generate packets
sourceObject = source.LteSource( rnd, LTE );
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
