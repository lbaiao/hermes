function interleavedBitStream = interleave(this, inputBitStream)
%WIFIINTERLEAVER.INTERLEAVE Interleave bit stream according to 802.11a spec. 
%   Further details are given on the class header
%
%   Author: Bruno Faria (BF)
%   Work Adress: INDT Brasilia
%   E-mail: bruno.faria@indt.org.br
%   History:
%       v2.0 19 Jun 2015 (BF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if isempty( inputBitStream )
    interleavedBitStream = [];
    return;
end

k = 0:( this.codedBitsPerSymbol - 1 );
k = k + 1;
inputLength = length( inputBitStream );
inputBitStream = reshape( inputBitStream, this.codedBitsPerSymbol, ...
    inputLength / this.codedBitsPerSymbol );
interleavedBitStream( this.interleaverTable, : ) = inputBitStream( k, : );
interleavedBitStream = reshape( interleavedBitStream, inputLength, 1 );

end

