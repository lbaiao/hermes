%LTESCRAMBLERTEST function tests the LTESCRAMBLER class
%   This function tests the creation of LTESCRAMBLER object
%
%   Syntax: LteScramblerTest
%
%   Author: Erika Almeida (EA)
%   Work Address: INDT Brasilia
%   E-mail: erika.almeida@indt.org.br
%   History:
%       v2.0 06 May 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor
% Tests constructor of LteScrambler class


lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
frame = modem.LteFrameAssembler( LTE, RandStream.getGlobalStream );

scramblerObj = modem.LteScrambler( frame );

assert( isa ( scramblerObj, 'modem.LteScrambler' ) );

%% Test 2: check scramble method
% this test compares the result obtained using matlab gold sequence
% generator with the implementation of method scramble.

% polynomia initial conditions
RNTI = 100;
NcellID = 10;
subframeNumber = 0;
codeword = 0;

% generation of input signal to be tested
inputSignal = randi([0, 1], [1,400] );

% inputSignal = cell( 1 );
% inputSignal{ 1 } = u;

nSamp = size(inputSignal, 1);

% from TR 36.211
c_init = RNTI*(2^14) + codeword*(2^13) + floor(subframeNumber/2)*(2^9) + ...
                        NcellID;
% Convert to binary vector
iniStates = de2bi(c_init, 31, 'left-msb');

% Scrambling sequence - as per Section 7.2, 36.211 using matlab gold
% sequence
hSeqGen = comm.GoldSequence('FirstPolynomial',[1 zeros(1, 27) 1 0 0 1],...
    'FirstInitialConditions', [zeros(1, 30) 1], ...
    'SecondPolynomial', [1 zeros(1, 27) 1 1 1 1],...
    'SecondInitialConditions', iniStates,...
    'Shift', 1600,...
    'SamplesPerFrame', nSamp);

 
 for i = 1 : length( inputSignal )
     seq = step(hSeqGen); 
     y( i ) = ( xor( inputSignal(i),seq ) );
 end
 
 scramblerOutputMatlab = y;
 
 % build scrambler object
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
frame = modem.LteFrameAssembler( LTE, RandStream.getGlobalStream );

 scramblerObj = modem.LteScrambler( frame );
 
 % scramble signal using the developed method
 scrambledSignal = scramblerObj.scramble( inputSignal' );
 
 % test if our scrambling implementation is equal to scrambling with 
 % matlab gold sequence.
 assert( all( scrambledSignal' == logical( scramblerOutputMatlab ) ) );
 
 %% Test 3
 % test whether descrambled output is equal to scrambler input.
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
frame = modem.LteFrameAssembler( LTE, RandStream.getGlobalStream );
scramblerObj = modem.LteScrambler( frame );


inputSequence = randi([0, 1], [4000,1] );


scrambledSequence = scramblerObj.scramble( inputSequence );

% generate llr versions
scrambledLLR = ( scrambledSequence * 2 - 1 ).*rand(size( inputSequence ));
% scrambledLLR = scrambledSequence;

descrambledSequence = scramblerObj.descramble( scrambledLLR );

descrambledSequence( descrambledSequence<0 ) = 0;
descrambledSequence( descrambledSequence~=0 ) = 1;
assert( all( inputSequence == descrambledSequence ) );

%% Test 4
% test method update2ndPolyInitialValue( subframeNumber )
subframeNumber = 9*randi([ 0, 1], 1 );

% polynomia initial conditions
RNTI = 100;
NcellID = 10;
codeword = 0;

% generation of input signal to be tested
inputSignal = randi([0, 1], [1,400] );


nSamp = size(inputSignal, 1);

% from TR 36.211
c_init = RNTI*(2^14) + codeword*(2^13) + floor(subframeNumber/2)*(2^9) + ...
                        NcellID;
% Convert to binary vector
iniStates = de2bi(c_init, 31, 'left-msb');

% Scrambling sequence - as per Section 7.2, 36.211 using matlab gold
% sequence
hSeqGen = comm.GoldSequence('FirstPolynomial',[1 zeros(1, 27) 1 0 0 1],...
    'FirstInitialConditions', [zeros(1, 30) 1], ...
    'SecondPolynomial', [1 zeros(1, 27) 1 1 1 1],...
    'SecondInitialConditions', iniStates,...
    'Shift', 1600,...
    'SamplesPerFrame', nSamp);
 
for i = 1 : length( inputSignal )
    seq = step(hSeqGen);
    y( i ) = ( xor( inputSignal(i),seq ) );
end

scramblerOutputMatlab = y';

% build scrambler object
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = 10;
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
frame = modem.LteFrameAssembler( LTE, RandStream.getGlobalStream );
scramblerObj = modem.LteScrambler( frame  );

% update subframe number
scramblerObj.update2ndPolyInitialValue( subframeNumber  );


% scramble signal using the developed method
scrambledSequence = scramblerObj.scramble( inputSignal' );

scrambledLLR = ( scrambledSequence * 2 - 1 );
% descramble signal using the deeloped method
descrambledSequence = scramblerObj.descramble( scrambledLLR );

descrambledSequence( descrambledSequence<0 ) = 0;

assert( all( inputSignal' == descrambledSequence ) );
