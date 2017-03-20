function transmittedSequence = scramble( this, inputSequence )
%SCRAMBLER.SCRAMBLE scrambles input data with a random sequence
%   Further details are given on the class header
%
%   Author: Erika Almeida (EA)
%   Work Adress: INDT Brasilia
%   E-mail: erika.almeida@indt.org.br
%   History:
%       v2.0 07 May 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


% initialize the cell that will store the golden sequences for each packet
this.scramblingSequences = size( inputSequence );

firstPositionsPoly1 = this.rnd.randi([0,1], [5,1] );

% avoid sequences where all elements equal 0
while all( firstPositionsPoly1 == 0 ) 
    firstPositionsPoly1 = this.rnd.randi([0,1], [5,1]  );
end

firstPositionsPoly2 = this.rnd.randi([0,1], [5,1]  );

% avoid sequences where all elements equal 0
while all( firstPositionsPoly2 == 0 ) 
    firstPositionsPoly2 = this.rnd.randi([0,1], [5,1] );
end


% Length 31 sequence
% 1st polynom
poly1 = [ firstPositionsPoly1; zeros( 26, 1 ) ];
poly1Indexes = find( poly1 );
% 2nd polynom
poly2 = [ firstPositionsPoly2; zeros( 26, 1 ) ];
poly2Indexes = find( poly2 );

% codeShift
codeShift = this.rnd.randi([1, 500],1 );

% calculate the length of this packet
packetLength = length( inputSequence );

% initialization of the pseudo-random sequence
c_n = zeros( packetLength + codeShift, 1  );

% initialization of both polynoms
x_1 = [ this.firstPolyInitialConditions; ...
    zeros(  packetLength + codeShift - ...
    length( this.firstPolyInitialConditions ), 1) ];
x_2 = [ this.secondPolyInitialConditions; ...
    zeros( packetLength + codeShift - ...
    length( this.secondPolyInitialConditions ), 1 )];

% loop over the length of packet bits
for bit = 1 : packetLength + codeShift
    
    % 1st Poly
    x_1( bit + 31 ) = mod( sum( x_1( bit + poly1Indexes )  ), 2 );
    
    % 2nd Poly
    x_2( bit + 31 ) = mod( sum( x_2( bit + poly2Indexes )  ), 2 );
    
end

% build Gold sequence
for bit = 1 : packetLength
    
    c_n( bit ) = mod( x_1( bit + codeShift ) + x_2( bit + codeShift ), 2 );
    
end

c_n = c_n( 1 : end - codeShift );

% stores Gold Sequence
this.scramblingSequences = c_n;

% scrambles the signal
transmittedSequence = xor( inputSequence, c_n );

end
