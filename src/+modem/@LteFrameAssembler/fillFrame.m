function [ txFrame ] = fillFrame(this, dataVector )
%LTEFRAMEASSEMBLER.FILLFRAME fills a frame with data
%   Description at class header
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History: 
%   	v1.0 10 Apr 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


% Initialize the output Matrix (frameTx)
txFrame = zeros( this.subcarriers, this.ofdmSymbolsPerSubframe , this.numberOfAntennas);

% Check the number of Tx Antennas
switch this.numberOfAntennas
    case 1
        
        % Data Symbols
        if ~isempty( this.dataPositions{ this.subframeCount } )
            txFrame( this.dataPositions{ this.subframeCount } ( 1 : length(dataVector) ) ) = dataVector; %Assign data Symbols to the positions
            
            % update property that controls number of assigned symbols
            this.usedSymbols = length( dataVector );
            
            % Control Symbols
            controlSymbolsReal = 2 * ( this.rnd.randi ( 2, 1, length( this.controlPositions { this.subframeCount } ) ) ) -3;
            controlSymbolsImag = (2 * ( this.rnd.randi ( 2, 1, length( this.controlPositions { this.subframeCount } ) ) ) -3) * 1i ;
            
            %Arbitrary filling
            txFrame( this.controlPositions { this.subframeCount } ) = (controlSymbolsReal + controlSymbolsImag) * ( 1 / sqrt(2) );
            
            % Broadcast Symbols
            bchSymbolsReal = 2 * ( this.rnd.randi ( 2, 1, length( this.bchPositions { this.subframeCount } ) ) ) - 3;
            bchSymbolsImag = (2 * (this.rnd.randi ( 2, 1, length( this.bchPositions { this.subframeCount } ) ) ) -3) * 1i ;
            
            %Arbitrary filling
            txFrame( this.bchPositions { this.subframeCount } ) = ( bchSymbolsReal + bchSymbolsImag ) * ( 1 / sqrt(2) );
            
            %Sync Signals
            syncSymbolsReal = 2 * ( this.rnd.randi ( 2, 1, length( this.syncPositions { this.subframeCount } ) ) ) - 3;
            syncSymbolsImag = (2 * ( this.rnd.randi ( 2, 1, length( this.syncPositions { this.subframeCount } ) ) ) - 3) * 1i ;
            
            %Arbitrary filling
            txFrame( this.syncPositions { this.subframeCount } ) = ( syncSymbolsReal +  syncSymbolsImag ) * ( 1 / sqrt (2));
            
            %Ref Signals
            refymbolsReal = 2 * ( this.rnd.randi ( 2, 1, length( this.refPositions { this.subframeCount } ) ) ) -3;
            refSymbolsImag = (2 * ( this.rnd.randi ( 2, 1, length( this.refPositions { this.subframeCount } ) ) ) -3) * 1i ;
            
            %Arbitrary filling
            txFrame( this.refPositions { this.subframeCount } ) = ( refymbolsReal + refSymbolsImag  ) * ( 1 / sqrt(2) );
            
            this.dataLoad = length( dataVector ) / ...
                ( length( dataVector ) + ...
                length( this.controlPositions { this.subframeCount } ) + ...
                length( this.bchPositions { this.subframeCount } ) + ...
                length( this.syncPositions { this.subframeCount } ) + ...
                length( this.refPositions { this.subframeCount } ) );
        else
            this.dataLoad = 0;
            txFrame = [];
            this.usedSymbols = 0;
        end
        
    otherwise
        error('LTE Frame Assembler not implemented for the selected number of Tx Antennas');
end

   this.updateFrameCount();
end



