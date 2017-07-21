function [ amplifiedSignal ] = MemHPA( this, signalInTime, delay )
%% Nonlinear power amplifier with memory.
% This method implements a nonlinear PA with memory. The memory depth is set to
% Q = 2 and we consider a 5th order polynomial (K = 5). The complex coefficients
% were extracted from a real Class AB PA, from L.Ding et. al. "A Robust Digital 
% Baseband Predistorter Constructed Using Memory Polynomials", 2004.
%
% The parameters are: - signalInTime: signal that is passed through the
%                       nonlinear PA in the time domain
%                     - delay: the delay, in samples
%           

%% Complex coefficients of the power amplifier
bk0 = [1.0513+0.0904i -0.0542-0.2900i -0.9657-0.7028i]; % Coefficients for q = 0
bk1 = [-0.068-0.0023i 0.2234+0.2317i -0.2451-0.3735i]; % Coefficients for q = 1
bk2 = [0.0289-0.0054i -0.0621-0.0932i 0.1229+0.1508i]; % Coefficients for q = 2

%% Amplified signal

% AJUSTAR TAMANHOS
noDelay = bk0(1)*signalInTime.*abs(signalInTime) + ...
          bk0(2)*signalInTime.*abs(signalInTime).^4 + ...
          bk0(3)*signalInTime.*abs(signalInTime).^8;
        
firstDelay = bk1(1)*signalInTime(delay:length(signalInTime), :).*abs(signalInTime(delay:length(signalInTime), :)) + ...
             bk1(2)*signalInTime(delay:length(signalInTime), :).*abs(signalInTime(delay:length(signalInTime), :)).^4 + ...
             bk1(3)*signalInTime(delay:length(signalInTime), :).*abs(signalInTime(delay:length(signalInTime), :)).^8;
adjustFirst = zeros(delay-1, 1); % Zeros to adjust the size 
firstDelay = [adjustFirst; firstDelay]; % Adjusting the size
       
secondDelay = bk2(1)*signalInTime(2*delay:length(signalInTime), :).*abs(signalInTime(2*delay:length(signalInTime), :)) + ...
              bk2(2)*signalInTime(2*delay:length(signalInTime), :).*abs(signalInTime(2*delay:length(signalInTime), :)).^4 + ...
              bk2(3)*signalInTime(2*delay:length(signalInTime), :).*abs(signalInTime(2*delay:length(signalInTime), :)).^8;
adjustSecond = zeros(2*delay-1, 1); % Zeros to adjust the size 
secondDelay = [adjustSecond; secondDelay]; % Adjusting the size

amplifiedSignal = noDelay + firstDelay + secondDelay;          

end

