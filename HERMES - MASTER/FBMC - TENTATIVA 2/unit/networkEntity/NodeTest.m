%NODETEST function tests the Node class
%   This function test the creation of a Node class
%
%   Syntax: NodeTest
%
%   Author: Lilian Freitas (LCF)
%   Work Address: INDT Manaus
%   E-mail: lilian.freitas@indt.org.br
%   History:
%       v1.0 10 Apr 2015 (LCF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check Node class constructor
% Test constructor of Node class
positionInXYZ = rand( 1, 3);
velocity = rand (1, 2);
instanceNode = networkEntity.Node( positionInXYZ, ...
    velocity );
assert( isa ( instanceNode, 'networkEntity.Node' ) );

%% Test 2: check positionInXYZ property
% Test constructor of positionInXYZ property
positionInXYZ = rand( 1, 3);
velocity = rand (1, 2);
instanceNode = networkEntity.Node( positionInXYZ, velocity );
assert( isequal( instanceNode.positionInXYZ, positionInXYZ ) == 1 );

%% Test 3: check velocity property
% Test constructor of velocity property
positionInXYZ = rand( 1, 3);
velocity = rand (1, 2);
instanceNode = networkEntity.Node( positionInXYZ, velocity );
assert( isequal( instanceNode.velocity, velocity ) == 1 );


