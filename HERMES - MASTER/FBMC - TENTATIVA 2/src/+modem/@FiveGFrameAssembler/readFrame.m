function [ dataVector, noiseVarianceOutput ] = readFrame( this, rxFrame, noiseVariance )
%FIVEGFRAMEASSEMBLER.READFRAME reads data from a frame
%   Description at FrameAssembler class header
%
%   Author: Andre Noll Barreto
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org.br
%   History:
%   	v1.0 20 Apr 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


% Check if it is possible to create the FrameMap
if isempty( this.numberOfAntennas )
    error('The number of Rx Antennas is not assigned in 5G Frame Assembler')
end

% Initializes the output vector
dataVector = zeros ( this.usedSymbols ,  this.numberOfAntennas  );
noiseVarianceOutput = zeros ( this.usedSymbols ,  this.numberOfAntennas  );
% include guard symbols
frame = zeros ( this.blockSize, this.numberOfBlocks, ...
                this.numberOfAntennas );
noiseVarianceAux = zeros ( this.blockSize, this.numberOfBlocks, ...
                this.numberOfAntennas );
            
frame (:, this.frameMap( 1, : ) ~= ...
          enum.modem.fiveG.FrameMap.GUARD, : ) = rxFrame;
noiseVarianceAux (:, this.frameMap( 1, : ) ~= ...
          enum.modem.fiveG.FrameMap.GUARD, : ) = noiseVariance;

switch this.numberOfAntennas
    case 1
        % Data Symbols
        dataVector( : , 1 ) = frame( this.dataPositions( 1 : this.usedSymbols ) ); 
        noiseVarianceOutput( : , 1 ) = noiseVarianceAux( this.dataPositions( 1 : this.usedSymbols ) );
        
    case 2
        % Not implemented
    case 4
        % Not implemented
    case 8
        % Not implemented
end


end



