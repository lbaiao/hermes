function [amplifiedSignal] = HPA(this, signalInTime, parameterP, parameterV, IBO)
% Non-linear power aplifier in the transmitter.
% Rapp model for a solid state amplifier in which AM/PM conversion is
% neglected. 
% The parameters are: p - smoothness factor
%                     v - small signal gain
%                     Ao - maximum signal amplitude (saturation)
%                     A - signal's amplitudes
%                     IBO - input power back-off in dB
%%

p = parameterP; % Smoothness factor
v = parameterV; % Small signal gain
A = abs(signalInTime); % Amplitudes of the signal to be amplified 
signalInTimePhases = angle(signalInTime); % Phases of the incoming signal

% Calculating the signal's average power
Pin = mean(abs(signalInTime).^2); % Input signal's power 
PindBW = 10*log10(Pin); % Average power in dBW

% Determining the saturation amplitude Ao
PsatdBW = PindBW + IBO; % Power at the saturation point in dBW
PsatW = 10^(PsatdBW/10); % Saturation power in W
Ao = sqrt(PsatW); % Saturation amplitude

% Nonlinear HPA response
G = v.*A./((1 + (v.*A/(Ao)).^(2*p)).^(1/(2*p))); % Rapp model

amplifiedSignal = G.*exp(1i.*signalInTimePhases);



