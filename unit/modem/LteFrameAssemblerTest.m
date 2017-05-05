%LTEFRAMEASSEMBLERTest function tests the LTEFRAMEASSEMBLER Class
%   This function test the creation of LteFrameAssembler class
%
%   Syntax: LteFrameAssemblerTest
%
%   Author: Rafhael Amorim (RA)
%   Work Address: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%        v1.0 6 Mar 2015 - (RA) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor
% Test constructor of LteFrameAssemblerClass
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rnd = RandStream('mt19937ar');

frameObject = modem.LteFrameAssembler(LTE, rnd);

assert( isa ( frameObject, 'modem.LteFrameAssembler' ) );

%% Test 2: check SetNumberOfAntennas Method for Tx Antennas
% Test SetNumberOfAntennas method.
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = randi( 10 ) ;

frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas );
assert( isequal ( frameObject.numberOfAntennas, numberOfTxAntennas ) == 1 );


%% Test 3: Check fillFrame Method for 20MHz BW for Normal CP
% Test the output size of fill Frame method.
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 20;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.NORMAL;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 14;

LTE.MODULATOR.NORMAL_CYCLIC_PREFIX_SAMPLES = 144;
LTE.MODULATOR.NORMAL_FIRST_SYMBOL_CYCLIC_PREFIX_SAMPLES = 160;

numberOfSubcarriers = LTE.BANDWIDTH_MHz * 0.9 / ( LTE.CARRIER_SPACING_kHz ) * 1000 ;

expectedSize= [ numberOfSubcarriers , LTE.OFDM_SYMBOLS_PER_SUBFRAME ];
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );
availableSymbols = frameObject.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + j * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );

%% Test 4: Check readFrame Method
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );
expectedSize = [frameObject.subcarriers, frameObject.ofdmSymbolsPerSubframe * frameObject.numberOfSubframes ];
aux = true;
subframeCount = 0;
while ( aux && subframeCount < frameObject.numberOfSubframes )
    subframeCount = subframeCount + 1;
    
    availableSymbols = frameObject.getAvailableDataSymbols();
    dataVector = ( rand ( availableSymbols, 1 ) + ...
                 1i * rand( availableSymbols, 1 ) ) / sqrt(2);
    frameTx = frameObject.fillFrame( dataVector );
    
    outputVector = frameObject.readFrame(frameTx, zeros(size(frameTx)));
    
    aux = ( isempty(dataVector) && isempty(outputVector) ) || ...
          isequal ( dataVector , outputVector );
end
assert( aux );

%% Test 5: Check fillFrame Method for 15MHz BW
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe
LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512;
LTE.BANDWIDTH_MHz = 15;
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

numberOfSubcarriers = LTE.BANDWIDTH_MHz * 0.9 / ( LTE.CARRIER_SPACING_kHz ) * 1000 ;
expectedSize= [ numberOfSubcarriers , LTE.OFDM_SYMBOLS_PER_SUBFRAME ];
availableSymbols = frameObject.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + j * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );

%% Test 6: Check fillFrame Method for 10MHz BW
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe
LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512;
LTE.BANDWIDTH_MHz = 10;
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

numberOfSubcarriers = LTE.BANDWIDTH_MHz * 0.9 / ( LTE.CARRIER_SPACING_kHz ) * 1000 ;
expectedSize= [ numberOfSubcarriers , LTE.OFDM_SYMBOLS_PER_SUBFRAME ];
availableSymbols = frameObject.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + j * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );

%% Test 7: Check fillFrame Method for 5MHz BW
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe
LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512;
LTE.BANDWIDTH_MHz = 5;
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

numberOfSubcarriers = LTE.BANDWIDTH_MHz * 0.9 / ( LTE.CARRIER_SPACING_kHz ) * 1000 ;
expectedSize= [ numberOfSubcarriers , LTE.OFDM_SYMBOLS_PER_SUBFRAME ];
availableSymbols = frameObject.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + j * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );

%% Test 8: Check fillFrame Method for 1.4MHz BW
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe
LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512;
LTE.BANDWIDTH_MHz = 1.4;
frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

numberOfSubcarriers = 72;
expectedSize= [ numberOfSubcarriers , LTE.OFDM_SYMBOLS_PER_SUBFRAME ];
availableSymbols = frameObject.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + j * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );
%% Test 9: Check fillFrame Method for Extended Cyclic Prefix
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe
LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512;

frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );
numberOfSubcarriers = LTE.BANDWIDTH_MHz * 0.9 / ( LTE.CARRIER_SPACING_kHz ) * 1000 ;
expectedSize= [ numberOfSubcarriers , LTE.OFDM_SYMBOLS_PER_SUBFRAME ];
availableSymbols = frameObject.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + j * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );

%% Test 10: Check readFrame Method for Extended Cyclic Prefix
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe
LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512;

frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );
availableSymbols = frameObject.getAvailableDataSymbols();
dataVector = ( rand ( availableSymbols, 1 ) + ...
             1i * rand( availableSymbols, 1 ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

outputVector = frameObject.readFrame(frameTx, zeros(size(frameTx) ) );

assert( isequal ( dataVector , outputVector ) );

%% Test 11: Check attribute dataLoad
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe
LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512;

frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );



aux = true;
subframeCount = 0;
firstOfdmSymbol = 1;
lastOfdmSymbol = frameObject.ofdmSymbolsPerSubframe;
while ( aux && subframeCount < frameObject.numberOfSubframes )
    subframeCount = subframeCount + 1;
    
    availableSymbols = frameObject.getAvailableDataSymbols();
    dataVector = ( rand ( 1, availableSymbols ) + ... 
                 1i * rand( 1 , availableSymbols ) ) / sqrt(2);
    frameTx = frameObject.fillFrame( dataVector );
    outputVector = frameObject.readFrame(frameTx, zeros( size(frameTx) ) );
    
    
    subframeMap = frameObject.frameMap( : , firstOfdmSymbol : lastOfdmSymbol );
    dataPositions = find( subframeMap == enum.modem.lte.FrameMap.PDSCH ); %Read the Data Symbols Positions
    controlPositions = find( subframeMap == enum.modem.lte.FrameMap.PDCCH ); %Read the Control Symbols Positions
    bchPositions = find ( subframeMap == enum.modem.lte.FrameMap.PBCH ); %Read the Broadcast Symbols Positions
    syncPositions = find ( subframeMap == enum.modem.lte.FrameMap.SYNC_SIGNAL ); %Read the Sync signals Positions
    refPositions = find( subframeMap == enum.modem.lte.FrameMap.REF_SIGNAL);  %Read the Ref. Signals Positions
    
    if ~isempty ( dataPositions )
        expectedDataLoad = length( dataVector ) / ( length(dataPositions) + length (controlPositions) + ...
            length(bchPositions) + length(syncPositions) + length( refPositions ));
    else
        expectedDataLoad = 0;
    end
    aux =  isequal( expectedDataLoad , frameObject.dataLoad );
    
    firstOfdmSymbol = firstOfdmSymbol + frameObject.ofdmSymbolsPerSubframe;
    lastOfdmSymbol = lastOfdmSymbol + frameObject.ofdmSymbolsPerSubframe;
    
end
assert( aux );

%% Test 12: Check getFrameDirection Method
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;

lookupTables.modem.lte.lookupSubframesConfig;

frameObject = modem.LteFrameAssembler( LTE , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

for subframeCount = 1 : frameObject.numberOfSubframes
    frameDir = frameObject.getFrameDirection( );
    
    if SUBFRAMES_DIRECTION( subframeCount ) == 'D' || SUBFRAMES_DIRECTION( subframeCount ) == 'S'
    	aux = isequal( frameDir, enum.FrameDirection.DOWNLINK );
    else
        aux = isequal( frameDir, enum.FrameDirection.UPLINK );
    end
    availableSymbols = frameObject.getAvailableDataSymbols();
    dataVector = ( rand ( 1, availableSymbols ) + j * rand( 1 , availableSymbols ) ) / sqrt(2);
    frameTx = frameObject.fillFrame( dataVector );
end

assert( aux );
