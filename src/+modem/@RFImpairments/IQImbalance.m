function [ output_signal ] = IQImbalance( input_signal, a, phase)
%IQIMBALANCE Summary of this function goes here
%   input_signal = input signal
%   a = amplitude increase due to the IQ Imbalance
%   phase = phase increase due to the IQ Imabalance

qSignal = real(input_signal);
iSignal = imag(input_signal);
output_signal = qSignal-iSignal*(1+a)*exp(1j*phase);

end

