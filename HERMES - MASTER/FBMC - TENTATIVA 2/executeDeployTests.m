function isNotOk = executeDeployTests
%EXECUTEDEPLOYTESTS compile and execute hermes in deployed mode like in grid
%   This script calls the others scripts to compile HERMES, create the
%   scripts that run in the grid and execute hermesStart executable in
%   deployed mode like a single job. This script should be run by the
%   integration server (Jenkins) to ensure that the simulator can execute
%   in deployed mode.
%
%   Syntax: executeDeployTests
%
%   Author: Renato Barbosa Abreu (RBA)
%   Work Address: INDT Manaus
%   E-mail: renato.abreu@indt.org.br
%   History:
%      v2.0 15 Jul 2015 (RBA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

disp( 'Starting Hermes Deploy Test Suite' );

% Create script to jun jobs on grid
hermesGridScript;

deployDir = 'deployed';
isNotOk = true;

assert( isempty( dir( [ deployDir filesep 'runJMS*.sh' ] ) ) == false  );

% Compile Hermes executable
compileHermes;
assert( isempty( dir( [ deployDir filesep 'hermesStart*' ] ) ) == false );

% Run hermesStart
% Here it does not run the grid script itself but a similiar way
cd( deployDir )
folders = dir();
folders( ~[ folders.isdir ] ) = [];
folders( ismember( { folders.name }, { '.', '..' } ) ) = [];
folderIdx = 1; % use first result folder
testFolder = [ pwd filesep folders(folderIdx).name ];
seed = 1;
command = [ fullfile( '.', 'hermesStart ' )...
    testFolder ' ' ...
    testFolder ' ' ...
    num2str(seed) ];

system( command );

resultFiles = dir( [ testFolder filesep 'statistics_*.mat' ] );
assert( isempty( resultFiles ) == false );

% If all was ok return false
isNotOk = false;

end