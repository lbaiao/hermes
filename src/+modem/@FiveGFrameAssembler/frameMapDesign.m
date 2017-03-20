function frameMapDesign ( this )
%FIVEGFRAMEASSEMBLER.FRAMEMAPDESIGN  map design for frame assembling
%   Design the Map for Frame Assembler/Disassembler
%   Frame Map Design is performed to create 'frameMap' attribute.
%   Currently, 'frameMap' Design assigns control, reference and data
%   symbols, as well as guard intervals, 
%
%   syntax: frameMapDesign( )
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org.br
%   History:
%   	v1.0 20 Apr 2015 (AB) - created
%     
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


if isempty(this.numberOfAntennas)
    error('The number of Rx Antennas is not assigned in 5G Frame Receiver')
end

switch( this.numberOfAntennas )
    case 1
        this.numberOfBlocks = sum ( this.fieldLength );
        
        % create frameMap, i.e., define which kind of information is
        % transmitted at each symbol/subcarrier
        this.frameMap( 1:this.blockSize, 1:this.numberOfBlocks ) = ...              
                                    enum.modem.fiveG.FrameMap.EMPTY_SYMBOL;
        symbol = 1;
        for field = 1 : length ( this.frameFields )
            % verify information type for each symbol, assign all
            % subcarriers in the symbol to a given type
            lastSymbol = symbol + this.fieldLength( field ) - 1;
            this.frameMap( :, symbol : lastSymbol) = this.frameFields( field );
            symbol = lastSymbol + 1;
        end
        
        % calculate number of modulation blocks allocated to each type
        % consider that each symbol ha sonly one kind of information 
        this.numberOfDlControlBlocks = sum ( this.frameMap(1,:) == ...
            enum.modem.fiveG.FrameMap.DL_CONTROL );
        this.numberOfUlControlBlocks = sum ( this.frameMap (1,:) == ...
            enum.modem.fiveG.FrameMap.UL_CONTROL );
        this.numberOfReferenceBlocks = sum ( this.frameMap (1,:) == ...
            enum.modem.fiveG.FrameMap.REF_SIGNAL );
        this.numberOfDataBlocks = sum ( this.frameMap (1,:) == ...
            enum.modem.fiveG.FrameMap.DATA );
        this.numberOfUsefulBlocks = this.numberOfDlControlBlocks + ...
                                    this.numberOfUlControlBlocks + ...
                                    this.numberOfReferenceBlocks + ...
                                    this.numberOfDataBlocks;
        
        this.numberOfGuardPeriods = sum ( this.frameMap (1,:) == ...
                                          enum.modem.fiveG.FrameMap.GUARD );
        
        % calculate frame duration
        this.duration = this.numberOfUsefulBlocks * this.symbolLength + ...
                        this.guardLength * this.numberOfGuardPeriods;
             
        this.availableDataSymbols = this.numberOfDataBlocks * ...
                                    this.blockSize;
        
        % get indices of data symbols
        this.dataPositions = find ( this.frameMap == ...
                                    enum.modem.fiveG.FrameMap.DATA );
                           
        % get indices of control symbols
        switch this.frameType
            case enum.modem.fiveG.FrameType.DOWNLINK
                this.controlPositions = find ( this.frameMap == ...
                    enum.modem.fiveG.FrameMap.DL_CONTROL );
            case enum.modem.fiveG.FrameType.UPLINK;
                this.controlPositions = find ( this.frameMap == ...
                    enum.modem.fiveG.FrameMap.UL_CONTROL );                
            otherwise
                error('invalid link')
        end
        
        % get indices of reference symbols
        this.refPositions = find ( this.frameMap == ...
                    enum.modem.fiveG.FrameMap.REF_SIGNAL );
                
                
        this.availableControlSymbols = length( this.controlPositions );

                           
    otherwise
        error('number of antennas not supported')
end


end
        
        
