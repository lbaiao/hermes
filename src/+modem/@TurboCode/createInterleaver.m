function  createInterleaver( this, packetSize )
% TURBOCODE.createInterlaver creates an interleaver sequence for TC
%   Further description in class header.
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 03 Jul 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% Initialization:
factorization = factor( packetSize );
primeFactors = unique( factorization );
numberOfPrimeFactors  = length( primeFactors );

%Calculate the quadratic factor 'b' for polynomial( b.x^2 + a.x) :
quadraticFactor = prod( primeFactors );
for  count = 1 : numberOfPrimeFactors
    % Check if this prime factor has order > 1
    primeFactorOrder = sum( factorization == primeFactors( count ) );
    % If so, use 2 or more times this prime factor for b (quadratic
    % Factor):
    if primeFactorOrder > 1
        auxiliary = max ( 2, primeFactorOrder - this.rnd.randi( [ 0, primeFactorOrder - 1 ] ) );
        quadraticFactor = quadraticFactor * primeFactors( count ) ^ ( auxiliary - 1 );
    end
end

% Calculate the linear factor 'a' for polynomial ( b.x^2 + a.x) :
candidates = 1 : 2 * quadraticFactor; % Searching Range

for  count = 1 : numberOfPrimeFactors
   % Check which numbers in the searching range are coprimes with this
   % prime factor:
   candidatesFlag = gcd( candidates, primeFactors( count ) ); 
   candidates ( candidatesFlag > 1 ) = []; % Eliminate not suitable candidates
    
end

% Select "a":
linearFactor = candidates( this.rnd.randi( [ 1 , length( candidates ) ] ) ) ;

% Calculate Sequence
indexes = 0 : packetSize - 1;
interleaverSequence = mod( quadraticFactor .*  indexes.^2 + linearFactor .* indexes , packetSize ) + 1;

this.setInterleaver ( interleaverSequence );


