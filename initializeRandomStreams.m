function randomStream = initializeRandomStreams( seed )
%function initializeRandomStreams creates new random streams from a seed.
%   This function creates multiple random streams. Currently, the following
%   streams are created:
%       - noise
%       - multipath model
%       - source
%       - frame creation
%
%   syntax: initializeRandomStream( seed )
%
%       Input: seed < integer >: desired random number seed. It is used as
%       an index do RandomNumberGeneratorseeds.mat file.
%
%       Output: randomStream < cell objects >: randomStream objects
%       organized in a cell. Each position in this cell corresponts to a
%       random stream to be used in different contexts (noise, multipath
%       model, source, frame creation).
%
%   Author: Erika Portela Lopes de Almeida (EA)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida.@indt.org.br
%   History:
%       v1.0 05 March 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% load file with best seeds
load('RandomNumberGeneratorSeeds.mat');


% generate indexes based on enums
seedIndices = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
                enum.RandomSeeds.SOURCE, enum.RandomSeeds.ENCODER, ...
                enum.RandomSeeds.FRAME ];

% guarantee that all indexes are within range
numberOfSeeds = length( SeedSet );        
seed = mod( seed, numberOfSeeds - max( uint32(seedIndices) ) ); 
        
% initialize randomStream cell
randomStream = cell( 1, length( seedIndices ) );

% create randomStream objects
for index = 1 : length( seedIndices )
    randomStream{ uint32( seedIndices( index ) ) } = ...
        RandStream.create( 'mt19937ar', 'seed', ...
                           SeedSet( seed + index ) );
end

