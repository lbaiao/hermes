function [ precodedSymbols ] = precodeTxDiversity( this, modulationSymbols )
%SPATIALCODER.PRECODETXDIVERSITY prepares the symbols for tx diversity.
%   According to the number of antennas, a different scheme of transmit
%   diversity may be used.
% 	
%   Syntax: [ precodedSymbols ] = precode( modulationSymbols )
%   	Prepare transmit data symbols to MIMO transmission.
%   Input:
%   	modulationSymbols < Nsym x 1 complex > - modulated codewords.
%           Nsym: number of codeword symbols.
% 	Output:
%   	precodedSymbols < Nsym x Ntx complex > - precoded codewords.
%       	Nsym: number of symbols transmitted in each antenna.
%       	Ntx: number of transmit antennas.
% 
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 23 Apr 2015 (FF) - created
%	
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%	
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

nTx = this.numberOfTxAntennas;

assert( isequal( nTx, 2 ) || isequal( nTx, 4 ) );

% layer map
X = reshape( modulationSymbols, nTx, [] );

% Alamouti precoding matrix
precodingMatrix = lookupTables.modem.lte.getPrecodingMatrix( this.mimoScheme, nTx );

% precoding operation
X0 = [ real( X ) ; ...
       imag( X ) ];
Y = precodingMatrix * X0;
precodedSymbols = reshape( Y, nTx, [] ).';

end

