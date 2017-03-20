classdef FiveGBlockModulation < modem.BlockModulation
% FIVEGBLOCKMODULATION class implements (de)modulation for 5G waveforms
%   The Modulation object is responsible for transmission and reception of
%   an 5G OFDM frame, i.e., it converts a frame into a waveform and
%   vice-versa.
%   The methods "modulate" and "demodulate" can handle one frame per
%   call.
%
%   Read-Only Public Properties:
%       apart from the properties defined in BlockModulation, the following
%       properties are available:
%       wafevorm < enum.modem.fiveG.Waveform > - waveform type
%       subcarrierFreqMap < 1xNsc int> - Map the Nsc data subcarriers into
%           their frequency positions.
%       samplesInPrefix < int > - samples in cyclic/zero prefix
%       samplesInTail < int > - samples in block postfix
%
%   Methods
%
%   constructor
%       Syntax: this = modem.FiveGOfdmModulation( FIVEG, frameAssembler )
%
%       Inputs:
%           FIVEG - struct with 5G Parameters, with the following fields
%                   (at least)
%                .WAVEFORM.TYPE < enum.modem.fiveG.Waveform >
%                .FFT_SIZE < int > 
%                .SUBCARRIER_SPACING < double > (Hz)
%                .USEFUL_SUBCARRIERS < int > - number of non-null
%                   subcarrierrs
%                .WAVEFORM.'NAME' < struct > - waveform specific parameters                   
%           frameAssembler <FiveGFrameAssembler Object> - frame structure
%
%   Other methods described in BlockModulation class header
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v2.0 22 Apr 2015 (AB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
properties ( GetAccess = 'public', SetAccess = 'protected')
    waveform
    subcarrierFreqMap
    samplesInPrefix = [] 
    samplesInTail = []
    filterTail = []
    prototypeFilter
    
end

properties (Access = 'protected')
    frame % frame assembler
    samplesInFrame % samples in a whole frame
    samplesInSymbol % samples in an useful symbol
    samplesInGuard % samples in a guard period
    usefulSamplesIndex % indices of useful samples, i.e., excluding guard interval
    
end


methods (Access = public)

%% constructor
    function this = FiveGBlockModulation( FIVEG, fiveGFrameAssembler )
        
        this.frame = fiveGFrameAssembler;
        
        this.waveform = FIVEG.WAVEFORM.TYPE;
        
        this.fftMaxSize = FIVEG.FFT_SIZE;
        this.fftSize = this.fftMaxSize;
        

        this.subcarrierFreqMap = []; %Initialize the Carrier Freq. Map                              
        this.samplingRate = FIVEG.SUBCARRIER_SPACING * FIVEG.FFT_SIZE;

        % Attribute the number of Subcarriers to be transmitted
        % Map the used subcarriers into frequencies
        auxFreqShift = FIVEG.USEFUL_SUBCARRIERS / 2;
        this.subcarrierFreqMap = [ this.fftSize - auxFreqShift + 1 : ...
                                   this.fftSize , ...
                                   2 : auxFreqShift + 1  ];
                       
        this.numberOfAntennas = this.frame.numberOfAntennas;
        this.centerFrequency = [];
        
        % waveform-specific parameters
        switch this.waveform
            case enum.modem.fiveG.Waveform.OFDM
                this.samplesInSymbol = FIVEG.FFT_SIZE + ...
                                       FIVEG.WAVEFORM.OFDM.CYCLIC_PREFIX;
                this.samplesInPrefix = FIVEG.WAVEFORM.OFDM.CYCLIC_PREFIX;
  
            case enum.modem.fiveG.Waveform.ZT_DS_OFDM
                this.samplesInSymbol = FIVEG.FFT_SIZE;
                this.samplesInTail = FIVEG.WAVEFORM.ZT_DS_OFDM.TAIL;
                this.samplesInPrefix = FIVEG.WAVEFORM.ZT_DS_OFDM.HEAD;
            case enum.modem.fiveG.Waveform.FBMC
                [this.prototypeFilter.filter, ...
                 this.prototypeFilter.filterParameters] = ...
                 constructFilter(this, FIVEG.WAVEFORM.FBMC.OVERLAPPING_FACTOR );
                delaySamples = ( FIVEG.WAVEFORM.FBMC.OVERLAPPING_FACTOR - 1 ) / ...
                                 this.frame.numberOfUsefulBlocks;
                this.filterTail = FIVEG.WAVEFORM.FBMC.FILTER_TAIL;
                this.samplesInSymbol = FIVEG.FFT_SIZE * ( delaySamples ) + ...
                                       FIVEG.FFT_SIZE/2 + ...
                                       this.filterTail/this.frame.numberOfUsefulBlocks;                                 
            
            otherwise
                error('waveform not supported')
        end
        this.samplesInGuard = round( this.frame.guardLength * ...
                                     this.samplingRate );
         
        this.samplesInFrame = this.samplesInSymbol * ...
        this.frame.numberOfUsefulBlocks + ...
        this.samplesInGuard * ...
        this.frame.numberOfGuardPeriods;
    
        % determine samples corresponding to useful information
        % (i.e., excluding guard interval)       
        firstSample = 1;
        this.usefulSamplesIndex = true( 1, this.samplesInFrame );
        for field = 1:length( this.frame.frameFields )
            if this.frame.frameFields( field ) == ...
               enum.modem.fiveG.FrameMap.GUARD
                lastSample = firstSample + this.samplesInGuard * ...
                             this.frame.fieldLength( field ) - 1;
                this.usefulSamplesIndex( firstSample : lastSample ) = false;
            else
                lastSample = firstSample + this.samplesInSymbol * ...
                             this.frame.fieldLength( field )- 1;
            end
            firstSample = lastSample + 1;
        end       
        
    end

    [prototypeFilter, filterParameters] = constructFilter( this, overlappingFactor );
    [filteredSignal, polyphaseSynthesisFilter] = synthesisFilterBank( this, signalInFreq );
    serialModulatedSignal = modulate(this, transmittedFrame );
    [receivedSignal, polyphaseAnalysisFilter ] = analysisFilterBank( this, serialReceivedSignal );
    oqamModSignal = oqamPreProcessing(this, dataSymbols );
    oqamDemodSignal = oqamPostProcessing(this, oqamSymbols );

    
    
end

end

