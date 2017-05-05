function setPunctureVector( this, arraySize ) 
%EncoderRateMatching.setPunctureVector sets puncturing vector.
%This function adapts the puncturing vector for the real size of the
%encoded packet.
%
% Syntax: puncturedArray =  setPunctureVector ( this, arraySize ) 
% Inputs: arraySize < int >: Number of bits in the encoded array size.
%
%   Author: Rafhael Amorim (RA)
%   Work Adress: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 30 June 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% Seed: Atomic Part of the puncture pattern in column-array form:
punctureVectorSeed = reshape( this.puncturePattern, [], 1 );
% Number of times the Atomic part of the puncture should be repeated:
punctureSamples = floor( arraySize / length( punctureVectorSeed ) );
% Create the puncture vector with the size needed:
this.punctureVector = repmat( punctureVectorSeed, punctureSamples , 1);

% Check if it is necessary repeat a part of the puncture pattern due to
% a mismatch in the array size:
tail = mod( arraySize , length( punctureVectorSeed ) );
if tail ~= 0
    % Add the tail if needed:
    this.punctureVector = [ this.punctureVector; punctureVectorSeed( 1: tail) ];
end
% Convert the puncture vector from double to logic:
this.punctureVector  = this.punctureVector > 0;
end