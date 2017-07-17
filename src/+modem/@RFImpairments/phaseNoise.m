function [phaseNoiseSignal] = phaseNoise(this, receivedSignalInTime)
% Introduces the phase noise at the receptor. 
% The parameters are: receivedSignalInTime
%
%% Adding the phase noise to the received signal

phaseNoiseSignal = receivedSignalInTime.*exp(1i*phi);

