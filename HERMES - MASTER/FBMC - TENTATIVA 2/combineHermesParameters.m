function combineHermesParameters( FILE, PARAMETER, AVOIDED_COMBINATION )
%COMBINEHERMESPARAMETERS combines parameters in grid scripts
%   This function combines all provided parameters, removes combinations
%   that are not wanted and writes the grid scripts.
%
%   Syntax: combineHermesParameters( FILE, PARAMETER, AVOIDED_COMBINATION )
%
%   Inputs:
%       FILE < struct > - contains the labels provided by the user to the
%       results folder and grid files. It contains the following fields.
%                   folderName < string > - contains the name of the folder
%                   where the input parameters are located
%
%                   parametersStruct < string cell > - each element
%                   contains the Struct of the technology that will be
%                   simulated in this campaign
%
%                   simulationPrefix < string > - is the label you will
%                   give to your simulation folders and jobs
%
%                   simulationSuffix < string > - this is the tag you will
%                   give to your simulation campaign. The suffix is used
%                   when you will merge your simulation results.
%
%                   scriptSuffix < string > - this is the tag you will give
%                   to you script files
%
%                   numberOfDropsPerJob < integer > - this is the number of
%                   drops in each simulation job. The total number of drops
%                   in your simulation is the numberOfDropsPerJob
%                   multiplied by the numberOfJobs.
%
%                   numberOfJobs < integer > - this is the number of
%                   parallel simulations.
%
%       PARAMETER < 1 x NumberOfParametersToBeChanged cell > - each cell
%       contains a struct with the following fields:
%                   name < string >: contains the parameter to be changed,
%                   the exact string used in the parameters file.
%
%                   value < 1 x 1 cell >: the element contains an array of
%                   strings. Each string represents the value of the
%                   parameter to be changed.
%
%                   label < 1 x 1 cell >: the element contains an array of
%                   strings. Each string representes the label of the
%                   parameter to be changed.
%
%       AVOIDED_COMBINATION < cell 1 x numberOfcombinationsToBeAvoided > is
%       struct with the following fields:
%                   name < 1 x numberOfParametersToBeAvoided cell > this
%                   cell contains in each position the name of the
%                   parameter that can't be combined with the other...
%
%                   label < 1 x numberOfcombinationsToBeAvoided cell > is a
%                   cell that contains in each position the label of the
%                   value that can't be combined with the others...
%
%   Author: Erika Portela Lopes de Almeida
%   Work Address: INDT Brasília
%   E-mail: erika.almeida@indt.org
%   History:
%      v2.0 9 Jul 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% =========================================================================
%                       COMBINE PARAMETERS
% =========================================================================

numberOfCombinations = length( AVOIDED_COMBINATION );
numberOfParameters = length( PARAMETER );

avoidedCombinations = zeros( numberOfParameters, numberOfCombinations );

numParameter = cell( 1, numberOfCombinations );
parameterValue = cell( 1, numberOfCombinations );

for combination = 1 : numberOfCombinations
    paramValueComb = [];
    paramNameComb = [];
    
    combinationSize = length( AVOIDED_COMBINATION{ combination }.name );
    
    for index = 1 : combinationSize
        
        parameterName = AVOIDED_COMBINATION{ combination }.name{ index };
        
        for param = 1 : numberOfParameters
            
            thisParameter = PARAMETER{ param }.name;
            
            if strcmp( parameterName,thisParameter )
                
                % get this index
                paramNameComb = [ paramNameComb; param ];
                
                % test Value
                numberOfValues = length( PARAMETER{ param }.label );
                
                for paramValues = 1 : numberOfValues
                    
                    if strcmp( PARAMETER{ param }.label{ paramValues },...
                            AVOIDED_COMBINATION{ combination }.label{ index } )
                        paramValueComb = [ paramValueComb; paramValues ];
                        
                    end
                    
                end
                
            end
        end
    end
    
    numParameter{ combination } = paramNameComb;
    parameterValue{ combination } = paramValueComb;
    
end

for avoidedComb = 1 : numberOfCombinations
    lineIndexes = numParameter{ avoidedComb };
    columnValues = parameterValue{ avoidedComb };
    
    if ~all( size( lineIndexes ) == size( columnValues ) )
        error('Please check the names and values chosen for AVOIDED_COMBINATIONS');
    end
    
    avoidedCombinations( lineIndexes, avoidedComb ) = columnValues;
    
end

% get the number of parameters to be varied
numberOfLevels = size( PARAMETER, 2 );
numberOfValues = zeros(1,numberOfLevels);


for level = 1 : numberOfLevels
    numberOfValues( level ) = length( PARAMETER{ level }.value );
end

% combine the indexes of parameters to be combined :D
command = 'combvec(';
for i = 1:  numberOfLevels
    command = [command '1:' num2str( numberOfValues( i ) ) ', '];
end
command = command(1:length(command)-2);
command = [command ');'];
parameterCombinations = eval(command);

columnToBeDeleted = [];

% check if there are any impossible combinations
if ~isempty( avoidedCombinations )
    
    % get the parameter indexes that cannot be combined
    getIndexes = sum( avoidedCombinations, 2 );
    paramIndexes = find( getIndexes > 0 );
    numberOfAvoidedCombinations = length( paramIndexes );
    
    % look for the impossible combinations
    for avoidedCombination =  1: numberOfAvoidedCombinations
        
        % get the parameters values
        getValueIndexes = avoidedCombinations( :, avoidedCombination );
        
        % get the number of parameters to be checked
        paramsToBeChecked = find( getValueIndexes ~= 0 );
        
        columnOld = [];
        
        for i = 1:  length( paramsToBeChecked )
            
            columnNew = find( parameterCombinations( paramsToBeChecked( i ), : ) ==  getValueIndexes( i ) );
            
            if i == 1
                columnOld = columnNew;
            else
                columnOld = intersect( columnOld, columnNew );
            end
            
        end
        columnToBeDeleted = [ columnToBeDeleted, columnOld  ];
    end
    
end

% Delete from parameterCombinations the impossible Combinations
columnIndexes = 1 : size( parameterCombinations, 2 );
columnToMaintain = setdiff( columnIndexes, columnToBeDeleted );

% updated parameterCombinations
parameterCombinations = parameterCombinations( :, columnToMaintain );

% =========================================================================
%                       Get the base parameter files
% =========================================================================

% get the name of this folder
thisFolder = pwd;

% write the name of the folder where the parameters are located.
parametersFolder = [ thisFolder, filesep, FILE.folderName ];

eval( ['cd ', parametersFolder] );

fileList = dir( parametersFolder );

% look for input parameters files
fileIndex = [];
for index = 1 : length( fileList )
    if size( fileList( index ).name, 2 ) > 2
        fileIndex = [ fileIndex index ];
    end
end

% initialize a cell with input parameters file names
inputFiles = cell( 1, length(fileIndex) );
inputParameters = cell( 1, length( fileIndex ) );
for index = 1 : length( fileIndex )
    inputFiles{index} = [ fileList( fileIndex(index) ).name ];
    fileName = inputFiles{index};
    inputParameters{ index } =  textread( strcat( fileName(1:end-2),'.m' ), ...
        '%s', 'delimiter', '\n' );
end

eval( 'cd ..' )

% =========================================================================
%   Overwrite the parameters to be changed and create results directory
% =========================================================================

resultsPath = pwd;
resultsFolderName = 'deployed';
    
% loop over parameters combination
for combinationID = 1 : size( parameterCombinations, 2 )
    fileIdentification = '';
    
    for k = 1 : size( PARAMETER,2 )
        fileIdentification = sprintf( '%s%s%s', fileIdentification,'_',...
            char(PARAMETER{k}.label{parameterCombinations(k,combinationID)}));
    end
    
    fileIdentification = sprintf( '%s%s%s%s', FILE.simulationPrefix, ...
        fileIdentification, '_',FILE.simulationSuffix );
    
    % copy the parameters
    inputParameters_tmp = inputParameters;
    
    % loop over parameter files
    for inputs = 1 : size( inputParameters, 2)
        for k = 1 : size( PARAMETER, 2 )
            inputParameters_tmp{ inputs } = strrep( inputParameters_tmp{ inputs }, ...
                'SETTINGS.DROPS.MAX_NUMBER_OF_DROPS = x;',...
                sprintf(['SETTINGS.DROPS.MAX_NUMBER_OF_DROPS = ',...
                num2str(FILE.numberOfDropsPerJob),';'] ) );
            
            inputParameters_tmp{ inputs } = strrep( inputParameters_tmp{ inputs },...
                [ char( PARAMETER{k}.name) ' = x;' ],...
                sprintf('%s%s', [char(PARAMETER{k}.name) ' = ' ...
                char(PARAMETER{k}.value(parameterCombinations(k,combinationID))),';'] ) );
        end
    end
    
    consolidatedInputParameters = [];
    
    for inputs = 1 : size( inputParameters, 2 )
        
        consolidatedInputParameters = [ consolidatedInputParameters; ...
            inputParameters_tmp{ inputs } ];
        
    end
    
    % combine all input parameters
    AllParameters{ combinationID } = consolidatedInputParameters;
    AllNames{ combinationID } = fileIdentification;

    AllDirectoryNames{ combinationID } = fileIdentification;
    
    test = dir([resultsPath, filesep, resultsFolderName, filesep, ...
        AllDirectoryNames{ combinationID }]);
    
    % check if the results folder exists
    if isempty( test )
        mkdir([ resultsPath, filesep, resultsFolderName, filesep, ...
            AllDirectoryNames{ combinationID }]);
    end
    
    % go to results folder
    cd([ resultsPath, filesep, resultsFolderName, filesep, ...
        AllDirectoryNames{ combinationID } ]);
    
    % Write the parameters file
    for pdi = size( AllParameters, 2 )
        % get the parameters
        temporaryParameters = AllParameters{ combinationID };
        
        % open and create a new parameter file
        fileName = fopen( sprintf('%s.m', AllNames{ combinationID } ),'w');
        
        % write the parameters into a new file
        for parameterLine = 1 : length( temporaryParameters )
            
            fprintf( fileName, '%s\n',...
                cell2mat( temporaryParameters( parameterLine ) ) );
            
        end
        
        fclose( fileName );
        
    end
    eval( 'cd ..' );
end

% =========================================================================
%                           Create shell files
% =========================================================================
% create shell file
shellFileJMSGrid = ['runJMSsimulations_', FILE.scriptSuffix, '.sh'];
shellFileQSUBGrid = ['runQsubSimulations_',FILE.scriptSuffix, '.sh'];

% open files
fileID_jmsGrid = fopen( shellFileJMSGrid, 'w' );
fileID_qsubGrid = fopen( shellFileQSUBGrid, 'w' );

if isunix()
    fileattrib(shellFileJMSGrid,'+x', 'a');
    fileattrib(shellFileQSUBGrid,'+x', 'a');
end

fid_list = fopen('SimList','w');

for combinationID = 1 : length( AllNames )
    display(['Creating file: ' AllNames{ combinationID } '...']);
    
    % create results directory
    resultsDirectory = AllDirectoryNames{ combinationID };
    resultsDirectoryComplete = [  resultsPath filesep resultsFolderName filesep resultsDirectory ];
    
    test = dir( resultsDirectoryComplete );
    
    if isempty( test )
        mkdir( resultsDirectoryComplete );
    end
    
    % load parameters
    fileName_tmp =[ AllNames{combinationID}];
    numberOfOutputs = length( FILE.parameterStructs );
    filePath = [ resultsDirectoryComplete filesep fileName_tmp ];
    run(filePath);    
    command = [ ' save ', filePath,'.mat'];
    for i = 1 : numberOfOutputs
        command = [ command, ' ',char(FILE.parameterStructs(i)) ];
    end
    eval( command );
    
    % creat the grid scripts
    
    for job = 1 : FILE.numberOfJobs
        fprintf( fileID_jmsGrid, 'jms -b -log %s -t %s hermesStart %s %s %s \n', ...
            [ resultsDirectoryComplete filesep fileName_tmp '_JOB' num2str(job) '.log' ], ... % log file
            [ fileName_tmp '_JOB' num2str(job) ], ... % grid tag
            [ resultsDirectoryComplete ], ... inputParametersDir
            resultsDirectoryComplete, ...
            char( num2str( job ) ) ...
            );
    end
    
    for job = 1 : FILE.numberOfJobs
        fprintf( fileID_qsubGrid, 'qsub -b -log %s -t %s hermesStart %s %s %s \n', ...
            [ resultsDirectoryComplete filesep fileName_tmp '_JOB' num2str(job) '.log' ], ... % log file
            [ fileName_tmp '_JOB' num2str(job) ], ... % grid tag
            [ resultsDirectoryComplete ], ... inputParametersDir
            resultsDirectoryComplete, ...
            char( num2str( job ) ) ...
            );
    end

    fprintf( fid_list, '%s\n', resultsDirectoryComplete );
end

fclose( fid_list );
fclose( fileID_qsubGrid );
fclose( fileID_jmsGrid );
eval( 'cd ..' );

end