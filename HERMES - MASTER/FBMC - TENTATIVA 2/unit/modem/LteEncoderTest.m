%LTEENCODERTEST function tests the MODEM.LTEENCODER Class
%
%   Syntax: LteEncoderTest
%
%   Author: Rafhael Amorim (RA)
%   Work Address: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%        v2.0 17  June 2015 - (RA) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor
% Test constructor of LteEncoderClass
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0 26]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rnd = RandStream('mt19937ar');

numberOfTxAntennas = 1 ;
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas );

encoderObject = modem.LteEncoder( LTE , frameObject, rnd );

assert( isa ( encoderObject, 'modem.LteEncoder' ) );


%% Test2: Check the number of Code Blocks
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0 26]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rnd = RandStream('mt19937ar');

numberOfTxAntennas = 1 ;
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas );

encoderObject = modem.LteEncoder( LTE , frameObject, rnd );

mcs = LTE.MCS;
enable256qam = LTE.ENABLE256QAM;
transportBlockSizeIndex = lookupTables.modem.lte.getTbsIndex( mcs, enable256qam);
numOfPrbs = LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK; % Number of PRBs per Transport Block
transportBlockSize = ...
    lookupTables.modem.lte.getTransportBlockSize( transportBlockSizeIndex , numOfPrbs ); % get TBS

[ codeBlockSizes , f1, f2] = lookupTables.modem.lte.turboCodeInterleaving();
crcSize = LTE.NUMBER_OF_CRC_BITS;
% Calculate the number of code blocks:
numberOfCodeBlocks = ceil( transportBlockSize ...
                    / (max( codeBlockSizes ) + crcSize) );
assert( isequal( numberOfCodeBlocks , encoderObject.numberOfCodeBlocks ) );

%% Test3: Check Encode-Decothe Methods ( No Noise )
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0 26]);
LTE.MCS = 0;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

seed = 100;
rnd = RandStream( 'mt19937ar', 'seed', seed );

numberOfTxAntennas = 1 ;
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas );

encoderObject = modem.LteEncoder( LTE , frameObject, rnd );
%Packet Size: 
mcs = LTE.MCS;
enable256qam = LTE.ENABLE256QAM;
transportBlockSizeIndex = lookupTables.modem.lte.getTbsIndex( mcs, enable256qam);
numOfPrbs = LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK; % Number of PRBs per Transport Block
transportBlockSize = ...
    lookupTables.modem.lte.getTransportBlockSize( transportBlockSizeIndex , numOfPrbs ); % get TBS
                       
modulationOrder = lookupTables.modem.lte.getModulationOrder( mcs, enable256qam );
% Test for Several Packets:
numOfPackets = floor( LTE.N_PRB / LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK );
numOfSimulations = 10;
numOfErrors = 0;

sourceObject = source.LteSource( rnd, LTE );
mapperObject = modem.LteMapper( modulationOrder );


for simul = 1: numOfSimulations
    packets = sourceObject.generatePackets(2, [], []);
    encodedArray = encoderObject.encode( packets );
    % Emulate QPSK-Generic Constellation:
    Symbols = mapperObject.map( encodedArray );
    llr = mapperObject.calculateLlr( Symbols );
    auxTemp = frameObject.fillFrame( Symbols );
    llr ( abs( llr ) == inf ) = 999 * sign( llr );
    decodedBits = encoderObject.decode( llr );
    numOfErrors = sourceObject.calculateErrors( decodedBits );
    frameObject.resetFrame();
end
ber = numOfErrors / ( numOfPackets * numOfSimulations * transportBlockSize );

assert( ber == 0);