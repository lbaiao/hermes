%ModemTest function tests the Modem Class
%   This script contains the tests for a Modem Class
%
%   Syntax: ModemTest
%
%   Author: Lilian Freitas (LCF), Rafhael Amorim (RA)   
%   Work Address: INDT Manaus
%   E-mail: < lilian.freitas, rafhael.amorim >@indt.org.br
%   History:
%       v1.0 3 Mar 2015 - (LCF, RA) created 
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check Modem class constructor
% Test constructor for Modem Class with empty initialization of Modem
% Attributes
instanceModem = modem.Modem;
assert( isa ( instanceModem, 'modem.Modem' ) );

%% Test 2: Check Modem Constructor with LTE OFDM Assignment
%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );

assert( isa ( instanceModem, 'modem.Modem' ) );

%% Test 3: Check if Source attribute is from class Source
%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );

assert( isa ( instanceModem.source, 'source.Source' ) );
% 
%% Test 4: check if Source attribute is from Source LTE Class

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );

assert( isa ( instanceModem.source, 'source.LteSource' ) );

%% Test 5: check number of antennas in Modem

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );

assert( length(instanceModem.antenna ) == MODEM.NUMBER_OF_ANTENNAS );

%% Test 6: check channelCode attribute

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );

assert( isa(instanceModem.channelCode, 'modem.ChannelCode' ) );

%% Test 7: check channelMapper for LTE MODEM

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );

assert( isa(instanceModem.mapper, 'modem.LteMapper' ) );

%% Test 8: check if innerTransceiver is a modulator for Tx Modem

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );

assert( isa(instanceModem.innerTransceiver, 'modem.BlockModulation' ) );

%% Test 9: check if innerTransceiver is a LTE modulator for LTE OFDM Tx Modem

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );

assert( isa(instanceModem.innerTransceiver, 'modem.LteOfdmModulation' ) );

%% Test 10: check if innerTransceiver is a Receiver for RxModem

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;
MODEM.LLR_METHOD = enum.modem.LlrMethod.LINEAR_APPROXIMATION;
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
MODEM.CHANNEL_ESTIMATION = enum.modem.ChannelEstimation.PERFECT;
MODEM.EQUALIZATION = enum.modem.Equalization.ZF;
% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
txModem = modem.Modem( MODEM, LTE, randomStream, false  );

rxFlag = true;
instanceModem = modem.Modem( MODEM, txModem, randomStream, rxFlag  );

assert( isa(instanceModem.innerTransceiver, 'modem.InnerReceiver' ) );


%% Test 12: check if innerTransceiver is a LTE  OFDM Inner Receiver for Rx Modem for LTE OFDMA Class

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;
MODEM.LLR_METHOD = enum.modem.LlrMethod.LINEAR_APPROXIMATION;
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
MODEM.CHANNEL_ESTIMATION = enum.modem.ChannelEstimation.PERFECT;
MODEM.EQUALIZATION = enum.modem.Equalization.ZF;
% create randomStream objects
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
txModem = modem.Modem( MODEM, LTE, randomStream, false  );

rxFlag = true;
instanceModem = modem.Modem( MODEM, txModem, randomStream, rxFlag  );

assert( isa(instanceModem.innerTransceiver, 'modem.LteInnerReceiver' ) );

%% Test 13: check if RxSampler is set for Rx Modems

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;
MODEM.LLR_METHOD = enum.modem.LlrMethod.LINEAR_APPROXIMATION;
% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
MODEM.CHANNEL_ESTIMATION = enum.modem.ChannelEstimation.PERFECT;
MODEM.EQUALIZATION = enum.modem.Equalization.ZF;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end

txModem = modem.Modem( MODEM, LTE, randomStream, false  );

%Load rxFlag
rxFlag = true;
instanceModem = modem.Modem( MODEM, txModem, randomStream, rxFlag  );

assert( isa(instanceModem.rxSampler, 'modem.RxSampler' ) );


%% Test 14: check if thermalNoise is set for Rx Modems

%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;
MODEM.LLR_METHOD = enum.modem.LlrMethod.LINEAR_APPROXIMATION;
% create randomStream objects
MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
MODEM.CHANNEL_ESTIMATION = enum.modem.ChannelEstimation.PERFECT;
MODEM.EQUALIZATION = enum.modem.Equalization.ZF;
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end

txModem = modem.Modem( MODEM, LTE, randomStream, false  );

%Load rxFlag
rxFlag = true;
instanceModem = modem.Modem( MODEM, txModem, randomStream, rxFlag  );

assert( isa(instanceModem.thermalNoise, 'channel.Noise' ) );

%% Test 15: Test setLink Method.
%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,27]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
MODEM.CHANNEL_ESTIMATION = enum.modem.ChannelEstimation.PERFECT;
MODEM.EQUALIZATION = enum.modem.Equalization.ZF;
% create randomStream objectshel
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );
linkModem = randi(10,1);
instanceModem.setLink( linkModem )
assert( all( [ linkModem ] == [instanceModem.link] ) );

%% Test 16: Test transmitFrame method for LTE Modem.
%Load LTE Parameters
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0,26]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);


%Load Modem Settings
MODEM.TECHNOLOGY = enum.Technology.LTE_OFDMA;
MODEM.NUMBER_OF_ANTENNAS = 1;
MODEM.ANTENNA_POSITION = [0 0 0];
MODEM.CARRIER_FREQUENCY = 2.5e9;

MODEM.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
MODEM.CHANNEL_ESTIMATION = enum.modem.ChannelEstimation.PERFECT;
MODEM.EQUALIZATION = enum.modem.Equalization.ZF;
% create randomStream objectshel
indexes = [ enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME, ...
                                enum.RandomSeeds.ENCODER];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 10 * length( index ) );
end
%Load rxFlag
rxFlag = false;
instanceModem = modem.Modem( MODEM, LTE, randomStream, rxFlag  );
frame = instanceModem.transmitFrame();
numberOfSlots = LTE.NUMBER_OF_SLOTS_PER_SUBFRAME;
numberOfSymbols = LTE.OFDM_SYMBOLS_PER_SUBFRAME;
samples = numberOfSymbols * instanceModem.innerTransceiver.fftSize;
samples = samples  + numberOfSlots * instanceModem.innerTransceiver.cyclicPrefixLengthFirstSymbol;
samples = samples + ( numberOfSlots * ( instanceModem.innerTransceiver.ofdmSymbolsPerSlot - 1 ) ...
    * instanceModem.innerTransceiver.cyclicPrefixLength );
%Check if transmitted frame has the expected number of time samples.
assert ( length(frame) == samples ); 
