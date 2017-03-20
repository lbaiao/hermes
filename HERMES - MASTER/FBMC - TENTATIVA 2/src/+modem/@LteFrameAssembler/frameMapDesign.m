function frameMapDesign ( this )
%LTEFRAMEASSEMBLER.FRAMEMAPDESIGN  map design for frame assembling
%   Design the Map for Frame Assembler/Disassembler
%   Frame Map Design is performed to create 'frameMap' attribute.
%   Currently, 'frameMap' Design assigns PDSCH, PDCCH, PBCH and Reference
%   and Sync signals positions in the frame, according to what is defined in
%   the STANDARD 3GPP TS 36.104-V12.6.0.
%   *Only TDD assignment is implemented.
%   *Currently Special Subframe Config 0 is considered for LTE TDD
%
%   syntax: frameMapDesign( )
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%   	v1.0 04 Mar 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


if isempty(this.numberOfAntennas)
    error('The number of Rx Antennas is not assigned in LTE Frame Receiver')
end

% Initializes the output vector
% Initialize frameMap to fill it as an array of enum objects
this.frameMap = enum.modem.lte.FrameMap.EMPTY_SYMBOL;
this.frameMap( 1 : this.subcarriers, ...
    1 : this.ofdmSymbolsPerSubframe * this.numberOfSubframes ) = ...
    enum.modem.lte.FrameMap.EMPTY_SYMBOL;

% Check which subframes are assigned to Downlink
downlinkSubframes = ( find ( this.subframesDirection == 'D' ) );

% PDCCH Assignment.
% DEFINED IN STANDARD 3GPP TS 36.104-V12.6.0,
% Section 6.8, Page 77
for ofdmSymbol = 1:this.pdcchLength % For each OFDM Symbol in PDCCH length...
    % ... check the PDCCH symbol position in all DL Subframes;
    pdcchSymbol = ( downlinkSubframes - 1 ) * this.ofdmSymbolsPerSubframe + ofdmSymbol;
    this.frameMap( : , pdcchSymbol) = enum.modem.lte.FrameMap.PDCCH; % Assign as PDCCH Position.
end

%PDSCH Assignment
% DEFINED IN STANDARD 3GPP TS 36.104-V12.6.0,
% Section 6.4, Page 73
for ofdmSymbol = this.pdcchLength + 1 : this.ofdmSymbolsPerSubframe % For all OFDM Symbols not reserved to PDCCH...
    pdschSymbol = ( downlinkSubframes - 1 ) * this.ofdmSymbolsPerSubframe + ofdmSymbol; % ... in all downlink subframes...
    this.frameMap( : , pdschSymbol) = enum.modem.lte.FrameMap.PDSCH; % ... assign as a PDSCH Position.
end

% PBCH
% DEFINED IN STANDARD 3GPP TS 36.104-V12.6.0,
% Section 6.6, Page 74
k = 1:72; % As defined in the reference formula
ofdmSymbolsPerSlot = this.ofdmSymbolsPerSubframe / 2; % Number of OFDM Symbols per Slot
pbchSymbolsIndex = ofdmSymbolsPerSlot + 1 : ofdmSymbolsPerSlot + 4; % OFDM Symbols 0-3, in  Slot 1 (subframe 0).
this.frameMap ( this.subcarriers / 2 - 36 + k, pbchSymbolsIndex) = enum.modem.lte.FrameMap.PBCH; % Assign as PBCH positions

% Synchronization Signals
% DEFINED IN STANDARD 3GPP TS 36.104-V12.6.0,
% Section 6.11, Page 109
% PSS - Primary Synchronization Signal
k = ( -4 : 67 ) - 31 + this.subcarriers / 2; %As defined in the reference formula
pssSymbolsIndex = this.ofdmSymbolsPerSubframe * [ 1 6 ]+3; % OFDM Symbol 3, of Subframes 1 and 6.
this.frameMap ( k , pssSymbolsIndex ) = enum.modem.lte.FrameMap.SYNC_SIGNAL; % Assign as Sync Signal Position
% SSS - Secondary Synchronization Signal
sssSymbolsIndex = ofdmSymbolsPerSlot * [ 1 11 ] + ofdmSymbolsPerSlot; % Last OFDM Symbol, of Slots 1 and 11.
this.frameMap ( k , sssSymbolsIndex ) = enum.modem.lte.FrameMap.SYNC_SIGNAL; % Assign as Sync Signal Position


%Cell Specific Reference Signals
% DEFINED IN STANDARD 3GPP TS 36.104-V12.6.0,
% Section 6.10.1, Page 87

switch this.numberOfAntennas
    case 1
        refSeqSize =  0 : 2 * ( this.prbs  )- 1 ; %Ref. Signal Sequence Size, as defined in the reference
        
        % Symbols 0 of every DL Slot
        ofdmSymbolsRefSignals ( 1 , : ) = ...
            [ ( downlinkSubframes - 1 ) * ...
            this.ofdmSymbolsPerSubframe ( downlinkSubframes - 1 ) * ...
            this.ofdmSymbolsPerSubframe + ofdmSymbolsPerSlot ] + 1;
        % 3rd OFDM Symbol of every DL Slot (counting back from the end)
        ofdmSymbolsRefSignals ( 2 , : ) = ...
            [ ( downlinkSubframes - 1 ) * ...
            this.ofdmSymbolsPerSubframe ( downlinkSubframes - 1 ) * ...
            this.ofdmSymbolsPerSubframe + ...
            ofdmSymbolsPerSlot] + ofdmSymbolsPerSlot - 2;
        
        % Parameters for Ref. Signal Position, as defined in reference formula
        vShift = mod ( 3 , this.cellNumberId );
        v = [ 0 3 ];
        
        for refSymbol = 1 : 2
            % Calculate Ref. Signal Positions as the formula defined in 3GPP TS 36.104-V12.6.0 page 88
            k =  6 * refSeqSize + mod ( v ( refSymbol ) + vShift , 6 ) + 1;
            this.frameMap( k , ofdmSymbolsRefSignals ( refSymbol , : ) ) = ...
                enum.modem.lte.FrameMap.REF_SIGNAL ; %Assign as Ref. Symbol Positions
            
        end
        
        
        %% Check the Physical Channels  and Signals Positions in Each Subframe
        % Initialization:
            this.dataPositions  = cell(1, this.numberOfSubframes );
            this.controlPositions = cell(1, this.numberOfSubframes );
            this.bchPositions  = cell(1, this.numberOfSubframes );
            this.syncPositions = cell(1, this.numberOfSubframes );
            this.refPositions = cell(1, this.numberOfSubframes );
        
            this.availableDataSymbols = zeros(1, this.numberOfSubframes );
            this.availableControlSymbols = zeros(1, this.numberOfSubframes );
            
            subframeFirstSymbol = 1;
            subframeLastSymbol = this.ofdmSymbolsPerSubframe;
        for subframe = 1: this.numberOfSubframes
            % Isolate SubframeMap:
            subframeMap = this.frameMap( : , subframeFirstSymbol : subframeLastSymbol );
            
            this.availableDataSymbols( subframe ) = length ( find( subframeMap == enum.modem.lte.FrameMap.PDSCH ) ); % Data Symbols
            this.availableControlSymbols ( subframe ) = length ( find( subframeMap == enum.modem.lte.FrameMap.PDCCH ) ); %Control Symbols
            
            % Positions for all Physical Channels and Signals in the Frame:
            this.dataPositions { subframe } = find( subframeMap == enum.modem.lte.FrameMap.PDSCH ); %Read the Data Symbols Positions
            this.controlPositions { subframe } = find( subframeMap == enum.modem.lte.FrameMap.PDCCH ); %Read the Control Symbols Positions
            this.bchPositions { subframe } = find ( subframeMap == enum.modem.lte.FrameMap.PBCH ); %Read the Broadcast Symbols Positions
            this.syncPositions { subframe } = find ( subframeMap == enum.modem.lte.FrameMap.SYNC_SIGNAL ); %Read the Sync signals Positions
            this.refPositions { subframe } = find( subframeMap == enum.modem.lte.FrameMap.REF_SIGNAL);  %Read the Ref. Signals Positions
            
            % Update Symbol Count for Next Subframe:
            subframeFirstSymbol = subframeFirstSymbol + this.ofdmSymbolsPerSubframe;
            subframeLastSymbol = subframeLastSymbol + this.ofdmSymbolsPerSubframe;
        end

    case 2
        % Not implemented
    case 4
        % Not implemented
    case 8
        % Not implemented
end


end


