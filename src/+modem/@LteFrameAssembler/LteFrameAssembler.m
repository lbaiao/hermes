classdef LteFrameAssembler < modem.FrameAssembler
%LTEFRAMEASSEMBLER class implements the Frame Assembler in the Tx/Rx.
%	It is a subclass from FRAMEASSEMBLER.
%
%   Read-Only Public Properties:
%       subframeDirection < enum.modem.lte.SubframesDirection > - 
%       Contains the direction assignment for each subframe (DL/UL)
%       numberOfSubframes <int> - Number of Subframes in a frame
%       numberOfSlotsPerSubframe <int> - Number of Slots  in a subframe
%       subcarriersPerPrb < double > - Number of OFDM Subcarriers 
%                                      per PRB
%       ofdmSymbolsPerSubframe < double > - Number of OFDM Symbols 
%                                      per Subframe
%       prbs < double > - Number of PRBs
%       subcarriers < double > -  Number of OFDM Subcarriers
%       cellNumberId < double > - Cell ID
%       pdcchLength <int> - Number of OFDM Symbols used for PDCCH per
%     Subframe
%
%   Methods:
%   constructor
%       Syntax:  this = modem.LteFrameAssembler( LTE, rnd )
%       
%       Inputs:
%           LTE: struct with LTE Parameters.
%           rnd: RandStream object
%   getFrameDirection
%       Provides the transmit direction for the next subframe.
%       Syntax: frameDir = getFrameDirection( this ); 
%       Outputs: frameDir < enum.FrameDirection > - Direction assigned for
%       the next subframe, according to TDD Schedule.
%
%   fillFrame 
%       Assembles the frame with the data symbols to be transmitted.
%       *Frame filling is performed according to 'frameMap' attribute
%       of the frame object.
%       *Currently, only Data Symbols are being mapped into Tx Frame.
%        PBCH, PDCCH, Ref. Signals and Sync. Signals are following an
%       arbitrary filling.
%
%       Syntax: [ txFrame ] = fillFrame( dataVector )
%
%       Inputs:
%           dataVector < N x Msymb complex > - Vector with symbols to 
%               be transmitted in the frame
%                   N: Number of Tx Antennas
%                   Msymb: Number of Symbols to be transmitted
%
%       Output:
%            txFrame < F x T x M complex > - Assembled frame
%                   F: OFDM Subcarriers
%                   T: OFDM Symbols
%                   M: Number of Rx Antennas
%
%   readFrame 
%       Disassembles the frame and provides the DataSymbols vector
%       *Frame reading is performed according to 'frameMap' attribute
%       of the frame object.
%       *Currently, only Data Symbols are being read in the Rx Frame.
%       PBCH, PDCCH, Ref. Signals and Sync. reading is not supported
%
%       Syntax: [ dataVector ] = readFrame( rxFrame )
%
%       Inputs:
%           rxFrame < F x T x N complex > - Received frame
%                   F: OFDM Subcarriers
%                   T: OFDM Symbols
%                   N: Number of Tx Antennas
%       Output:
%           dataVector < M x Msymb complex > - Data Vector with
%                   received Symbols
%                   M: Number of Receiver Antennas
%                   Msymb: Number of Received Data Symbols
%
%   resetFrameCount
%       This method resets the attribute subframeCount for the LTE Modem.
%       Syntax: resetFrameCount()
%
%   updateFrameCount
%       This method updates the attribute subframeCount for the LTE Modem
%       in + 1. If a whole Frame has been transmitted, subframeCount is set
%       back to 1 and a new Frame Transmission starts.
%       Syntax: updateFrameCount()
%
%   getUsedSymbols
%       This method gets the usedSymbols attribute.
%       Syntax: usedDataSymbols = this.getUsedSymbols()
%       Output: 
%           usedDataSymbols < int >: number of symbols used for data
%           transmission within a frame.
%
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v1.0 24 Feb 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    %%
    properties ( GetAccess = 'public', SetAccess = 'protected')
        
        subframesDirection
        numberOfSubframes
        numberOfSlotsPerSubframe
        subcarriersPerPrb
        ofdmSymbolsPerSubframe
        prbs
        subcarriers
        cellNumberId
        pdcchLength
        ofdmSymbolsPerSlot
        rnd
        subframeCount
    end
    
    properties ( GetAccess = 'protected', SetAccess = 'protected')
        % Auxiliar Variables: storage of positions for all LTE Physical
        %   Channels and Signals:
        dataPositions
        controlPositions
        bchPositions
        syncPositions
        refPositions
        usedSymbols % Number of data symbols used in transmission. This 
                    % parameter is used to separate control symbols from
                    % data symbols used in trasmission.
    end
    %%
    methods ( Access = public )
        
        %% constructor
        function this = LteFrameAssembler( LTE, rnd )
            

            
            %% Inherited Parameters Assignment
            
            % Calculate the bandwidth
            switch LTE.DUPLEX_MODE
                case  enum.modem.lte.DuplexMode.TDD % For TDD Mode
                    this.bandwidth_MHz = LTE.BANDWIDTH_MHz;
                    
                case enum.modem.lte.DuplexMode.FDD
                    % For FDD Modem.
                    % Not ready.
                    error('FDD Frame Assembler is not implemented');
            end
            
            % Number of Tx Antennas
            this.numberOfAntennas = [];
            this.availableDataSymbols = [];
            this.availableControlSymbols = [];
            this.frameMap = [];
            
            % Frame Duration
            this.duration = LTE.FRAME_DURATION;
            
            %% LTE Specific Parameters Assignment
            % Subframes Configuration
            lookupTables.modem.lte.lookupSubframesConfig; % Load lookup Table for Subframes Configuration
            this.subframesDirection= SUBFRAMES_DIRECTION; % Assign subframes directions.
            
            %Number of Subframes
            this.numberOfSubframes = LTE.NUMBER_OF_SUBFRAMES;
            
            %Number of Slots
            this.numberOfSlotsPerSubframe = LTE.NUMBER_OF_SLOTS_PER_SUBFRAME;
            
            %Subcarriers per PRB
            this.subcarriersPerPrb = LTE.SUBCARRIERS_PER_PRB;
            
            %OFDM Symbols Per Subframe
            this.ofdmSymbolsPerSubframe = LTE.OFDM_SYMBOLS_PER_SUBFRAME;
            this.numberOfBlocks = this.ofdmSymbolsPerSubframe;
            
            %Number of PRBs Calculation
            % DEFINED IN STANDARD 3GPP TS 36.104-V12.6.0,
            % Table 5.6-1, Page 23
            if this.bandwidth_MHz == 1.4
                this.prbs = 6; % 6 PRBs for 1.4 MHz frame
            else % For other bandwidths
                this.prbs = this.bandwidth_MHz * 0.9 / ( LTE.CARRIER_SPACING_kHz * this.subcarriersPerPrb ) * 1000 ;
            end
            
            %Total number of OFDM Subcarriers
            this.subcarriers = this.subcarriersPerPrb * this.prbs;
            
            % Cell ID
            this.cellNumberId = round( LTE.MAX_CELL_ID * ( rnd.rand( 1,1) ) ); % Cell ID is being randomly calculated.
            
            %PDCCH Length
            this.pdcchLength = LTE.PDCCH_LENGTH;
            
            %OFDM Symbols Per Slot
            this.ofdmSymbolsPerSlot = this.ofdmSymbolsPerSubframe / this.numberOfSlotsPerSubframe;
            
            this.rnd = rnd;
            
            this.dataLoad = [];
            
            this.subframeCount = 1;
            
            this.usedSymbols = 0;
        end
        
      frameDir = getFrameDirection( this );  
 
    end
    %%
    methods( Access = 'protected' )
        %map design for frame assembling
        frameMapDesign ( this )
        updateFrameCount( this )
        usedDataSymbols = getUsedSymbols( this ) 
    end
end

