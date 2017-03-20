function [ precodedSymbols ] = precodeOpenLoop( this, modulationSymbols )
%SPATIALCODER.PRECODEOPENLOOP prepares the symbols for spatial multiplexing.
%   For large-delay cyclic delay diversity (CDD), precoding for spatial
%   multiplexing is defined by this method, according to [1]. The values of
%   the precoding matrix PM shall be selected among the precoder elements
%   in the codebook.
% 
%   For 2 antennas, the precoder is selected according to
%   PM = C1, where C1 denotes the precoding matrix corresponding to
%   precoder index 0 in Table 6.3.4.2.3-1 in [1].

%   For 4 antennas, the UE may assume that the eNodeB cyclically assigns
%   different precoders to different vectors X( :, sym ) on the PDSCH as
%   follows. A different precoder is used every v vectors, where v denotes
%   the number of transmisssion layers. In particular, the precoder is
%   selected according to PM(sym) = Ck, where k is the precoder index given
%   by k = mod( sym/v, 4 )+1 \in {1,2,3,4} and C1, C2, C3, C4 denote
%   precoder matrices corresponding to precoder indices 12, 13, 14 and 15,
%   respectively, in Table 6.3.4.2.3-2 in [1].
% 
%   [1] 3GPP TS 36.211 v10.7.0 Release 10
% 	
%   Syntax: [ precodedSymbols ] = precodeOpenLoop( modulationSymbols )
%   	Prepare transmit data symbols to MIMO transmission.
%       Input:
%           modulationSymbols < Nsym x 1 complex > - modulated codewords.
%               Nsym: number of codeword symbols.
%       Output:
%           precodedSymbols < Nsym x Ntx complex > - precoded codewords.
%               Nsym: number of symbols transmitted in each antenna.
%               Ntx: number of transmit antennas.
% 
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 12 May 2015 (FF) - created
%	
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%	
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

numberOfLayers = this.numberOfTxAntennas;

assert( isequal( numberOfLayers, 2 ) || isequal( numberOfLayers, 4 ) );

% layer map: nTx layers, 1 codeword
X = reshape( modulationSymbols, numberOfLayers, [] );

% matrix U from table 6.3.4.2.2-1 in [1]
U = lookupTables.modem.lte.getLargeDelayCddMatrixU( numberOfLayers );

% initialize output
precodedSymbols = U * X;

D = cell( 1, numberOfLayers );
for lyr = 1 : numberOfLayers
    
    D{ lyr } = lookupTables.modem.lte.getLargeDelayCddMatrixD( numberOfLayers, lyr );
    precodedSymbols( :, lyr : numberOfLayers : end ) = D{ lyr } * precodedSymbols( :, lyr : numberOfLayers : end );
    
end

precodingMatrix = cell( 1, numberOfLayers );
% According to [1] Sec. 6.3.4.2.2, p.59, the codebook index is given by:
switch numberOfLayers
    case 2
        codebookIndex = 0;
        % Precoding matrix as defined in [1] Sec. 6.3.4.3, p. 61
        precodingMatrix{ 1 } = lookupTables.modem.lte.getPrecodingMatrix( this.mimoScheme, ...
                                                        this.numberOfTxAntennas, ...
                                                        codebookIndex, ...
                                                        numberOfLayers );
        precodedSymbols = precodingMatrix{ 1 } * precodedSymbols;
        
    case 4
        sym = 1 : size( X, 2 );
        codebookIndex = mod( floor( sym / numberOfLayers ), 4 ) + 12;
        
        for sym = 1 : size( X, 2 )

            % Precoding matrix as defined in [1] Sec. 6.3.4.3, p. 61
            precodingMatrix = lookupTables.modem.lte.getPrecodingMatrix( this.mimoScheme, ...
                                                            this.numberOfTxAntennas, ...
                                                            codebookIndex( sym ), ...
                                                            numberOfLayers );

            precodedSymbols( :, sym ) = precodingMatrix * precodedSymbols( :, sym );
            
        end

end

% transpose to standard format
precodedSymbols = precodedSymbols.';

end

