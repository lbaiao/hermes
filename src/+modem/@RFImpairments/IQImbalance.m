function [ output_signal ] = IQImbalance(this, input_signal, amp, phase)
%IQIMBALANCE IQ Imbalance in the transmitter
%   input_signal = input signal
%   amp = amplitude distortion due to the IQ Imbalance
%   phase = phase distortion due to the IQ Imabalance, in radians

alfa = cos(phase) - 1j*amp*sin(phase);
beta = amp*cos(phase) + 1j*sin(phase);

output_signal = alfa*input_signal + beta*conj(input_signal);

end

