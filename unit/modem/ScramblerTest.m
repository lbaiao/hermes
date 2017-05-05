%LTESCRAMBLER function tests the SCRAMBLER class
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

scramblerObj = modem.Scrambler();

assert( isa ( scramblerObj, 'modem.Scrambler' ) );

%% Test 2: test whether descrambled output is equal to input.

scramblerObj = modem.Scrambler(  );

inputSequence = randi([0, 1], [400, 1] );

scrambledSequence = scramblerObj.scramble( inputSequence );
% make them llrs to test
scrambledLLR = ( scrambledSequence * 2 - 1 );

descrambledSequence = scramblerObj.descramble( scrambledLLR );

% transform llr in bits
descrambledSequence( descrambledSequence<0 ) = 0;

% descramble signal using the deeloped method
assert( all( inputSequence == descrambledSequence ) );



