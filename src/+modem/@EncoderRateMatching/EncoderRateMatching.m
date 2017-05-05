classdef EncoderRateMatching < handle
% EncoderRateMatching class implements encoder rate matching for Hermes.
% EncoderRateMatching object implements Wi-Fi rate matching as defined in 
% IEEE Standard 802.11 - Part 11: Wireless LAN Medium Access Control (MAC) 
% and Physical Layer (PHY) Specifications - February, 2012. 
% 
%
%   Read-Only Public Properties:
%       puncturePattern < K x M boolean> - Contains the atomic part for the
%           puncture pattern. K is the number of input bits and M is
%           the original number of encoder outputs. 
%           Example: For a 3/4 rate, from an original 1/2 Conv. Encoder,
%           K=3 and M = 2.
%           In the puncture vector, '1's represent the bits to be kept in
%           the message, while '0's represent bits to be punctured.
%      
%
%   Constructor
%       Syntax: this = EncoderRateMatching( desiredRate, encoder )
%       Inputs: 
%               desiredRate < double >: contains the desired encoder rate 
%                   after puncturing.
%               encoder < channelCode Object >: contains the encoder object 
%                   in which the rate matching will be applied.
%
%       Syntax: this = EncoderRateMatching( puncturePattern )
%               puncturePattern < KxM boolean >: Use this syntax only if 
%                   a user defined puncture pattern different from those
%                   described in class header is needed.
%   Public Methods             
%   puncturing: 
%       Performs the puncturing operation in the array of bits.
%       Syntax: [ puncturedArray ] = puncturing( encodedArray );
%       Inputs: 
%           encodedArray < K x 1 bits>: array to be punctured
%       Output:
%           puncturedArray < M x 1 bITS >: punctured Array.
%
%  depuncturing: 
%       Performs the depuncturing operation in the array of bits.
%       Syntax: [ reconstructedArray ] = depuncturing( receivedArray );
%       Inputs: 
%           receivedArray < K x 1 bits>: array to be depunctured
%       Output:
%           reconstructedArray < M x 1 bITS >: reconstructed Array.
%
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v2.0 30 June 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

properties ( GetAccess = 'public', SetAccess = 'protected')
    puncturePattern    
end

properties ( GetAccess = 'protected', SetAccess = 'protected')
    punctureVector
end
%%
methods ( Access = public )

    %% constructor
    function this = EncoderRateMatching( varargin )
        
        if ( nargin == 1 ) % If the input is a user-defined one:
            puncturePattern = varargin{ 1 };
            % Check if the puncture Pattern contains only 0's or 1's.
            if isempty( find( puncturePattern( find( puncturePattern ~= 0 ) ) ~= 1 ) )
                this.puncturePattern = varargin{ 1 };
                this.punctureVector = [];
                return;
            else
                error('User Defined Puncture Pattern must be an array with binary values');
            end
        end
        
        desiredRate  = varargin{ 1 };
        encoderObject = varargin{ 2 };
        % Load the Puncture Pattern for different encoders:
        switch class( encoderObject )
            case 'modem.ChannelCode' % For Dummy Channel Code:    
                if desiredRate ~= 1
                    error('The selected desired rate is not allowed for this encoder type');
                else % Input = Output:
                    this.puncturePattern = 1;
                    this.punctureVector = [];
                    return;
                end
                
            case 'modem.ConvolutionalCode' % For ConvolutionalCode:
                % Load Wi-Fi Puncture Table:
                this.puncturePattern = ...
                    lookupTables.modem.wifi.getPuncturePattern( desiredRate );
                this.punctureVector = [];
                return;
                
            case 'modem.TurboCode'
                 % Load Hermes Puncture Table for Turbo Encoder:
                this.puncturePattern = ...
                    lookupTables.modem.fiveG.getTurboPuncturePattern( desiredRate );
                this.punctureVector = [];
                return; 
            otherwise 
                error(' No puncture is implemented for the selected encoder');
                
        end

    end
    
    depuncturedArray =  depuncturing ( this, receivedArray) 
    puncturedArray =  puncturing ( this, encodedArray )
end

end