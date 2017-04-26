function [filterInTime] = fofdmFilter (this, filterSize)

% 5G bandwidth
B_fiveG = (this.subcarrierSpacing)*(this.usefulSubcarriers + 1); % 5G bandwidth
fs = (this.samplingRate); % Sampling frequency

% Filter prototype in the frequency domain
f = [0:(fs + 1)/filterSize:fs]; 
prototypeInFrequency = rectangularPulse(0, B_fiveG/2, f) + rectangularPulse(fs - B_fiveG/2, fs, f); % Rectangular pulses from 0 to B_fiveG/2 and from (B_fiveG/2-fs) to fs

% Filter prototype in the time domain
prototypeInTime = ifft(prototypeInFrequency); 
prototypeInTime = fftshift(prototypeInTime); % Shifting the representation to the origin

% Multiplying the prototype filter in the time domain by the window
window = hann(filterSize)'; % Hanning window
filterInTime = prototypeInTime.*window; 

% Normalizing the filter 
%[sum, ~] = sumsqr(filterInTime); % sum is the squared sum of all of filterInTime's coefficients
%filterInTime = (filterInTime)./sqrt(sum); % After normalizing, the squared sum of filterInTime's coefficients is equal to 1
