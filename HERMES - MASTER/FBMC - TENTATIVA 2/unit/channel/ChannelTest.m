%CHANNELTEST script tests the Channel class
% This function test the creation of a Channel object and its methods
%
%   Syntax: ChannelTest
%
%   Author: Andre Noll Barreto
%   Work Address: INDT Manaus
%   E-mail: andre.noll@indt.org.br
%   History:
%       v1.0 15 Apr 2015 - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: 1x1 channel - update method (impulse response)

% set verbose here if performing test for this class only
global testVerbose;
if isempty(testVerbose)
    testVerbose = true;
end

if testVerbose
    fprintf('\nTesting 1x1 channel and update method\n')
end

%%%%%%%%%%%
% Test parameters
samplingRate = 1e6;
timeStep = 1e-3;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = 1;
rxAnts = 1;

if testVerbose
    fprintf('channel created with %d tx and %d rx antennas\n', ...
            length(txAnts), length(rxAnts) );
end

ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

h = ch.update(timeStep);
hstr = mat2str( h );

if testVerbose
    fprintf('\tchannel updated\n, impulse response is: \n\t\t%s\n', hstr)
end

% channel should have unitary response
assert(h == 1); 

%% Test 2: 1x1 channel - propagate method (response to random inputs)

global testVerbose

if testVerbose
    fprintf('\nTesting 1x1 channel and propagate method\n')
end

%%%%%%%%%%%
% Test parameters
samplingRate = 1e6;
numberOfSymbols = 20;
timeStep = 1e-3;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = 1;
rxAnts = 1;
ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

x = rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) + ... 
    1i*rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) ;

t0 = 2*timeStep;
[y, h] = ch.propagate( x, t0 );
hstr = mat2str( h );
xstr = mat2str( x );
ystr = mat2str( y );

if testVerbose
    fprintf( '\tsignal\n\t\tx = %s\n\t\tis transmitted in time %d\n', ...
             xstr, t0 )
    fprintf( '\t\toutput\n\t\ty = %s\n\t\tand impulse response\n\t\th = %s\n', ...
             ystr, hstr)          
end
% output should be equal to input 
assert(all(y == x))

%% Test 3: 2 x 2 channel - update method (impulse response)

global testVerbose

if testVerbose
    fprintf('\nTesting 2x2 channel and update method\n')
end

%%%%%%%%%%%
% Test parameters
samplingRate = 1e6;
timeStep = 1e-3;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = [2 1];
rxAnts = [2 1];
if testVerbose
    fprintf( '\nchannel created with %d tx and %d rx antennas\n', ...
             length(txAnts), length(rxAnts) );
end
ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

h = ch.update(timeStep);
hstr = mat2str( squeeze(h) );

if testVerbose
    fprintf('\tchannel updated\n, impulse response is: \n\t\t%s\n', hstr)
end

assert( isequal (squeeze(h), eye(2)))


%% Test 4: 2 x 2 channel - propagate method (response to random inputs)

global testVerbose

if testVerbose
    fprintf('\nTesting 2x2 channel and propagate method\n')
end

%%%%%%%%%%%
% Test parameters
samplingRate = 1e6;
numberOfSymbols = 20;
timeStep = 1e-3;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = [2 1];
rxAnts = [2 1];

if testVerbose
    fprintf( '\nchannel created with %d tx and %d rx antennas\n', ...
             length(txAnts), length(rxAnts) );
end

ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

x = rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) + ... 
    1i*rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) ;

t0 = 2*timeStep;
[y, h] = ch.propagate( x, t0 );

if testVerbose
    fprintf('\tsignal x transmitted in time %d\n', t0 )
    disp(num2str(x));
    fprintf('\t\toutput y\n')
    disp(num2str(y));
    fprintf('\t\timpulse response h\n')
    disp(num2str(h));
end

assert(all(all(y == x)))

%% Test 5: 2 x 1 channel - update method (impulse response)

global testVerbose

if testVerbose
    fprintf('\nTesting 2x1 channel and update method\n')
end

% Test parameters
samplingRate = 1e6;
timeStep = 1e-3;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = [2 1];
rxAnts = [2];

if testVerbose
    fprintf( '\nchannel created with %d tx and %d rx antennas\n', ...
             length(txAnts), length(rxAnts) );
end

ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

h = ch.update(timeStep);
h = reshape( h, ch.numberOfRxAntennas, ch.numberOfTxAntennas);
hstr = mat2str( h );

if testVerbose
    fprintf('\tchannel updated\n, impulse response is: \n\t\t%s\n', hstr)
end
assert( isequal( squeeze(h), eye(1,2) ) );

%% Test 6: 2 x 1 channel - propagate method (response to random inputs)

global testVerbose

if testVerbose
    fprintf('\nTesting 2x1 channel and propagate method\n')
end

% Test parameters
samplingRate = 1e6;
numberOfSymbols = 20;
timeStep = 1e-3;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = [2 1];
rxAnts = [2];

ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

x = rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) + ... 
    1i*rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) ;

t0 = 2*timeStep;
[y, h] = ch.propagate( x, t0 );

if testVerbose
    fprintf('\tsignal x transmitted in time %d\n', t0 )
    disp(num2str(x));
    fprintf('\t\toutput y\n')
    disp(num2str(y));
    fprintf('\t\timpulse response h\n')
    disp(num2str(h));
end

assert(all(y == x(:,1)))

%% Test 7: 1 x 2 channel - update method (impulse response)

global testVerbose

if testVerbose
    fprintf('\nTesting 1x2 channel and update method\n')
end

% Test parameters
samplingRate = 1e6;
timeStep = 1e-3;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = [1];
rxAnts = [1 2];

if testVerbose
    fprintf( '\nchannel created with %d tx and %d rx antennas\n', ...
             length(txAnts), length(rxAnts) );
end

ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

h = ch.update(timeStep);
h = reshape( h, ch.numberOfRxAntennas, ch.numberOfTxAntennas);
hstr = mat2str( h );

if testVerbose
    fprintf('\tchannel updated\n, impulse response is: \n\t\t%s\n', hstr)
end

assert( isequal( squeeze(h), eye(2,1) ) );

%% Test 8: 1 x 2 channel - propagate method (response to random inputs)


global testVerbose

if testVerbose
    fprintf('\nTesting 1x1 channel and propagate method\n')
end

% Test parameters
samplingRate = 1e6;
timeStep = 1e-3;
numberOfSymbols = 30;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = [1];
rxAnts = [1 2];

ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

x = rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) + ... 
    1i*rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) ;

t0 = 2*timeStep;
[y, h] = ch.propagate( x, t0 );

if testVerbose
    fprintf('\tsignal x transmitted in time %d\n', t0 )
    disp(num2str(x));
    fprintf('\t\toutput y\n')
    disp(num2str(y));
    fprintf('\t\timpulse response h\n')
    disp(num2str(h));
end

assert( all(y(:,1) == x ) );
assert( all(y(:,2) == 0 ) );


%% Test 9: 1 x 2 channel - flip method

global testVerbose


if testVerbose
    fprintf('\nTesting 1x2 channel and flip method\n')
end

% Test parameters
samplingRate = 1e5;
timeStep = 1e-3;
numberOfSymbols = 30;
seed = 13;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = [1];
rxAnts = [1 2];

ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate );

t0 = 2 * timeStep;
h1 = ch.update(t0);
h1 = reshape( h1, ch.numberOfRxAntennas, ch.numberOfTxAntennas);

ch.flip();

if testVerbose
    fprintf('\tchannel flipped\n')
end

t0 = 3*timeStep;
h2 = ch.update(t0);
h2 = reshape( h2, ch.numberOfRxAntennas, ch.numberOfTxAntennas);

hstr = mat2str( h2 );

if testVerbose
    fprintf('\tchannel updated\n, impulse response is: \n\t\t%s\n', hstr)
end

assert( all(h1 == h2.') )


%% Test 10: 2 x 2 channel - multiple channel impulse response

global testVerbose

if testVerbose
    fprintf('\nTesting 2x2 channel with multiple impulse responses\n')
end

%%%%%%%%%%%
% Test parameters
samplingRate = 1e6;
timeStep = 10/samplingRate;
numberOfSymbols = 100;
seed = 13;

channelSamplingInstants = [1:10] * timeStep;

% initialization
rnd = RandStream('mt19937ar', 'Seed', seed);
txAnts = [2 1];
rxAnts = [2 1];
if testVerbose
    fprintf( '\nchannel created with %d tx and %d rx antennas\n', ...
             length(txAnts), length(rxAnts) );
end
ch = channel.Channel( txAnts, rxAnts, rnd, samplingRate, timeStep );

h = ch.update( channelSamplingInstants );

if testVerbose
    hstr = mat2str( size(h) ) ;
    fprintf('\tchannel updated\n, impulse response has size\n', hstr)
end

assert( isequal( size(h), [ length(channelSamplingInstants), 1,  ...
                            ch.numberOfRxAntennas, ...
                            ch.numberOfTxAntennas ] ) );


assert( isequal (squeeze(h(1,1,:,:)), eye(2)))

x = rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) + ... 
    1i*rnd.randi([-1,1], numberOfSymbols, ch.numberOfTxAntennas ) ;

t0 = max ( channelSamplingInstants );
[y, h, instants] = ch.propagate( x, t0 );

assert( isequal( size(h), [ length( instants ), 1, ...
                            ch.numberOfRxAntennas, ...
                            ch.numberOfTxAntennas ] ) );
                        
assert( isequal (squeeze(h(2, 1, :, :)), eye(2)))