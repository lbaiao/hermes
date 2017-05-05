function mergeSimulationsResults( deployDir )
%MERGESIMULATIONSRESULTS merge the results from the simulations
%   This script accesses the deployment folder, which contains the
%   simulation results from different jobs. It merges these results
%   calculating the average values of the computed metrics with different
%   seeds. 
%   Before running this script, ensure that the deployment folder already
%   contains the statistics results from the simulations.
%
%   Syntax 1: mergeSimulationsResults
%
%   Syntax 2: mergeSimulationsResults( deployDir )
%
%   Inputs:
%       deployDir <string> - this directory contains folders with the
%           statistics results from the simulations runned in deploy mode.
%
%   Author: Renato Barbosa Abreu (RBA)
%   Work Address: INDT Manaus
%   E-mail: renato.abreu@indt.org.br
%   History:
%      v2.0 23 Jul 2015 (RBA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if ~exist( 'deployDir', 'var' ) || isempty( deployDir )
    deployDir = 'deployed';
end

% List folders that contain results from simulations executions
folders = dir( deployDir );
folders( ~[ folders.isdir ] ) = [];
folders( ismember( { folders.name }, { '.', '..' } ) ) = [];

for folderIdx = 1 : numel( folders );
    testFolder = [ pwd filesep deployDir filesep folders(folderIdx).name ];
    disp( ['Merging results from ' testFolder ] );
    resultFiles = dir( [ testFolder filesep 'statistics_*.mat' ] );

    if isempty( resultFiles )
        warning( [ 'No result available on ' testFolder ] );
        continue;
    end

    % Consolidate statistics
    statistics = [];
    numResults = length( resultFiles );
    for fileIdx = 1 : numResults
        % Dinamically load statistic file content
        loadedStruct = load( [ testFolder filesep resultFiles( fileIdx ).name ] );
        structName = fieldnames( loadedStruct );
        structContent = loadedStruct.( structName{1} );
        contentFields = fields( structContent );

        % Average results to consolidate in a single struct
        for fieldIdx = 1 : numel( contentFields )
            field = structContent.( contentFields{ fieldIdx } );
            fieldName = contentFields{ fieldIdx };

            if isfield( statistics, fieldName )
                statistics.( fieldName ) = statistics.( fieldName ) + ( field ./ numResults );
            else
                statistics.( fieldName ) = field ./ numResults;
            end
        end

    end

    save( [ testFolder filesep 'statistics.mat' ], 'statistics' );

end

end