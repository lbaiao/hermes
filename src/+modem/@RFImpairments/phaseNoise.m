function [outputSignal] = phaseNoise(this, rxSignal, variance)
% Introduces the phase noise at the receptor. The phase noise is modelled
% as a zero mean Gaussian random process with the specified variance.
% 
% The parameters are: rxSignal - signal at the receptor
%                     variance - the variance of the phase noise
%
%% Generating the phase noise 
std = sqrt(variance);
phaseNoise = std*randn(size(rxSignal)); 

%% Adding the phase noise to the received signal
outputSignal = rxSignal.*exp(1i*phaseNoise);

