function isNotOk = executeTests

global testVerbose

% verbose = false to suppress text and figures from tests
testVerbose = false;

disp( 'Starting Hermes Test Suite' );

hermes_dir = pwd;

addpath( genpath( [hermes_dir, filesep, 'src' ]));

tests_dir = [hermes_dir, filesep, 'unit' ];
addpath( genpath( tests_dir ));

addpath( genpath( [hermes_dir, filesep, 'parameters' ]));

isNotOk = false;

buildMexFiles( );
try

    resultTests = table( runtests( tests_dir, 'Recursively', true ) );

    disp( resultTests );

    fprintf ( 'Totals: \n %d Passed, %d Failed, %d Incomplete \n', ...
        sum ( resultTests.Passed ), sum ( resultTests.Failed ), ...
        sum ( resultTests.Incomplete ) );
    fprintf ( ' %ld seconds testing time \n\n', sum ( resultTests.Duration ) );


    isNotOk = any( [resultTests.Failed] );
    
    disp('verifying use of toolboxes')
    toolboxes = license('inuse');
    
    for toolboxIndex = 1 : length( toolboxes )
        if ~strcmp( toolboxes( toolboxIndex ).feature, 'matlab' )
            %isNotOk = true;
            fprintf( 'WARNING : toolbox %s is being used\n', ...
                     toolboxes( toolboxIndex ).feature )
        end
    end
    
    disp( 'Finishing Hermes Test Suite' );

    

catch e
    disp( getReport( e, 'extended' ) );
end;

clear testVerbose

end