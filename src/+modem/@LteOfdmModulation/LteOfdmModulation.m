classdef LteOfdmModulation < modem.BlockModulation
% LTEOFDMMODULATION class implements the Modulation object, which is
% responsible for transmission and reception of the LTE OFDM frame.
% The methods "modulate" and "demodulate" can handle one frame per
% call.
%
%   Read-Only Public Properties:
%       downsamplingFactor <int> - downsampling factor used in FFT Max Size
%       cyclicPrefixLengthFirstSymbol <int> - Number of Samples in
%           Cyclic Prefix for 1st OFDM Symbol in each slot
%       cyclicPrefixLength <int> - Number of Samples in Cyclic Prefix
%           for other OFDM Symbols
%       subcarrierFreqMap <1xNsc int> - Map the data subcarriers into
%           their frequency positions.
%       numberOfAntennas <int> - Number of antennas
%       numberOfSlots <int> - Number of LTE slots
%       ofdmSymbolsPerSlot <int> - number of OFDM symbols in one slot
%
%   Methods
%
%   constructor
%       Syntax: this = modem.LteOfdmModulation( LTE, LteFrameAssembler )
%
%       Inputs:
%           LTE - struct with LTE Parameters used in this class:
%               LTE.MODULATOR.MAX_FFT_SIZE < int >: Max Number of FFT
%               Samples defined in the standard
%               LTE.CYCLIC_PREFIX < enum modem.lte.CyclicPrefix >
%               LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES < int >
%               LTE.MODULATOR.NORMAL_FIRST_SYMBOL_CYCLIC_PREFIX_SAMPLES
%               < int >
%               LTE.MODULATOR.NORMAL_CYCLIC_PREFIX_SAMPLES < int >
%           LteFrameAssembler <LteFrameAssembler Object> - Include
%               parameters used for Modulator construction:
%                 numberOfSlotsPerSubframe < int >
%                 numberOfSubframes < int >
%                 numberOfSubcarriers < int >
%                 ofdmSymbolsPerSlor < int >
%
%   modulate
%       Modulates the OFDM Frame and inserts the Cyclic Prefix
%       * Parallel/Serial Conversion
%
%       Syntax: serialModulatedSignal = modulate( transmittedFrame)
%
%       Inputs:
%           transmittedFrame [F x T x M complex]
%                   F: OFDM Subcarriers
%                   T: OFDM Symbols
%                   M: Number of Tx Antennas
%       Output:
%           serialModulatedSignal < Msamples x M complex >
%                   Msamples: Number of serial samples of Tx Frame
%                   including Cyclic Prefix
%                   M: Number of Tx Antennas
%
%   demodulate
%       Demodulates the OFDM Frame and removes the Cyclic Prefix
%       * Serial/Parallel Conversion
%
%       Syntax: frameReceived  = demodulate( serialReceivedSignal)
%
%       Inputs:
%           serialReceived Signal < Msamples x N complex >
%                   Msamples: Number of serial samples of Tx Frame
%                   including Cyclic Prefix
%                   N: Number of Rx Antennas
%
%       Output:
%           frameReceived [F x T x N complex]
%                   F: OFDM Subcarriers
%                   T: OFDM Symbols
%                   N: Number of Rx Antennas
%
%   setCarrierFreqMap
%      Sets the downsampling Factor and the  FFT Size of Modulation object
%      according to the number of subcarriers effectively transmitted
%
%      Syntax: setCarrierFreqMap( numberOfSubcarriers)
%
%      Inputs:
%           numberOfSubcarriers <int> - Number of OFDM Subcarriers 
%               AVAILABLE for one OFDM Symbol
%
%   Author: Rafhael Medeiros de Amorim (RMA)
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v1.0 03 Mar 2015 (RMA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    properties ( GetAccess = 'public', SetAccess = 'protected')
        downsamplingFactor
        cyclicPrefixLengthFirstSymbol
        cyclicPrefixLength
        subcarrierFreqMap
        numberOfSlots
        ofdmSymbolsPerSlot
    end
    
    methods (Access = public)
        
    %% constructor
        function this = LteOfdmModulation( LTE, lteFrameAssembler )
            
            
        % if number of subcarries is not assigned, object attributes are still not set:
            this.fftMaxSize = LTE.MODULATOR.MAX_FFT_SIZE;
            this.fftSize = this.fftMaxSize;
            
            if LTE.CYCLIC_PREFIX == enum.modem.lte.CyclicPrefix.NORMAL
            %Downsampling CP Samples
                this.cyclicPrefixLength = LTE.MODULATOR.NORMAL_CYCLIC_PREFIX_SAMPLES;
                this.cyclicPrefixLengthFirstSymbol = LTE.MODULATOR.NORMAL_FIRST_SYMBOL_CYCLIC_PREFIX_SAMPLES;
                
            elseif LTE.CYCLIC_PREFIX == enum.modem.lte.CyclicPrefix.EXTENDED
            %Downsampling CP Samples
                this.cyclicPrefixLength = LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES;
                this.cyclicPrefixLengthFirstSymbol = LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES;
            end
            
            this.subcarrierFreqMap = []; %Initialize the Carrier Freq. Map
            this.downsamplingFactor = 1;
            this.samplingRate = LTE.SAMPLING_RATE;
            
        % Attribute the number of Subcarriers to be transmitted
            this.setCarrierFreqMap( lteFrameAssembler.subcarriers );
            this.numberOfAntennas = lteFrameAssembler.numberOfAntennas;
            this.numberOfSlots = lteFrameAssembler.numberOfSlotsPerSubframe;
            this.ofdmSymbolsPerSlot = lteFrameAssembler.ofdmSymbolsPerSlot;
            this.centerFrequency = [];
        end
        
    %% modulate
        serialModulatedSignal = modulate(this, transmittedFrame );
        
        setCarrierFreqMap(this, numberOfSubcarriers);

        
    end
    
end

