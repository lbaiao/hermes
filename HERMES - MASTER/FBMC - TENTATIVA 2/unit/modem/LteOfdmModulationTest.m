%LTEOFDMMODULATIONTEST function tests the LTEOFDMMODULATION class
%   This function test the creation for LteOfdmModulation Class
%
%   Syntax: LteOfdmModulationTest
%
%   Author: Rafhael Amorim (RMA)
%   Work Address: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v1.0 06 Mar 2015 (RMA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor
% Test constructor of LteOfdmModulation Class
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rndSeed = RandStream('mt19937ar');

frame = modem.LteFrameAssembler(LTE, rndSeed);

modulator = modem.LteOfdmModulation(LTE, frame);

assert( isa ( modulator, 'modem.LteOfdmModulation' ) );

%% Test 2: check class modulate and demodulate methods for 20 MHz BW
% Test whether demodulator output is equal to modulator input
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 20;
frame = modem.LteFrameAssembler( LTE , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
availableSymbols = frame.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + 1i * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frame.fillFrame(dataVector );

modulator = modem.LteOfdmModulation(LTE, frame);
modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = modulator.demodulate(modulatedFrame, 0);

diff = max( abs ( frameTx - demodulatedFrame ) );
assert( max (diff) < 10^-10 );
%% Test 3: check downsampling factor attribute

lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 10;

frame = modem.LteFrameAssembler( LTE , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
modulator = modem.LteOfdmModulation(LTE, frame);
assert( modulator.downsamplingFactor == modulator.fftMaxSize / modulator.fftSize );

%% Test 4: check setCenterFreq method

lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 10;

frame = modem.LteFrameAssembler( LTE , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
modulator = modem.LteOfdmModulation(LTE, frame);
centerFreq = randi([0,3],1) * 10^9;
modulator.setCenterFrequency( centerFreq )
assert( modulator.centerFrequency == centerFreq );

%% Test 5: check class modulate and demodulate methods for 15 MHz BW
% Test whether demodulator output is equal to modulator input
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 15;
frame = modem.LteFrameAssembler( LTE , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
availableSymbols = frame.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + 1i * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frame.fillFrame(dataVector );

modulator = modem.LteOfdmModulation(LTE, frame);
modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = modulator.demodulate(modulatedFrame, 0);

diff = max( abs ( frameTx - demodulatedFrame ) );
assert( max (diff) < 10^-10 );

%% Test 6: check class modulate and demodulate methods for 10 MHz BW
% Test whether demodulator output is equal to modulator input
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 10;
frame = modem.LteFrameAssembler( LTE , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
availableSymbols = frame.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + 1i * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frame.fillFrame(dataVector );

modulator = modem.LteOfdmModulation(LTE, frame);
modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = modulator.demodulate(modulatedFrame, 0);

diff = max( abs ( frameTx - demodulatedFrame ) );
assert( max (diff) < 10^-10 );

%% Test 7: check class modulate and demodulate methods for 5 MHz BW
% Test whether demodulator output is equal to modulator input
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 5;
frame = modem.LteFrameAssembler( LTE , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
availableSymbols = frame.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + 1i * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frame.fillFrame(dataVector );

modulator = modem.LteOfdmModulation(LTE, frame);
modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = modulator.demodulate(modulatedFrame, 0);

diff = max( abs ( frameTx - demodulatedFrame ) );
assert( max (diff) < 10^-10 );


%% Test 8: check class modulate and demodulate methods for 1.4 MHz BW
% Test whether demodulator output is equal to modulator input
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 1.4;
frame = modem.LteFrameAssembler( LTE , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
availableSymbols = frame.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + 1i * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frame.fillFrame(dataVector );

modulator = modem.LteOfdmModulation(LTE, frame);
modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = modulator.demodulate(modulatedFrame, 0);

diff = max( abs ( frameTx - demodulatedFrame ) );
assert( max (diff) < 10^-10 );

%% Test 9: check class modulate and demodulate methods for Extended CP
% Test whether demodulator output is equal to modulator input
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);

rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
LTE.BANDWIDTH_MHz = 20;
LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED;
LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe
LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512;
frame = modem.LteFrameAssembler( LTE , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
availableSymbols = frame.getAvailableDataSymbols();
dataVector = ( rand ( 1, availableSymbols ) + 1i * rand( 1 , availableSymbols ) ) / sqrt(2);
frameTx = frame.fillFrame(dataVector );

modulator = modem.LteOfdmModulation(LTE, frame);
modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = modulator.demodulate(modulatedFrame, 0);

diff = max( abs ( frameTx - demodulatedFrame ) );
assert( max (diff) < 10^-10 );