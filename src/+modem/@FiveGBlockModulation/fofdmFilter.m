function [filterInTime] = fofdmFilter (this, filterSize)

% 5G bandwidth
B_fiveG = (this.subcarrierSpacing)*(this.usefulSubcarriers + 1);
f_low = -B_fiveG/2;
f_high = B_fiveG/2;

% Filter prototype in the frequency domain
f = [-5*B_fiveG:(10*B_fiveG + 1)/filterSize:5*B_fiveG];
prototypeInFrequency = rectangularPulse(f_low, f_high, f); % Rectangular pulse from -B_fiveG to B_fiveG

% Filter prototype in the time domain
prototypeInTime = abs(ifft(prototypeInFrequency)); 
prototypeInTime = fftshift(prototypeInTime); % Shifting the representation to the origin

% Multiplying the prototype filter in the time domain by the window
window = hann(filterSize)'; % Hanning window
filterInTime = prototypeInTime.*window;

% Normalizing the filter 
[sum, ~] = sumsqr(filterInTime); % sum is the squared sum of all of filterInTime's coefficients
filterInTime = (filterInTime)./sqrt(sum); % After normalizing, the squared sum of filterInTime's coefficients is equal to 1

% Testing
%plot(f, prototypeInFrequency);
%figure();
%plot(f, prototypeInTime);
%figure();
%stem(f, filterInTime);