%COMPILEHERMES compile HERMES to run in deployed mode
%   Run this script to compile an hermesStart executable into ./deployed folder
%
%   Syntax: compileHermes
%
%   Author: Anderson Lizardo (AL), Renato Barbosa Abreu (RBA)
%   Work Address: INDT Manaus
%   E-mail: anderson.lizardo@indt.org.br, renato.abreu@indt.org.br
%   History:
%      v2.0 15 Jul 2015 (AL, RBA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

deployDir = 'deployed';

% Create a deploy directory if it does not exist
if ( exist(deployDir, 'dir') ~= 7 )
    mkdir( deployDir );
end

% Copy seeds file to deploy folder
copyfile( 'RandomNumberGeneratorSeeds.mat', deployDir );

% Build MEX files 
buildMexFiles( );

% Compile hermesStart executable
system( [ 'mcc -d ' deployDir ' -R -singleCompThread -a src -m -v hermesStart.m' ] );
