classdef FiveGFrameAssembler < modem.FrameAssembler
%FIVEGFRAMEASSEMBLER class implements the 5G Frame  in the Tx/Rx.
%	It is a subclass from FRAMEASSEMBLER.
%
%   The frame is assembled according to the frame structure proposed in 
%   Mogensen et al, "5G small cell optimized radio design", Globecom 2013.
%   The frame consists of different fields in the time domain, where each
%   field can be allocated to DL/UL control, demodulation reference signal
%   or data. Between different fields a guard period may be included.
%
%   Read-Only Public Properties:
%       symbolLength <double> (s) - length of a useful symbol
%       guardLength <double> (s) - length of a guard period      
%       numberOfDlControlBlocks <uint> - number of modulation blocks
%               reserved for downlink control in each frame
%       numberOfUlControlBlocks <uint> - number of modulation blocks
%               reserved for uplink control in each frame
%       numberOfReferenceBlocks <uint> - number of modulation blocks
%               reserved for demodulation reference signal in each frame
%       numberOfDataBlocks <uint> - number of modulation blocks
%               reserved for user data in each frame     
%       numberOfGuardPeriods <uint> - number of guard periods in each frame
%       numberOfUsefulBlocks<uint> - number of useful modulation blocks in 
%               each frame, i.e., excluding guard periods
%       blockSize<uint> - number of useful symbols in block, i.e., in OFDM
%               it's the number of non-null subcarriers
%       frameType< enum.modem.fiveG.FrameType > - frame type
%       frameFields< 1 x N enum.modem.fiveG.FrameMap > - vector specifying
%               the fields in the frame, i.e., control, reference, guard
%               and data fields. 
%       fieldLength< 1 x N uint > number of modulation blocks in each field
%
%   Methods:
%   constructor
%       Syntax:  this = modem.FiveGFrameAssembler( FIVEG, rnd )
%       
%       Inputs:
%           FIVEG: struct with FIVEG Parameters. 
%           rnd: RandStream object
%
%   All other public methods described FrameAssembler class header.
%
%   Author: Andre Noll Barreto
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 20 Apr 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    %%
    properties ( GetAccess = 'public', SetAccess = 'protected')
        
        symbolLength;
        guardLength;
        
        % number of multicarrier blocks (considering block modulations, one
        % block == one OFDM/UFMC symbol)
        numberOfDlControlBlocks = [];
        numberOfUlControlBlocks = [];
        numberOfReferenceBlocks = [];
        numberOfDataBlocks = [];
        numberOfGuardPeriods = [];
        
        numberOfUsefulBlocks = [];

        
        blockSize;
        
        frameType;
        
        frameFields;
        fieldLength;        
    end
    
    properties ( Access = 'protected')
        
        dataPositions;
        controlPositions;
        refPositions;
        usedSymbols;

        rnd; % random number generator
 
    end
    %%
    methods ( Access = public )
        
        %% constructor
        function this = FiveGFrameAssembler( FIVEG, rnd )
            
            
            
            %% Inherited Parameters Assignment
            
            this.bandwidth_MHz = ( FIVEG.USEFUL_SUBCARRIERS + 1 ) * ...
                                   FIVEG.SUBCARRIER_SPACING / 1e6;
                             
            % Number of Tx Antennas
            this.numberOfAntennas = [];
            
            % Frame Duration
            
            switch( FIVEG.WAVEFORM.TYPE )
                case enum.modem.fiveG.Waveform.OFDM
                    samplingRate = FIVEG.SUBCARRIER_SPACING * ...
                                   FIVEG.FFT_SIZE;
                    samplesInSymbol = FIVEG.FFT_SIZE + ...
                                      FIVEG.WAVEFORM.OFDM.CYCLIC_PREFIX;
                    this.symbolLength =  samplesInSymbol / samplingRate;
                    this.blockSize = FIVEG.USEFUL_SUBCARRIERS;
                case enum.modem.fiveG.Waveform.ZT_DS_OFDM
                    this.symbolLength =  ( 1 / FIVEG.SUBCARRIER_SPACING );
                    this.blockSize = FIVEG.USEFUL_SUBCARRIERS - ...
                                     FIVEG.WAVEFORM.ZT_DS_OFDM.TAIL - ...
                                     FIVEG.WAVEFORM.ZT_DS_OFDM.HEAD;
                case enum.modem.fiveG.Waveform.FBMC
                    samplingRate = FIVEG.SUBCARRIER_SPACING * ...
                                   FIVEG.FFT_SIZE;
                    delaySamples = ( FIVEG.WAVEFORM.FBMC.OVERLAPPING_FACTOR - 1 ) / ...
                                     FIVEG.USEFUL_BLOCKS;
                    filterTail = FIVEG.WAVEFORM.FBMC.FILTER_TAIL;
                    samplesInSymbol = FIVEG.FFT_SIZE * ( delaySamples ) + ...
                                      FIVEG.FFT_SIZE/2 + ...
                                      filterTail/FIVEG.USEFUL_BLOCKS;
                    this.symbolLength = samplesInSymbol / samplingRate;
                    this.blockSize = FIVEG.USEFUL_SUBCARRIERS/2; 
                case enum.modem.fiveG.Waveform.FOFDM
                    samplingRate = FIVEG.SUBCARRIER_SPACING * ...
                                   FIVEG.FFT_SIZE;
                    samplesInSymbol = FIVEG.FFT_SIZE + ...
                                      FIVEG.WAVEFORM.OFDM.CYCLIC_PREFIX;
                    this.symbolLength =  samplesInSymbol / samplingRate;
                    this.blockSize = FIVEG.USEFUL_SUBCARRIERS;                    
                otherwise
                    error('Waveform not supported');
            end
            
            this.guardLength = FIVEG.GUARD_PERIOD;
            this.frameFields = FIVEG.FRAME;
            this.fieldLength = FIVEG.NUMBER_OF_SYMBOLS;

 
                          
            this.availableControlSymbols = []; 
            this.dataLoad = [];
            
            this.frameMap = enum.modem.fiveG.FrameMap.EMPTY_SYMBOL;
                                    

            this.frameType = FIVEG.FRAME_TYPE;
            
            this.rnd = rnd;
            
            
            
        end
        
        
    end
    
    methods( Access = 'protected' )
        %map design for frame assembling
        frameMapDesign ( this )
    end

end

