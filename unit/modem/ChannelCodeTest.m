%CHANNELCODETEST script tests the Channel Code class
% This function test the creation of a Channel Code object and its methods
%
%   Syntax: ChannelCodeTest
%
%   Author: Fadhil Firyaguna
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v1.0 23 Mar 2015 (FF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check class constructor
% Test constructor of Channel Code Class
global testVerbose
if testVerbose
    fprintf('\nTesting constructor of Channel Code Class\n')
end

codeObject = modem.ChannelCode ();

assert( isa ( codeObject, 'modem.ChannelCode' ) );

%% Test 2: check encode Method
% test dummy encode method
global testVerbose
if testVerbose
    fprintf('\nTesting dummy encode method\n');
end
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
lteSimulationSettings;
LTE.MCS = randi([0,20]);
lteParamTable = parameterCheck.loadLteParametersTable;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable );

availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;

sourceObject = source.LteSource( rnd, LTE );
packets = sourceObject.generatePackets( availableDataSymbols, ...
                                        modulationOrder, ...
                                        codeRate ) ;

codeObject = modem.ChannelCode ();

inputBits = [];
aux = true;
packetIndex = 0;
while ( aux && packetIndex < sourceObject.numberOfPackets )
    packetIndex = packetIndex + 1;
    inputBits = [ packets{ packetIndex } ];
    encodedBits = codeObject.encode( packets{ packetIndex } );
    aux = isequal( inputBits, encodedBits );
end

assert ( aux );

%% Test 3: check decode Method
% test hard decision decode method
global testVerbose
if testVerbose
    fprintf('\nTesting hard decision decode method\n')
end
rnd = RandStream( 'mt19937ar', 'Seed', 1 );
lteSimulationSettings;
LTE.MCS = randi([0,20]);
lteParamTable = parameterCheck.loadLteParametersTable;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable );

availableDataSymbols = 6996;
modulationOrder = 64;
codeRate = 1/3;

sourceObject = source.LteSource( rnd, LTE );
packets = sourceObject.generatePackets( availableDataSymbols, ...
                                        modulationOrder, ...
                                        codeRate );
% constant packet size
packetSize_bits = mean( sourceObject.packetSize_bits );
codeObject = modem.ChannelCode ();

% log-likelihood ratio stream input
llrStreamSize = packetSize_bits * sourceObject.numberOfPackets;
llr = rnd.randn( llrStreamSize, 1 );

% expected hard decision decoded bit stream output
expectedBits = floor( ( sign( llr ) + 1)./2 );

decodedBits = codeObject.decode( llr );

assert ( isequal( expectedBits, decodedBits ) );

