function encodedBits = encode( this, bits )
%CONVOLUTIONALCODE.ENCODE Encodes the Tx Array using Convolutional Encoder
%   Detailed description can be found in class header.
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 31 Mar 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% Variables Iniatlization:
nextStates = this.trellis.nextStates;
nextOutputs = this.trellis.nextOutput;

encodedPacket  = this.convEncoderMex( bits, nextStates , nextOutputs );
% Encoded Bits Packet:
encodedBitsPacket = de2bi( encodedPacket', 'left-msb' );
encodedBits = reshape ( encodedBitsPacket' , 1 , [] );



end