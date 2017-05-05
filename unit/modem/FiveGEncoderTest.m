%FIVEGENCODERTEST function tests the FIVEGENCODER class
%   This function test the creation of FiveGEncoder Class
%
%   Syntax: FiveGEncoderTest
%
%   Author: Rafhael Amorim (RA)
%   Work Address: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 9 Jul 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class methods. Convolutional Code. MCS = 0
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 0;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 2: check class methods. Convolutional Code. MCS = 1
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 1;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 3: check class methods. Convolutional Code. MCS = 2
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 2;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 4: check class methods. Convolutional Code. MCS = 3
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 3;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 5: check class methods. Convolutional Code. MCS = 4
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 4;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 6: check class methods. Convolutional Code. MCS = 5
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 5;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 7: check class methods. Convolutional Code. MCS = 6
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 6;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 8: check class methods. Convolutional Code. MCS = 7
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 7;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 9: check class methods. Convolutional Code. MCS = 8
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 8;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');


% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 10: check class methods. Convolutional Code. MCS = 9
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
% Set Test Parameters:
FIVEG.MCS = 9;
FIVEG.CODE.TYPE = enum.modem.CodeType.CONVOLUTIONAL;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 11: check class methods. Turbo Code. MCS = 0
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 0;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 12: check class methods. Turbo Code. MCS = 1
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 1;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 13: check class methods. Turbo Code. MCS = 2
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 2;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 14: check class methods. Turbo Code. MCS = 3
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 3;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 15: check class methods. Turbo Code. MCS = 4
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 4;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 16: check class methods. Turbo Code. MCS = 5
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 5;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 17: check class methods. Turbo Code. MCS = 6
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 6;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 18: check class methods. Turbo Code. MCS = 7
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 7;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 19: check class methods. Turbo Code. MCS = 8
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 8;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 20: check class methods. Turbo Code. MCS = 9
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 9;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 21: check class methods. Turbo Code. MCS = 10
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 10;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 22: check class methods. Turbo Code. MCS = 11
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 11;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 23: check class methods. Turbo Code. MCS = 12
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 12;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 24: check class methods. Turbo Code. MCS = 13
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 13;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 25: check class methods. Turbo Code. MCS = 14
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 14;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 26: check class methods. Turbo Code. MCS = 15
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 15;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );

%% Test 27: check class methods. Turbo Code. MCS = 16
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;

% Set Test Parameters:
FIVEG.MCS = 15;
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;

FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
rndSeed = RandStream('mt19937ar');

% Create Source:
sourceObject = source.Source( rndSeed , FIVEG.TRANSPORT_BLOCK_SIZE_BITS );
% Create Encoder:
encoderObject = modem.FiveGEncoder(FIVEG, rndSeed);

% Auxiliary Variable:
numberOfMappedSymbols = sourceObject.targetPacketSize_bits * 5 * 5;

packets = sourceObject.generatePackets( numberOfMappedSymbols, FIVEG.MODULATION_ORDER, ...
                                   encoderObject.codeRate );

encodedArray  = encoderObject.encode( packets );

% Arbitrary LLR Atttribution to test the decoder:
packetsRx = ( encodedArray * 2 ) - 1;

decodedPackets = encoderObject.decode( packetsRx );

numOfErrors = sourceObject.calculateErrors( decodedPackets );

assert( numOfErrors == 0 );