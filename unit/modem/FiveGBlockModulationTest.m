%FIVEBLOCKMODULATIONTEST function tests the FIVEGBLOCKMODULATION class
%   This function test the creation of FiveGBlockModulation Class
%
%   Syntax: FiveGBlockModulationTest
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasilia
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 22 Apr 2015 (AB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor
% Test constructor of FiveGBlockModulation Class
fiveGSimulationSettings;
rndSeed = RandStream('mt19937ar');

frame = modem.FiveGFrameAssembler(FIVEG, rndSeed);

modulator = modem.FiveGBlockModulation(FIVEG, frame);

assert( isa ( modulator, 'modem.FiveGBlockModulation' ) );

%% Test 2: check class modulate and demodulate methods for OFDM 4096 FFT
% Test whether demodulator output is equal to modulator input
fiveGSimulationSettings;
rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.OFDM;
FIVEG.FFT_SIZE = 4096;
frame = modem.FiveGFrameAssembler( FIVEG , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
dataVector =  2 * rand ( 1, frame.getAvailableDataSymbols() ) - 1 + ...
             1i * ( 2 * rand( 1 , frame.getAvailableDataSymbols() ) - 1 ) / sqrt(2);
frameTx = frame.fillFrame( dataVector );

modulator = modem.FiveGBlockModulation(FIVEG, frame);
modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = squeeze( modulator.demodulate(modulatedFrame, 0) );

diff = max( abs ( frameTx - demodulatedFrame ) );
assert( max (diff) < 10^-10 );

%% Test 3: check class modulate and demodulate methods for OFDM 1024 FFT
% Test whether demodulator output is equal to modulator input
fiveGSimulationSettings;
rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.OFDM;
FIVEG.FFT_SIZE = 1024;
FIVEG.USEFUL_SUBCARRIERS = 824;
frame = modem.FiveGFrameAssembler( FIVEG , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
dataVector =  2 * rand ( 1, frame.getAvailableDataSymbols() ) - 1 + ...
             1i * ( 2 * rand( 1 , frame.getAvailableDataSymbols() ) - 1 ) / sqrt(2);
frameTx = frame.fillFrame( dataVector );

modulator = modem.FiveGBlockModulation(FIVEG, frame);
modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = squeeze( modulator.demodulate(modulatedFrame, 0) );

diff = max( abs ( frameTx - demodulatedFrame ) );
assert( max (diff) < 10^-10 );


%% Test 4 : check setCenterFreq method

fiveGSimulationSettings;
rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;

frame = modem.FiveGFrameAssembler( FIVEG , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
modulator = modem.FiveGBlockModulation(FIVEG, frame);
centerFreq = randi([0,3],1) * 10^9;
modulator.setCenterFrequency( centerFreq )
assert( modulator.centerFrequency == centerFreq );

%% Test 5: check class modulate and demodulate methods for ZT-DS-OFDM 4096 FFT
% Test whether demodulator output is equal to modulator input
fiveGSimulationSettings;
rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.ZT_DS_OFDM;
FIVEG.FFT_SIZE = 4096;
frame = modem.FiveGFrameAssembler( FIVEG , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
dataVector =  2 * rand ( 1, frame.getAvailableDataSymbols() ) - 1 + ...
             1i * ( 2 * rand( 1 , frame.getAvailableDataSymbols() ) - 1 ) / sqrt(2);
frameTx = frame.fillFrame( dataVector );

modulator = modem.FiveGBlockModulation(FIVEG, frame);

modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = squeeze( modulator.demodulate(modulatedFrame, 0) );
despreadFrame = modulator.despread(demodulatedFrame, 0);

diff = max( abs ( frameTx - despreadFrame ) );
assert( max (diff) < 10^-10 );

%% Test 6: check class modulate and demodulate methods for ZT-DS-OFDM 1024 FFT
% Test whether demodulator output is equal to modulator input
fiveGSimulationSettings;
rndSeed = RandStream( 'mt19937ar' );
numberOfTxAntennas = 1;
FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.ZT_DS_OFDM;
FIVEG.FFT_SIZE = 1024;
FIVEG.USEFUL_SUBCARRIERS = 800;

frame = modem.FiveGFrameAssembler( FIVEG , rndSeed );
frame.setNumberOfAntennas( numberOfTxAntennas );
dataVector =  2 * rand ( 1, frame.getAvailableDataSymbols() ) - 1 + ...
             1i * ( 2 * rand( 1 , frame.getAvailableDataSymbols() ) - 1 ) / sqrt(2);
frameTx = frame.fillFrame( dataVector );

modulator = modem.FiveGBlockModulation(FIVEG, frame);

modulatedFrame = modulator.modulate(frameTx);
demodulatedFrame = squeeze( modulator.demodulate(modulatedFrame, 0) );
despreadFrame = modulator.despread(demodulatedFrame, 0);

diff = max( abs ( frameTx - despreadFrame ) );
assert( max (diff) < 10^-10 );

