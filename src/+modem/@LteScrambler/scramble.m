function transmittedSequence = scramble( this, inputSequence )
%LTESCRAMBLER.SCRAMBLE scrambles input data according to TS 36.211 v12.3.0 
%   Further details are given on the class header
%
%   Author: Erika Almeida (EA)
%   Work Adress: INDT Brasilia
%   E-mail: erika.almeida@indt.org.br
%   History:
%       v2.0 05 May 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


if isempty( inputSequence )
    transmittedSequence = [];
    return;
end

this.update2ndPolyInitialValue( this.frame.subframeCount );

% Standard defined code shift Nc
codeShift = 1600;

% data array length
packetLength = length( inputSequence );
    
% initialize the cell that will store the golden sequences for each packet
this.scramblingSequences = zeros( size( inputSequence ) );

% initialization of the pseudo-random sequence
c_n = zeros( packetLength + codeShift, 1 );

% initialization of both polynoms
x_1 = [ this.firstPolyInitialConditions; ...
    zeros( packetLength + codeShift - ...
    length( this.firstPolyInitialConditions ), 1) ];
x_2 = [ this.secondPolyInitialConditions; ...
    zeros( packetLength + codeShift - ...
    length( this.secondPolyInitialConditions ), 1 )];

% loop over the length of packet bits
for bit = 1 : packetLength + codeShift
    
    % 1st Poly
    x_1( bit + 31 ) = mod( x_1( bit + 3 ) + x_1( bit ), 2 );
    
    % 2nd Poly
    x_2( bit + 31 ) = mod( x_2( bit + 3 ) + x_2( bit + 2 ) + ...
        x_2( bit + 1 ) + x_2( bit ), 2 );
end

% build Gold sequence
for bit = 1 : packetLength
    
    c_n( bit ) = mod( x_1( bit + codeShift ) + x_2( bit + codeShift ), 2 );
    
end

c_n = c_n( 1 : end - codeShift );

% stores Gold Sequence
this.scramblingSequences = c_n;

% scrambles the signal
transmittedSequence = xor( inputSequence , c_n );

end
