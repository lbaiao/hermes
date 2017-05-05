% STATISTICSTESTS tests Statistics class and all methods
%
%   Syntax: StatisticsTest
% 
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v1.0 30 Mar 2015 - (FF) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check Statistics constructor
generalSimulationSettings;
statObject = simulatorCore.Statistics( SETTINGS );
assert( isa( statObject, 'simulatorCore.Statistics' ) );

%% Test 2: check updateDrop method for deterministic information
% test mean and error margin computation for static information
generalSimulationSettings;
statObject = simulatorCore.Statistics( SETTINGS );

% static information
snrVectorSize = length( statObject.snrVector );
numberOfFrames = 100;
bitErrors = 500;
packetErrors = 500;
numberOfBits = 1000;
numberOfPackets = 1000;
throughput = 800;

for dropIndex = 1 : 10
    % add static information in frame stats
    for snrIndex = 1 : snrVectorSize
        for frameIndex = 1 : numberOfFrames
            statObject.addNewFrameStats( snrIndex, ...
                                         bitErrors, numberOfBits, ...
                                         packetErrors, numberOfPackets, ...
                                         throughput );
        end
    end

statObject.updateDrop( 1 );

end

% compute expected means
expected.berMean = ( bitErrors / numberOfBits ) .* ones( 1, snrVectorSize );
expected.blerMean = ( packetErrors / numberOfPackets ) .* ones( 1, snrVectorSize );
% static information has no error margin
expected.berErrorMargin = zeros( 1, snrVectorSize );
expected.blerErrorMargin = zeros( 1, snrVectorSize );

% extract means
output.berMean = statObject.berMean;
output.blerMean = statObject.blerMean;
output.berErrorMargin = statObject.berErrorMargin;
output.blerErrorMargin = statObject.blerErrorMargin;

% compare expected to extracted means
assert( isequal( expected, output ) );

