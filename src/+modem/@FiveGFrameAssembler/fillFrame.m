function [ txFrame ] = fillFrame(this, dataVector )
%FIVEGFRAMEASSEMBLER.FILLFRAME fills a frame with data
%   Description at FrameAssembler class header
%
%   Author: Andre Noll Barreto
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org.br
%   History: 
%   	v1.0 10 Apr 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


% Initialize the output Matrix (frameTx)
txFrame = zeros( this.blockSize, this.numberOfBlocks );

% Check the number of Tx Antennas
switch this.numberOfAntennas
    case 1
        this.usedSymbols = length(dataVector);
        %Assign data Symbols to the positions
        txFrame( this.dataPositions( 1 : this.usedSymbols ) ) = dataVector; 
        
        % assign random QPSK symbols to the control positions
        numberOfCtrlSymbols = length (this.controlPositions);
        controlSymbols =  ( 2 * ( this.rnd.randi ( 2, 1, numberOfCtrlSymbols ) ) - 3 + ...
            ( 2 * ( this.rnd.randi ( 2, 1, numberOfCtrlSymbols ) ) - 3 ) * 1i ) / ...
            sqrt( 2 );
        txFrame( this.controlPositions ) = controlSymbols;
        
        % assign random QPSK symbols to the reference positions
        numberOfRefSymbols = length( this.refPositions );
        refSymbols =  ( 2 * ( this.rnd.randi ( 2, 1, numberOfRefSymbols ) ) - 3 + ...
            ( 2 * ( this.rnd.randi ( 2, 1, numberOfRefSymbols ) ) - 3 ) * 1i ) / ...
            sqrt( 2 );
        txFrame( this.refPositions ) = refSymbols;        
        
        % calculate effective data load
        this.dataLoad = length( dataVector ) / ...
                        ( length( dataVector ) + ...
                          numberOfCtrlSymbols + numberOfRefSymbols );

    otherwise
        error('5G Frame Assembler is not implemented for the selected number of Tx Antennas');
end


% remove guard symbols
guardBlocks = ( this.frameMap( 1,:) == ...
                enum.modem.fiveG.FrameMap.GUARD );
txFrame(:, guardBlocks ) = [];            

end



