function setEncodedPacketSize( this, LTE, frameAssembler, modulationOrder )
%LTEENCODER.SETENCODEDPACKETSIZE sets the expected encoded packet size.
%  This function calculates based on modulation order and in Frame Map, the
%  number of expected bits in the output of the encoder after rate matching
%  for each packet.
%  Reference: 3GPP TS 36.212 V12.4.0

%   Syntax: setEncodedPacketSize( this, LTE, frameAssembler, modulationOrder )
%   Inputs: frameAssembler < 1x1 modem.LteFrameAssembler >
%           modulationOrder < int >: Number of Bits expected per modulated
%               Symbol.
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 27 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Load Frame Settings: 
frameMap = frameAssembler.frameMap;                
subcarriersPerPrb = frameAssembler.subcarriersPerPrb;
ofdmSymbolsPerSubframe = frameAssembler.ofdmSymbolsPerSubframe;
subframes = frameAssembler.numberOfSubframes;

% Load Frame Map:
[ frameSubcarriers, frameOfdmSymbols ] = size( frameMap ); 

% Load number of Prbs and Number of Tx Transport Blocks:
totalNumOfPrbs = frameSubcarriers / subcarriersPerPrb;
numOfTransportBlocks = floor( totalNumOfPrbs / LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK ) ; 

%Number of Resources Used per Transport Block Transmitted:
symbolsPerSubframe = frameAssembler.ofdmSymbolsPerSubframe;
subcarriersPerTranspBlock = LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK * frameAssembler.subcarriersPerPrb;

% Pointer Initialization
symbolIndex = 1; % Pointer to the OFDM Symbol

% Output Initialization
this.txBlockSize = zeros( numOfTransportBlocks, this.numberOfCodeBlocks, subframes ); 
for subframeCount = 1 : subframes
    subcarrierIndex = 1;
    for transpBlockCount = 1: numOfTransportBlocks
        % Check the Map for the PRBs of current Transport Block:
        blockMap = frameMap( subcarrierIndex : subcarrierIndex + subcarriersPerTranspBlock - 1, ...
                              symbolIndex : symbolIndex + symbolsPerSubframe - 1  );
        subcarrierIndex = subcarrierIndex + subcarriersPerTranspBlock;
        % Check the available symbols to be transmitted for this Transport
        % Block:
        availableSymbolsPerTranspBlock = ...
                                length( find( blockMap == enum.modem.lte.FrameMap.PDSCH ) );
        % Auxiliar Variable used to determine the number of code blocks
        % with each size [ 1 ]
        gamma = mod( availableSymbolsPerTranspBlock, this.numberOfCodeBlocks );
        
        % Set the number of bits selected of each code block [ 1 ]:
        for codeBlockCount = 1: this.numberOfCodeBlocks
              if ( (codeBlockCount - 1 ) <= this.numberOfCodeBlocks - gamma - 1 )
                  encodedBlockSize = log2( modulationOrder ) * ... 
                      floor( availableSymbolsPerTranspBlock / this.numberOfCodeBlocks );
              else
                  encodedBlockSize = log2( modulationOrder ) * ... 
                      ceil( availableSymbolsPerTranspBlock / this.numberOfCodeBlocks );
              end
              
           this.txBlockSize( transpBlockCount, codeBlockCount, subframeCount ) = ...
                                                                encodedBlockSize;                                 
        end
        
    end
    symbolIndex = symbolIndex + symbolsPerSubframe;
end

