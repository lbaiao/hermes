classdef RFImpairments < handle 

    % RFIMPAIRMENTS class implements the RF impairments present in the
% transmitter and/or receiver. 


properties ( GetAccess = 'public', SetAccess = 'protected')

end

methods (Access = public)
% constructor

    amplifiedSignal = HPA(this, signalInTime, parameterP, parameterV, IBO);

    iqImbalance = IQImbalance(this, input_signal, a, phase);    
end

    
end
