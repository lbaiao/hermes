function [ dataVector, noiseVariance ] = readFrame( this, rxFrame, ...
                                                    noiseVariance )
%LTEFRAMEASSEMBLER.READFRAME reads data from a frame
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



% Check if it is possible to create the FrameMap
if isempty( this.numberOfAntennas )
    error('The number of Rx Antennas is not assigned in LTE Frame Assembler')
end


lastTxSubframe = this.subframeCount -  1;
if lastTxSubframe == 0
    lastTxSubframe = this.numberOfSubframes;
end

usedDataSymbols = this.getUsedSymbols(); 
% Initializes the output vector
dataVector = zeros ( usedDataSymbols , this.numberOfAntennas );


% Check the number of Tx Antennas
switch this.numberOfAntennas
    case 1
        % Data Symbols
        
        % Check if Subframe is working in the proper direction
        if ~isempty ( this.dataPositions { lastTxSubframe } ) 
            currentDataPositions = this.dataPositions{ lastTxSubframe };
            usedDataPositions = currentDataPositions( 1 : usedDataSymbols );  
            dataVector = rxFrame( usedDataPositions  );
            noiseVariance = noiseVariance( usedDataPositions );
            
        end
        
    case 2
        % Not implemented
    case 4
        % Not implemented
    case 8
        % Not implemented
end


end



