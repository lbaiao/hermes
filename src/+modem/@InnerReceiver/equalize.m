function [ signalOut, ...
           coefficients ] = equalize ( this, signalIn, channel, noiseVariance )                     
%INNERRECEIVER.EQUALIZE Signal equalization in the frequency domain.
%   This is a protected method of InnerReceiver that performs signal 
%   equalization in the frequency domain, according to the equalization 
%   type set at the constructor.
%
%   Syntax: [ signalOut,
%             coefficients ] = equalize ( signalIn, channel,noiseVariance )
%
%   Please note that MMSE equalizer considers that transmitted symbol has unit
%   energy.
% 
%   Input:
%       signalIn < Nsubc x Nsymb complex x NRx > - received symbol, where
%           NRx is the number of receive antennas, Nsubc is the number of
%           subcarriers and Nsymb the number of symbols in the frame.
%       channel < Nsubc x Nsymb x NRx x NTx complex > - the channel
%           gain at each symbol and subcarrier, with NTx the number of
%           transmit antennas, Nsymb the number of symbols in a frame and
%           Nsubc the number of non-zero subcarriers.
%       noiseVarianceOut< double > - estimated noise variance
%   Output:
%       signalOut < Nsubc x Nsymb x Nstr complex> - received symbol, where
%           Nstr is the number of spatial streams, Nsubc is the number of
%           subcarriers and Nsymb the number of symbols in the frame.
%       coefficients< Nsubc x Nsymb x Nstr double > - equalizer coefficients 
% 
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 26 Mar 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.                             

switch this.equalizationAlgo
    case enum.modem.Equalization.ZF
        
        coefficients = 1 ./ channel;
                       
    case enum.modem.Equalization.MMSE
        % considering Es = 1
        
        coefficients = conj( channel ) ./ ...
                       ( real( channel ).^2 + imag( channel ).^2 + ...
                         noiseVariance );                  
        
    otherwise
        error('equalization algorithm not supported')
        
end

signalOut = signalIn .* coefficients;


end


    
