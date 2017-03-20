%SCENARIOTEST function tests the Scenario Class
%   This function test aspects of the constructor of an object of class
%   SCENARIO
%
%   Syntax: scenarioTest
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%   	v1.0 26 Mar 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test1: Test Constructor
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;

indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

scene1 = scenario.Scenario(SETTINGS, randomStream);
assert( isa ( scene1, 'scenario.Scenario' ) );

%% Test2: Test Number of Nodes
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;

indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

scene1 = scenario.Scenario(SETTINGS, randomStream);

numberOfNodes = length( SETTINGS.SCENARIO.NODE );
assert( isequal ( length( scene1.nodes ), numberOfNodes ) );

%% Test3: Test Nodes Positions
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;


indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

scene1 = scenario.Scenario(SETTINGS, randomStream);
numberOfNodes = length( SETTINGS.SCENARIO.NODE );
aux = true;
nodeCount = 0;
while ( aux && nodeCount < numberOfNodes )
nodeCount = nodeCount + 1;
   aux = ( all(scene1.nodes{ nodeCount }.positionInXYZ == SETTINGS.SCENARIO.NODE{ nodeCount }.POSITION ));
end
assert(  aux );
%% Test4: Test Modem - Node Association
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;


indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

scene1 = scenario.Scenario(SETTINGS, randomStream);

numberOfModems = length( SETTINGS.SCENARIO.MODEM );

aux = true;
modemCount = 0;
while ( aux && modemCount < numberOfModems )
    modemCount = modemCount + 1;
    expectedNode = SETTINGS.SCENARIO.MODEM{ modemCount }.NODE;
    aux = isequal( scene1.modems{ modemCount }.node , scene1.nodes{ expectedNode } );
end
assert(  aux );

%% Test5:  Check Main Rx Attributions - Modem
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;


indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

scene1 = scenario.Scenario(SETTINGS, randomStream);
assert(  scene1.rxModems ==  SETTINGS.SCENARIO.MAIN.RX_MODEMS);


%% Test6: Check Number of Transmitting Modems
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;


indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

numberOfModems = length( SETTINGS.SCENARIO.MODEM );
numberOfReceivers = length( SETTINGS.SCENARIO.MAIN.RX_MODEMS );
numberOfTxModems = numberOfModems - numberOfReceivers;

scene1 = scenario.Scenario(SETTINGS, randomStream);
assert(  numberOfTxModems == length( scene1.txModems  ) );
%% Test7: Check Number of Channels
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;


indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end
numberOfMainModems = 2 * length( SETTINGS.SCENARIO.MAIN.TX_MODEMS );
numberOfModems = length( SETTINGS.SCENARIO.MODEM );
% If all modems in scenario belongs to Main links...
if numberOfModems == numberOfMainModems
    % ... create at least one interfering Modem
    SETTINGS.SCENARIO.MODEM{numberOfMainModems + 1} = SETTINGS.SCENARIO.MODEM{ 1 } ;
    numberOfModems = numberOfModems + 1;
end

scene1 = scenario.Scenario(SETTINGS, randomStream);
[transmitters receivers] = size( scene1.channels );

assert( transmitters == length( scene1.txModems ) && receivers == length( scene1.rxModems )  );

%% Test8: Check Scenario Channel Type - No Fading
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;
SETTINGS.CHANNEL.MULTIPATH.MODEL = enum.channel.MultipathModel.NONE;

indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

scene1 = scenario.Scenario(SETTINGS, randomStream);

assert( isa( scene1.channels{1,1} , 'channel.Channel' ) );



%% Test9: Check Scenario Channel Type - Fading
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;
SETTINGS.CHANNEL.MULTIPATH.MODEL = enum.channel.MultipathModel.GENERIC;

indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

scene1 = scenario.Scenario(SETTINGS, randomStream);

assert( isa( scene1.channels{1,1} , 'channel.FadingChannel' ) );



%% Test 10: Check if all Tx innerTransceiver are Modulators
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;

indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

scene1 = scenario.Scenario(SETTINGS, randomStream);

aux = true;
countTx = 0;
while aux && countTx < length( scene1.txModems )
    countTx = countTx + 1;
    txModem = scene1.txModems( countTx );
    aux = isa( scene1.modems{ txModem }.innerTransceiver, 'modem.BlockModulation');
end

assert( aux )

%% Test 11: Check if all Rx innerTransceiver are innerReceivers
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;

indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

numberOfModems = length( SETTINGS.SCENARIO.MODEM );
scene1 = scenario.Scenario(SETTINGS, randomStream);

aux = true;
countRx = 0;
while aux && countRx < length( scene1.rxModems )
    countRx = countRx + 1;
    rxModem = scene1.rxModems( countRx );
    aux = isa( scene1.modems{ rxModem }.innerTransceiver, 'modem.InnerReceiver');
end

assert( aux )

%% Test 12: Check Consistency in Tx - Rx Main Link Pair.
generalSimulationSettings;
lteSimulationSettings;
fiveGSimulationSettings;
SETTINGS.LTE = LTE;
SETTINGS.FIVEG = FIVEG;


indexes = [ enum.RandomSeeds.NOISE, enum.RandomSeeds.MULTIPATH_MODEL, ...
    enum.RandomSeeds.SOURCE, enum.RandomSeeds.FRAME ];
randomStream = cell( 1, length( indexes ) );
for index = 1 : length( indexes )
    randomStream{ indexes( index ) } = RandStream.create('mt19937ar', ...
        'seed', 100);
end

numberOfModems = length( SETTINGS.SCENARIO.MODEM );
scene1 = scenario.Scenario(SETTINGS, randomStream);


rxModem  = scene1.rxModems( 1 );
txModem = scene1.modems{ rxModem }.link;


aux = isequal ( scene1.modems { txModem }.source , scene1.modems { rxModem }.source );

if aux
    aux = isequal ( scene1.modems { txModem }.channelCode , scene1.modems { rxModem }.channelCode );
end

if aux
    aux = isequal ( scene1.modems { txModem }.frameAssembler , scene1.modems { rxModem }.frameAssembler );
end

assert( aux )