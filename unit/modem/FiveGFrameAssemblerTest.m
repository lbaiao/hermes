%FIVEGFRAMEASSEMBLERTest function tests the FIVEGFRAMEASSEMBLER Class
%   This function test the creation of FiveGFrameAssembler class
%
%   Syntax: FiveGFrameAssemblerTest
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%        v1.0 20 Apr 2015 - (AB) created 
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor
% Test constructor of FiveGFrameAssemblerClass
fiveGSimulationSettings;
rnd = RandStream('mt19937ar');

frameObject = modem.FiveGFrameAssembler(FIVEG, rnd);

assert( isa ( frameObject, 'modem.FiveGFrameAssembler' ) );

%% Test 2: Check fillFrame Method for OFDM 4096-FFT
% Test the output size of fill Frame method.
fiveGSimulationSettings;
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;

FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.OFDM;
FIVE_G.FFT_SIZE = 4096;

guardFields = ( FIVEG.FRAME == enum.modem.fiveG.FrameMap.GUARD );
numberOfGuardSymbols = sum( FIVEG.NUMBER_OF_SYMBOLS( guardFields ) );
numberOfSymbols = sum( FIVEG.NUMBER_OF_SYMBOLS ) - numberOfGuardSymbols;
expectedSize= [ FIVEG.USEFUL_SUBCARRIERS , numberOfSymbols ];
frameObject = modem.FiveGFrameAssembler( FIVEG , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );
dataVector = ( rand ( 1, frameObject.getAvailableDataSymbols() ) + ...
    1i * rand( 1 , frameObject.getAvailableDataSymbols() ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );

%% Test 3: Check readFrame Method for OFDM
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
fiveGSimulationSettings;
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;

FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.OFDM;

frameObject = modem.FiveGFrameAssembler( FIVEG , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

dataVector = ( rand ( 1, frameObject.getAvailableDataSymbols() ) + ...
            1i * rand( 1 , frameObject.getAvailableDataSymbols() ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );
varianceAux = rand( size( frameTx) );
[outputVector variance] = frameObject.readFrame(frameTx, varianceAux);

assert( isequal ( dataVector.' , outputVector ) == 1 );



%% Test 4: Check dataLoad attribute for OFDM
fiveGSimulationSettings;
FIVEG.FRAME_TYPE = enum.modem.fiveG.FrameType.DOWNLINK;
FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.OFDM;

rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;

frameObject = modem.FiveGFrameAssembler( FIVEG , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

dataVector = ( rand ( 1, frameObject.getAvailableDataSymbols() ) + ...
            1i * rand( 1 , frameObject.getAvailableDataSymbols() ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );
varianceAux = rand( size( frameTx) );
[outputVector variance] = frameObject.readFrame(frameTx, varianceAux);
%Read the Data Symbols Positions
dataPositions = find( frameObject.frameMap == ...
                      enum.modem.fiveG.FrameMap.DATA ); 

%Read the Control Symbols Positions
controlPositions = find( frameObject.frameMap == ...
                         enum.modem.fiveG.FrameMap.DL_CONTROL ); 

%Read the reference Symbols Positions
refPositions = find( frameObject.frameMap == ...
                     enum.modem.fiveG.FrameMap.REF_SIGNAL );
                 
expectedDataLoad = length( dataVector ) / ...
                  ( length(dataVector) + length (controlPositions) + ...
                    length( refPositions ));

assert( expectedDataLoad == frameObject.dataLoad );


%% Test 5: Check fillFrame Method for OFDM 1024-FFT and two control symbols
% Test the output size of fill Frame method.
fiveGSimulationSettings;
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.OFDM;
FIVE_G.FFT_SIZE = 1024;
FIVEG.NUMBER_OF_SYMBOLS = [ 2 1 1 1 1 11 1];
FIVEG.USEFUL_SUBCARRIERS = 825;

guardFields = ( FIVEG.FRAME == enum.modem.fiveG.FrameMap.GUARD );
numberOfGuardSymbols = sum( FIVEG.NUMBER_OF_SYMBOLS( guardFields ) );
numberOfSymbols = sum( FIVEG.NUMBER_OF_SYMBOLS ) - numberOfGuardSymbols;
expectedSize= [ FIVEG.USEFUL_SUBCARRIERS , numberOfSymbols ];

frameObject = modem.FiveGFrameAssembler( FIVEG , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );
dataVector = ( rand ( 1, frameObject.getAvailableDataSymbols() ) + ...
    1i * rand( 1 , frameObject.getAvailableDataSymbols() ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );


%% Test 6: Check fillFrame Method for ZT_DS_OFDM 4096-FFT
% Test the output size of fill Frame method.
fiveGSimulationSettings;
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;

FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.ZT_DS_OFDM;
FIVE_G.FFT_SIZE = 4096;

guardFields = ( FIVEG.FRAME == enum.modem.fiveG.FrameMap.GUARD );
numberOfGuardSymbols = sum( FIVEG.NUMBER_OF_SYMBOLS( guardFields ) );
numberOfSymbols = sum( FIVEG.NUMBER_OF_SYMBOLS ) - numberOfGuardSymbols;
expectedSize= [ FIVEG.USEFUL_SUBCARRIERS - ...
                FIVEG.WAVEFORM.ZT_DS_OFDM.TAIL - ...
                FIVEG.WAVEFORM.ZT_DS_OFDM.HEAD , numberOfSymbols ];
frameObject = modem.FiveGFrameAssembler( FIVEG , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );
dataVector = ( rand ( 1, frameObject.getAvailableDataSymbols() ) + ...
    1i * rand( 1 , frameObject.getAvailableDataSymbols() ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );

assert( isequal ( size(frameTx) , expectedSize ) == 1 );

%% Test 7: Check readFrame Method for ZT_DS_OFDM
% Check if the disassembled frame equals the dataVector in the input of
% frame assembler
fiveGSimulationSettings;
rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;

FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.ZT_DS_OFDM;

frameObject = modem.FiveGFrameAssembler( FIVEG , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

dataVector = ( rand ( 1, frameObject.getAvailableDataSymbols() ) + ...
            1i * rand( 1 , frameObject.getAvailableDataSymbols() ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );
varianceAux = rand( size( frameTx) );
[outputVector variance] = frameObject.readFrame(frameTx, varianceAux);

assert( isequal ( dataVector.' , outputVector ) == 1 );



%% Test 8: Check dataLoad attribute for ZT-DS-OFDM
fiveGSimulationSettings;
FIVEG.FRAME_TYPE = enum.modem.fiveG.FrameType.DOWNLINK;
FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.ZT_DS_OFDM;

rnd = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;

frameObject = modem.FiveGFrameAssembler( FIVEG , rnd );
frameObject.setNumberOfAntennas( numberOfTxAntennas  );

dataVector = ( rand ( 1, frameObject.getAvailableDataSymbols() ) + ...
            1i * rand( 1 , frameObject.getAvailableDataSymbols() ) ) / sqrt(2);
frameTx = frameObject.fillFrame( dataVector );
varianceAux = rand( size( frameTx) );
[outputVector variance] = frameObject.readFrame(frameTx, varianceAux);
%Read the Data Symbols Positions
dataPositions = find( frameObject.frameMap == ...
                      enum.modem.fiveG.FrameMap.DATA ); 

%Read the Control Symbols Positions
controlPositions = find( frameObject.frameMap == ...
                         enum.modem.fiveG.FrameMap.DL_CONTROL ); 

%Read the reference Symbols Positions
refPositions = find( frameObject.frameMap == ...
                     enum.modem.fiveG.FrameMap.REF_SIGNAL );
                 
expectedDataLoad = length( dataVector ) / ...
                  ( length(dataVector) + length (controlPositions) + ...
                    length( refPositions ));

assert( expectedDataLoad == frameObject.dataLoad );
