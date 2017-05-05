function [ output_signal ] = IQImbalance( input_signal, a, phase, fc )
%IQIMBALANCE Summary of this function goes here
%   input_signal = input signal
%   a = amplitude increase due to the IQ Imbalance
%   phase = phase increase due to the IQ Imabalance
%   fc = Carrier frequency <----- verificar onde é feita a modulação para
%   alta frequência

qSignal = real(input_signal);
iSignal = imag(input_signal);
t = 0:1:length(input_signal); % a ser removido
output_signal = qSignal*cos(2*pi*fc*t)-iSignal*(1+a)*sin(2*pi*fc*t + phase);

end

