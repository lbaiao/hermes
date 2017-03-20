%DROPLOOPTEST tests DropLoop class constructor and all methods.
%   This script tests DropLoop class constructor and methods
%
%   Syntax: DropLoopTest
%   
%   Author: Erika Portela Lopes de Almeida
%   Work Address: INDT Brasília
%   Email: <erika.almeida>@indt.org.br
%   History:
%       v1.0 20 Feb 2015 - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check DropLoop constructor
% the first test checks the DropLoop constructor.

% create DropLoop object
generalSimulationSettings;
loop = simulatorCore.DropLoop( SETTINGS );
assert( isa( loop, 'simulatorCore.DropLoop' ) );


%% Test 2: check property currentDrop
generalSimulationSettings;
loop = simulatorCore.DropLoop( SETTINGS );
assert( isequal( loop.currentDrop, 0 ) );


