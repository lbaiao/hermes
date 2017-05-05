classdef ( Abstract )  BlockModulation < handle
% BLOCKMODULATION class implements the Modulator object
% Modulator object is responsible for transmission and 
% reception of the OFDM frame
%
%   Read-Only Public Properties:
%       numberOfAntennas <int> - number of antennas connected to modem
%       fftMaxSize <int> - Number of Max. FFT samples used for FFT when
%       no downsampling operation is applied
%       fftSize <int> - Number of FFT samples
%       samplingRate <double> (Hz) - Sampling Rate Used in the Modulation
%       centerFrequency <double> (Hz) - Modulation Center Frequency
%
%   Methods
% 
%   modulate
%       Used to transmit the signal and insert the guard
%       interval  *Parallel/Serial conversion
%
%           Syntax: serialModulatedSignal = modulate( transmittedFrame )
%
%           Inputs:
%               transmittedFrame < F x T x M complex >
%                   F: OFDM Subcarriers
%                   T: OFDM Symbols
%                   M: Number of Tx Antennas
%
%           Outputs:
%               serialModulatedSignal < Msamples x M complex >
%                   Msamplex: Number of serial samplex of Tx frame
%                   including the Cyclic prefix
%                   M: Number of Tx Antennas
%
%   demodulate
%       Demodulates the frame according to the specific scheme
%       performs serial/parallel Conversion
%
%          Syntax: frameReceived = demodulate( serialReceivedSignal )
%
%          Inputs:
%               serialReceived Signal < Msamples x N complex >
%                   Msamples: Number of serial samples of Tx Frame
%                   including Cyclic Prefix
%                   N: Number of Rx Antennas
%
%          Output:
%                frameReceived <F x T x N complex>
%                   F: Block size (e.g., number of subcarriers)
%                   T: Number of modulation blocks Symbols
%                   N: Number of Rx Antennas
%                   
%
%	setCenterFrequency
%   	Used to set centerFrequency Object Attribute.
%
%           Syntax:  setCenterFrequency( centerFrequency) 
%
%           Input: 
%               centerFrequency < 1 x 1 integer >
%
%   despread
%   	signal despreading after equalization ( only employed for some
%   	transmission techniques )
%
%           Syntax:  rxSignal = despread( signalIn ) 
%
%           Input: 
%               signalIn < F x T integer > - input signal after
%                   equalization
%                   F: Block size (e.g., number of subcarriers)
%                   T: Number of modulation blocks Symbols
%           Output: 
%               rxSignal < F x T integer > - signal after despreading
%                   F: Block size (e.g., number of subcarriers)
%                   T: Number of modulation blocks Symbols
%
%
%   Author: Rafhael Medeiros de Amorim (RMA) and Andre Noll Barreto
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br, andre.noll@indt.org
%   History:
%       v1.0 03 Mar 2015 (RMA) - created
%       v2.0 13 Mai 2015 (ANB) - despread included
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    properties ( GetAccess = 'public', SetAccess = 'protected')
        numberOfAntennas
        fftMaxSize
        fftSize
        samplingRate
        centerFrequency
    end
    
    methods
        
        modulatedSignal = modulate( this, transmittedFrame )
        frameReceived = demodulate( this, serialReceivedSignal )
        setCenterFrequency( this, centerFrequency ) 
        [ rxSignal, noiseVariance ] = despread( this, signalIn, ...
                                                noiseVariance )
        
    end
    
    
end

