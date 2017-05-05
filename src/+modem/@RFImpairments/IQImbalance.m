function [ output_signal ] = IQImbalance(this, input_signal, a, phase)
%IQIMBALANCE IQ Imbalance in the transmitter
%   input_signal = input signal
%   a = amplitude increase due to the IQ Imbalance
%   phase = phase increase due to the IQ Imabalance, in radians

qSignal = real(input_signal);
iSignal = imag(input_signal);
output_signal = qSignal+iSignal*(1+a)*exp(1j*phase);

figure(1)
plot(iSignal)

figure(2)
plot(imag(output_signal))

figure(3)
plot(iSignal, imag(output_signal))

end

