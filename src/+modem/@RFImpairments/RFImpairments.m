classdef RFImpairments < modem.BlockModulation
% RFIMPAIRMENTS class implements the RF impairments present in the
% transmitter. 

properties ( GetAccess = 'public', SetAccess = 'protected')
    HPA
    p
    v
    IBO
    
end

methods (Access = public)
%% constructor
    function this = RFImpairments()
        
        % Nonlinear HPA parameters
        this.HPA = SETTINGS.RFIMPAIRMENTS.HPA.STATUS; % Checking if there is a nonlinear HPA
        this.p = SETTINGS.RFIMPAIRMENTS.HPA.P; % p parameter for the HPA
        this.v = SETTINGS.RFIMPAIRMENTS.HPA.V; % v parameter for the HPA
        this.IBO = SETTINGS.RFIMPAIRMENTS.HPA.IBO; % Input power back-off for the HPA
        
        if this.HPA == 1
            amplifiedSignal = HPA(signalInTime, this.p, this.v, this.IBO);
        end
            
        
    end
    
end
    
end
