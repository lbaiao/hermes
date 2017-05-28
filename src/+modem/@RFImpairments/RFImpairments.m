classdef RFImpairments < handle %modem.BlockModulation
% RFIMPAIRMENTS class implements the RF impairments present in the
% transmitter. 

properties ( GetAccess = 'public', SetAccess = 'protected')

    
end

methods (Access = public)
% constructor
    amplifiedSignal = HPA(this, signalInTime, parameterP, parameterV, IBO);

     iqImbalance = IQImbalance(this, input_signal, a, phase);    
end

    
end
