%RxSamplerTest function tests the RxSampler Class
%   This script contains the tests for a RxSamplerClass
%
%   Author: Rafhael Amorim (RA), Renato Barbosa Abreu (RBA)
%   Work Address: INDT Brasília/Manaus
%   E-mail: rafhael.amorim@indt.org.br, renato.abreu@indt.org.br
%   History:
%       v1.0 23 Mar 2015 (RA) - created
%       v2.0 26 May 2015 (RBA) - include test for different sampling rates
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor
%
rxSamplingRate = 1000;
rxCenterFreq = 2.5 * 10^9;
instanceRxSampler = modem.RxSampler( rxSamplingRate , rxCenterFreq );
assert( isa ( instanceRxSampler, 'modem.RxSampler' ) );

%% Test 2: check setTxSamplingRate - Sampling Rate
%
rxSamplingRate = 1000;
rxCenterFreq = 2.5 * 10^9;
instanceRxSampler = modem.RxSampler( rxSamplingRate , rxCenterFreq );
numberOfTransmitters = 10;
txSamplingRate = randperm(numberOfTransmitters) * 5000;
txCenterFreq = randperm(numberOfTransmitters) * 5000 + 2.5*10^9;
instanceRxSampler.setTxSamplingRate ( txSamplingRate, txCenterFreq )
assert( all ( instanceRxSampler.txSamplingRate == txSamplingRate ) );

%% Test 3: check setTxSamplingRate - CenterFreq
%
rxSamplingRate = 1000;
rxCenterFreq = 2.5 * 10^9;
instanceRxSampler = modem.RxSampler( rxSamplingRate , rxCenterFreq );
numberOfTransmitters = 10;
txSamplingRate = randperm(numberOfTransmitters) * 5000;
txCenterFreq = randperm(numberOfTransmitters) * 5000 + 2.5*10^9;
instanceRxSampler.setTxSamplingRate ( txSamplingRate, txCenterFreq )
assert( all ( instanceRxSampler.txCenterFreq == txCenterFreq ) );

%% Test 4: check resample with same sample rates
%
receiveTime = 1e-3;
rxSamplingRate = 23.04e6;
rxCenterFreq = 2.4e9;
instanceRxSampler = modem.RxSampler( rxSamplingRate , rxCenterFreq );
txSamplingRate = [ 23.04e6 23.04e6 23.04e6 ];

txCenterFreq = [ 2.4e9 2.4e9 2.4e9 ];

instanceRxSampler.setTxSamplingRate ( txSamplingRate, txCenterFreq )

% generate vectors with 3 different sizes
numberOfSamples = [ 0.25 0.5 1] .* txSamplingRate * receiveTime;
seed = 13;
rnd = RandStream('mt19937ar', 'Seed', seed);
numberOfRxAntennas = 2;

in1 = ( rnd.rand( numberOfSamples(1), numberOfRxAntennas ) + ...
    1i*rnd.rand( numberOfSamples(1), numberOfRxAntennas ) - ( 0.5 + 0.5*1i ) );

in2 = ( rnd.rand( numberOfSamples(2), numberOfRxAntennas ) + ...
    1i*rnd.rand( numberOfSamples(2), numberOfRxAntennas ) - ( 0.5 + 0.5*1i ) );

in3 = ( rnd.rand( numberOfSamples(3), numberOfRxAntennas ) + ...
    1i*rnd.rand( numberOfSamples(3), numberOfRxAntennas ) - ( 0.5 + 0.5*1i ) );

signalIn{1} = in1;
signalIn{2} = in2;
signalIn{3} = in3;

signalOut = instanceRxSampler.resample( signalIn );

sizeOut = size(signalOut);
numberOfRxSymbols = rxSamplingRate * receiveTime;

assert( sizeOut(1) == numberOfRxSymbols );
assert( sizeOut(2) == numberOfRxAntennas );

%% Test 5: check resample with different sample rates
%
receiveTime = 1e-3;
rxSamplingRate = 30.72e6;
rxCenterFreq = 2.4e9;
instanceRxSampler = modem.RxSampler( rxSamplingRate , rxCenterFreq );
numberOfTransmitters = 3;
txSamplingRate = [ 20e6 30.72e6 23.04e6 ];

txCenterFreq = [ 2.37e9 2.4e9 2.5e9 ];

instanceRxSampler.setTxSamplingRate ( txSamplingRate, txCenterFreq )

numberOfSamples = 2 * txSamplingRate * receiveTime;
seed = 13;
rnd = RandStream('mt19937ar', 'Seed', seed);
numberOfRxAntennas = 2;

% Coefficents of a LPF with cutoff almost pi
num = [0.000613686326695792 -0.000779857403735185 0.00124578235281383 -0.00186563105096618 0.00266213345303085 -0.00365573303442564 0.00486355487780369 -0.00629739247662476 0.00796319026397681 -0.00985970093477012 0.0119776242467902 -0.0142991029578111 0.0167975184726107 -0.0194375672087778 0.0221761174784383 -0.0249630166469803 0.0277421272763896 -0.0304535493726799 0.0330356583289230 -0.0354266479545496 0.0375667308826263 -0.0394014074377889 0.0408823849824539 -0.0419699111620761 0.0426342648937785 0.957141703308180 0.0426342648937785 -0.0419699111620761 0.0408823849824539 -0.0394014074377889 0.0375667308826263 -0.0354266479545496 0.0330356583289230 -0.0304535493726799 0.0277421272763896 -0.0249630166469803 0.0221761174784383 -0.0194375672087778 0.0167975184726107 -0.0142991029578111 0.0119776242467902 -0.00985970093477012 0.00796319026397681 -0.00629739247662476 0.00486355487780369 -0.00365573303442564 0.00266213345303085 -0.00186563105096618 0.00124578235281383 -0.000779857403735185 0.000613686326695792];

scaleIn1 = 4;
scaleIn2 = 1;
scaleIn3 = 3;

in1 = ( rnd.rand( numberOfSamples(1), numberOfRxAntennas ) + ...
    1i*rnd.rand( numberOfSamples(1), numberOfRxAntennas ) - ( 0.5 + 0.5*1i ) ) * scaleIn1;

in2 = ( rnd.rand( numberOfSamples(2), numberOfRxAntennas ) + ...
    1i*rnd.rand( numberOfSamples(2), numberOfRxAntennas ) - ( 0.5 + 0.5*1i ) ) * scaleIn2;

in3 = ( rnd.rand( numberOfSamples(3), numberOfRxAntennas ) + ...
    1i*rnd.rand( numberOfSamples(3), numberOfRxAntennas ) - ( 0.5 + 0.5*1i ) ) * scaleIn3;

in1filt(:,1) = filter(num, 1, in1(:, 1));
in1filt(:,2) = filter(num, 1, in1(:, 2));
in2filt(:,1) = filter(num, 1, in2(:, 1));
in2filt(:,2) = filter(num, 1, in2(:, 2));
in3filt(:,1) = filter(num, 1, in3(:, 1));
in3filt(:,2) = filter(num, 1, in3(:, 2));

% magPlot1 = 10*log10(abs(fftshift(fft(in1filt( :, 1 )))));
% magPlot2 = 10*log10(abs(fftshift(fft(in2filt( :, 1 )))));
% magPlot3 = 10*log10(abs(fftshift(fft(in3filt( :, 1 )))));
% freqPlot1 = -pi : 2*pi/length(magPlot1) : pi-2*pi/length(magPlot1);
% freqPlot2 = -pi : 2*pi/length(magPlot2) : pi-2*pi/length(magPlot2);
% freqPlot3 = -pi : 2*pi/length(magPlot3) : pi-2*pi/length(magPlot3);
% figure; plot(freqPlot1, magPlot1); xlabel('Normalized frequency (rad/sample)'); ylabel('Magnitude (dB)'); title(['Input signal - Fc: ' num2str(txCenterFreq(1)) ', Sr: ' num2str(txSamplingRate(1))]);
% figure; plot(freqPlot2, magPlot2); xlabel('Normalized frequency (rad/sample)'); ylabel('Magnitude (dB)'); title(['Input signal - Fc: ' num2str(txCenterFreq(2)) ', Sr: ' num2str(txSamplingRate(2))]);
% figure; plot(freqPlot3, magPlot3); xlabel('Normalized frequency (rad/sample)'); ylabel('Magnitude (dB)'); title(['Input signal - Fc: ' num2str(txCenterFreq(3)) ', Sr: ' num2str(txSamplingRate(3))]);

signalIn{1} = in1filt;
signalIn{2} = in2filt;
signalIn{3} = in3filt;

signalOut = instanceRxSampler.resample( signalIn );

% magPlot1 = 10*log10(abs(fftshift(fft(signalOut( :, 1 )))));
% magPlot2 = 10*log10(abs(fftshift(fft(signalOut( :, 2 )))));
% freqPlot1 = -pi : 2*pi/length(magPlot1) : pi-2*pi/length(magPlot1);
% freqPlot2 = -pi : 2*pi/length(magPlot2) : pi-2*pi/length(magPlot2);
% figure; plot(freqPlot1, magPlot1); xlabel('Normalized frequency (rad/sample)'); ylabel('Magnitude (dB)'); title(['Output signal - Fc: ' num2str(rxCenterFreq) ', Sr: ' num2str(rxSamplingRate)]);
% figure; plot(freqPlot2, magPlot2); xlabel('Normalized frequency (rad/sample)'); ylabel('Magnitude (dB)'); title(['Output signal - Fc: ' num2str(rxCenterFreq) ', Sr: ' num2str(rxSamplingRate)]);

sizeOut = size(signalOut);
numberOfRxSymbols = 2 * rxSamplingRate * receiveTime;

assert( sizeOut(2) == numberOfRxAntennas );

% Allow variation since ceil(length(x)*p/q)
assert( sizeOut(1) == numberOfRxSymbols || ...
        sizeOut(1) == numberOfRxSymbols + 1 || ...
        sizeOut(1) == numberOfRxSymbols - 1 );