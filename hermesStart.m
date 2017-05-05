function statistics = hermesStart( inputParametersDir, resultsDirectory, ...
								   seed )
%HERMESSTART calls the simulator main function, according to inputs.
%   This function loads and checks all input parameters, creates results
%   directories, initializes random numbers seed, adds the simulation paths
%   and plots the statistics.
%
%   syntax 1: [ STATISTICS ] = hermesStart( inputParametersDir, ...
%                                           resultsDirectory, seed )
%
%   Inputs:
%       inputParametersDir <string> - this directory contains all the
%           simulator settings. If left empty, then the directory
%           './parameters' is considered.
%       resultsDirectory <string> - specifies the results Directory. If
%           left empty, then a default results folder will be created.
%       seed <integer> - specifies a index to the list of good seeds in the
%           file 'RandomNumberGeneratorSeeds.mat'. If left empty, then a
%           random seed is used.
%
%   Output:
%       STATISTICS - object containing all the simulation statistics
%
%
%   Author: Erika Portela Lopes de Almeida, André Noll Barreto
%   Work Address: INDT Brasília
%   E-mail: erika.almeida@indt.org.br, andre.noll@indt.org
%   History:
%       05 Feb 2015 (EA) - created
%       30 Mar 2015 (AB) - remodelled
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% add simulation paths ( include subfolders )
if ~exist( 'inputParametersDir', 'var' ) || isempty( inputParametersDir )
    inputParametersDir = [ pwd filesep 'parameters' ];
end
addHermesPaths( inputParametersDir );



% Initialize results folder
if( ~exist( 'resultsDirectory', 'var') ) || isempty( resultsDirectory )
    resultsDirectory = [ 'results', filesep,  ...
                         datestr( clock, 'yyyy-mm-dd_HH-MM-SS' ) ];
end

% Create output File / Directory ( if the specified path does not exist ).
mkdir( resultsDirectory );

% read all setting files and copy them to results dir
if ~isdeployed
    % load
    parameterFiles = dir( inputParametersDir );
    parameterFiles = parameterFiles( 3:end, :);
    numberOfFiles = size( parameterFiles, 1 );
    
    vars = who();
    for file = 1 : numberOfFiles
        currentParamFile = [ inputParametersDir, filesep, ...
                             strtrim( parameterFiles(file, :).name )];
                         
        try 
            run( currentParamFile );
            copyfile( currentParamFile, resultsDirectory );
        catch exception
            
            if strcmp( exception.identifier, 'MATLAB:run:CannotExecute' )
                fprintf( 'WARNING: %s\n', exception.message ) 
            else
                rethrow( exception );
            end
        end
      
    end
    clear file
    paramVars = who();
else
    vars = who();
    resultsPathIndex = strfind( inputParametersDir, filesep );
    currentParamFile = inputParametersDir( resultsPathIndex(end)+1 : end );
    feval('load', currentParamFile); % If compiled, assume a .mat file is given as input
    clear resultsPathIndex;
    paramVars = who();
end

% find out which variables where added as parameters
paramVars( find ( strcmp( 'vars', paramVars ) ) ) = []; 
paramVars( find ( strcmp( 'SETTINGS', paramVars ) ) ) = []; 
paramVars( find ( strcmp( 'exception', paramVars ) ) ) = []; 

for varIndex = 1 : length( vars )
    paramVars( find ( strcmp( vars{varIndex}, paramVars ) ) ) = []; 
end

% move all setting variables to a single variable
for paramSet = 1 : length( paramVars )
    evalStr = [ 'SETTINGS.' paramVars{paramSet} '=' paramVars{paramSet} ';'];
    eval(evalStr);
end


% Initialize seed
if ( ~exist('seed', 'var') )
    seed = sum( 1000*clock );
end

% Convert to integer when seed parameter is set on deployed mode (compiled)
if ( ischar( seed ) )
    seed = str2num( seed );
end

% Initialize Random Streams
randomStreams = initializeRandomStreams( seed );

% Call hermes Main Loop
% Generate statistics.berPerSnr and statistics.blerPerSnr
statistics = hermesMain( SETTINGS, randomStreams );
statistics = statistics.getMainStatistics();


if isdeployed
    resultFileName = [ 'statistics_' num2str( seed ) ];
    eval( [ resultFileName ' = statistics;' ] );
    
    save( [ resultsDirectory, filesep, resultFileName '.mat' ], ...
          resultFileName );
else
    save( [ resultsDirectory, filesep, ...
          'statistics_' num2str(seed) '.mat' ], 'statistics' );
end

fprintf('results saved in %s\n', resultsDirectory );

end
