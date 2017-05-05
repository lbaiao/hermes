%WIFISCRAMBLERTEST function tests the WIFISCRAMBLER class
%   This function tests the creation of WIFISCRAMBLER object
%
%   Syntax: WifiScramblerTest
%
%   Author: Sergio Abreu (SA)
%   Work Address: INDT Manaus
%   E-mail: sergio.abreu@indt.org.br
%   History:
%       v2.0 23 June 2015 (SA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor
% Tests constructor of WifiScrambler class

initialSeed = randi(127);
scramblerObj = modem.WifiScrambler( initialSeed );

assert( isa ( scramblerObj, 'modem.WifiScrambler' ) );

%% Test 2: check scramble and descramble methods
% test whether descrambled output is equal to scrambler input.

% register initial conditions
initialSeed = randi(127);

% generation of input signal to be tested
inputSignal = randi([0, 1], [1,400] );

scramblerObj = modem.WifiScrambler( initialSeed );

% scramble signal using the developed method
scrambledSignal = scramblerObj.scramble( inputSignal' );

descrambledSignal = scramblerObj.descramble( scrambledSignal );

% test if the descramble result is equal to scrambler input
% matlab gold sequence.
assert( all( inputSignal' == logical( descrambledSignal ) ) );

%% Test 3: test full loop scrambler-descrambler and check output against the standard.

% register initial conditions (initial values of linear feedback shift register)
initialSeed = 89;

% load input-output pair of reference signals generated from tx11_ac
inputSignal = [0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 0; 1; 0; 0; 1; 0; 1; 1; 0; 0; 0; 1; 0;
    0; 0; 0; 1; 1; 0; 0; 1; 0; 1; 0; 1; 0; 1; 1; 0; 1; 1; 0; 0; 1; 0; 1; 1; 0; 1;
    1; 1; 0; 0; 1; 1; 1; 0; 1; 0; 0; 1; 1; 1; 0; 1; 1; 1; 1; 0; 1; 1; 0; 0; 0; 1;
    0; 1; 1; 0; 1; 1; 1; 1; 1; 1; 1; 0; 1; 1; 0; 1; 0; 0; 1; 0; 0; 1; 1; 0; 0; 1;
    1; 0; 1; 0; 1; 1; 1; 0; 0; 1; 0; 0; 1; 1; 0; 1; 1; 0; 0; 0; 1; 0; 1; 0; 1; 1;
    1; 0; 1; 1; 0; 1; 1; 0; 1; 1; 0; 1; 0; 0; 1; 1; 0; 0; 0; 1; 0; 1; 1; 0; 0; 1;
    0; 1; 0; 0; 1; 1; 1; 1; 0; 1; 1; 0; 0; 0; 0; 0; 1; 0; 0; 0; 1; 0; 0; 0; 0; 1;
    1; 1; 0; 1; 0; 0; 0; 1; 0; 1; 0; 0; 1; 1; 0; 0; 1; 0; 0; 0; 1; 0; 1; 1; 0; 1;
    0; 0; 1; 0; 1; 1; 1; 1; 0; 1; 0; 0; 1; 1; 0; 0; 0; 1; 1; 0; 0; 0; 0; 1; 1; 0;
    1; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0; 0; 0; 1; 0; 1];

% scrambler reference output
refout = [0; 0; 1; 0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 1; 0; 1; 0; 0; 1; 1; 1; 0; 1;
    0; 1; 0; 1; 0; 0; 0; 0; 1; 0; 0; 1; 0; 1; 0; 0; 0; 0; 1; 0; 1; 0; 0; 0;
    0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1; 1; 0; 1; 0; 1; 1; 0; 1; 1;
    1; 0; 0; 1; 1; 0; 1; 0; 1; 1; 1; 1; 0; 1; 0; 1; 1; 0; 0; 0; 0; 0; 1; 1;
    1; 0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 0; 1; 1; 0; 1; 1; 1; 1; 1; 0; 0; 0; 1;
    0; 0; 1; 1; 1; 0; 0; 0; 1; 0; 1; 0; 1; 1; 0; 1; 0; 0; 1; 1; 1; 1; 0; 1;
    0; 1; 0; 0; 1; 1; 1; 0; 0; 0; 1; 1; 1; 0; 0; 1; 0; 1; 1; 1; 0; 1; 0; 1;
    0; 0; 1; 1; 1; 1; 0; 1; 1; 0; 1; 1; 1; 1; 1; 0; 1; 0; 1; 0; 1; 0; 0; 0;
    0; 0; 1; 1; 1; 0; 0; 0; 1; 0; 0; 1; 0; 0; 1; 1; 1; 0; 1; 1; 1; 0; 1; 1;
    0; 0; 1; 0; 0; 0; 1; 0; 0; 1; 0; 1; 1; 1; 1; 0; 0; 0; 1; 0; 0; 1; 0; 1;
    0; 0; 0; 1; 1; 0; 0; 0; 0; 0];

scramblerObj = modem.WifiScrambler( initialSeed );

% scramble
scrambledSignal = scramblerObj.scramble( inputSignal );
% test if scrambled signal is equal to reference standard scrambler output:
assert( all( scrambledSignal == logical( refout) ) );

% descramble the scrambled signal:
descrambledSignal = scramblerObj.descramble( scrambledSignal );
% test if descrambled signal is equal to scrambler input:
assert( all( inputSignal == descrambledSignal ) );

%% Test 4: test update the linear feedback shift register.
% register initial conditions (initial values of linear feedback shift register)

initialSeed = randi(127);
scramblerObj = modem.WifiScrambler( initialSeed );
newSeed = 101;
scramblerObj.updateRegisterInitialValue(newSeed);
assert( scramblerObj.initialRegisterState == newSeed );