function [ precodedSymbols ] = precodeNone( this, modulationSymbols )
%SPATIALCODER.PRECODENONE is a dummy method for non-MIMO precode.
%   
%       Syntax: [ precodedSymbols ] = precodeNone( modulationSymbols )
%           Dummy precode to non-MIMO transmission.
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
%       v2.0 15 Jun 2015 (FF) - created
%	
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%	
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    precodedSymbols = modulationSymbols;

end

