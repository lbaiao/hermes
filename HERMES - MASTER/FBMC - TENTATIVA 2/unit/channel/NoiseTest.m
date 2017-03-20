%NOISETEST script tests the Noise class
% This function test the creation of a Noise object and its methods. The
% tests compare the desired Eb/N0 with the measured Eb/N0.
%
%   Syntax: NoiseTest
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

      

%% Test 1: Test constructor Noise(rnd, EbN0, Eb) and addNoise method
% In this test a Noise object is instanced with a random EbN0 between 0 and
% 10dB, and Eb is set to 1. A two-dimensional signal with Eb is generated
% and noise is added to it. The Eb/N0 at the output of the function is
% measured and compared with the desired value. This is repeated several
% times and the error between the desired and the measured values must
% converge within a given number of repetitions.

% set verbose here if performing test for this class only
global testVerbose;
if isempty(testVerbose)
    testVerbose = true;
end

maxError = 0.01; % maximum error between desired and measured Eb/N0 (in dB)
maxBlocks = 50; % maximum number of blocks for convergence

EbN0_dB = rand() * 10; % randomly 0-10dB

s = RandStream.getGlobalStream;

if testVerbose
    fprintf('create Noise with Eb/N0 = %f dB, Eb = %fdB\n', EbN0_dB, 1.0);
end
awgn = channel.Noise( s, EbN0_dB, 1);

% size of data block
rows= 10;
cols = 1000;

% verify if measured Eb/N0 converges to EbN0_dB1 in maxBlocks data blocks
EbN0 = [];
for block = 1:maxBlocks
    % generate a rows x cols random binary polar signal with unitary bit energy
    nbits = rows*cols;
    x = 2 * randi([0,1], rows, cols) - 1;
    
    y = awgn.addNoise(x);
    
    %calculate Eb/N0
    Eb_in = sum(sum(abs(x).^2))/nbits;
    N0_out = sum(sum(abs(y-x).^2))/nbits;
    EbN0(block) = Eb_in / N0_out;
    EbN0dB_real = 10*log10( EbN0(block) );
    
    averageEbN0 = mean(EbN0);
    avEbN0_dB = 10*log10(averageEbN0);
    
    if testVerbose
        fprintf( '\tadd noise to a %dx%d matrix, with Eb = 1, output Eb/N0 = %fdB, average Eb/N0 = %fdB\n', ...
                 rows, cols, EbN0dB_real, avEbN0_dB );
    end
    
    error = abs(avEbN0_dB - EbN0_dB);
    if  error < maxError
        break
    end
end

if testVerbose
    figure
    plot(y,'*r')
    str = sprintf('BPSK constellation, Eb/N0 = %fdB', EbN0_dB);
    title(str)
end
assert(error < maxError)


%% Test 2: Test setEbN0 method
% This test is similar to Test 1, except that the Eb/N0 is chosen with the
% method setEbN0 before noise is added.

global testVerbose

maxError = 0.01; % maximum error between desired and measured Eb/N0 (in dB)
maxBlocks = 50; % maximum number of blocks for convergence

EbN0_dB = rand() * 10; % randomly 0-10dB

s = RandStream.getGlobalStream;

if testVerbose
    fprintf('create Noise with Eb/N0 = %f dB, Eb = %fdB\n', EbN0_dB, 1.0);
end
awgn = channel.Noise( s, EbN0_dB, 1);

% size of data block
rows= 10;
cols = 1000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change Eb/N0 and test again
EbN0_dB = rand() * 10; % randomly 0-10dB
awgn.setEbN0_dB( EbN0_dB );
if testVerbose
    fprintf('\tchange Eb/N0 to %f\n', EbN0_dB);
end

% verify if measured Eb/N0 converges to new EbN0_dB in maxBlocks data blocks
EbN0 = [];
for block = 1:maxBlocks
    % generate a rows x cols random binary polar signal with unitary bit energy
    nbits = rows*cols;
    x = 2 * randi([0,1], rows, cols) - 1;
    
    y = awgn.addNoise(x);
    
    %calculate Eb/N0
    Eb_in = sum(sum(abs(x).^2))/nbits;
    N0_out = sum(sum(abs(y-x).^2))/nbits;
    EbN0(block) = Eb_in / N0_out;
    EbN0dB_real = 10*log10( EbN0(block) );
    
    averageEbN0 = mean(EbN0);
    avEbN0_dB = 10*log10(averageEbN0);
    
    if testVerbose
        fprintf( '\tadd noise to a %dx%d matrix, with Eb = 1, output Eb/N0 = %fdB, average Eb/N0 = %fdB\n', ...
                 rows, cols, EbN0dB_real, avEbN0_dB );
    end
    
    error = abs(avEbN0_dB - EbN0_dB);
    if  error < maxError
        break
    end
end

assert(error < maxError)


%% Test 3: Test constructor Noise(rnd, EbN0) and addNoise method 
% Test is similar as Test 1, but with a different constructor, meaning that
% Eb is calculate in real time.
% The signal consists in a zero matrix with ones (bits) included at a
% random interval for each block, resulting in a random bit energy

global testVerbose

maxError = 0.01; % maximum error between desired and measured Eb/N0 (in dB)
maxBlocks = 50; % maximum number of blocks for convergence

EbN0_dB = rand() * 10; % randomly 0-10dB

s = RandStream.getGlobalStream;

if testVerbose
    fprintf('create Noise with Eb/N0 = %f dB, Eb = %fdB\n', EbN0_dB, 1.0);
end
awgn = channel.Noise( s, EbN0_dB );

% generate signal matrix with 2^10 columns.
maxSizeLog = 10;
rows= 10;
cols = 2^maxSizeLog;

bitInterval = 2^randi([0,maxSizeLog-1]);
if testVerbose
    fprintf( '\tgenerate bit sequence with %d samples interval\n', ...
             bitInterval )
end

% verify if measured Eb/N0 converges to EbN0_dB1 in maxBlocks data blocks
EbN0 = [];
for block = 1:maxBlocks
    % generate a rows x cols random binary polar signal with unitary bit
    % energy every second sample
    nbits = rows*cols / bitInterval;
    x = zeros(rows, cols);
    x(:,1:bitInterval:end) = 2 * randi([0,1], rows, cols/bitInterval) - 1;
    
    y = awgn.addNoise(x, nbits);
    
    %calculate Eb/N0
    Eb_in = sum(sum(abs(x).^2))/nbits;
    N0_out = sum(sum(abs(y-x).^2))/(rows * cols );
    EbN0(block) = Eb_in / N0_out;
    EbN0dB_real = 10*log10( EbN0(block) );
    
    averageEbN0 = mean(EbN0);
    avEbN0_dB = 10*log10(averageEbN0);
    
    if testVerbose
        fprintf( '\tadd noise to a %dx%d matrix, output Eb/N0 = %fdB, average Eb/N0 = %fdB\n', ...
                 rows, cols, EbN0dB_real, avEbN0_dB );
    end
    
    error = abs(avEbN0_dB - EbN0_dB);
    if  error < maxError
        break
    end
end

if testVerbose
    figure
    plot(y,'*r')
    str = sprintf('BPSK constellation, Eb/N0 = %fdB', EbN0_dB);
    title(str)
end
assert(error < maxError)

%% Test 4: Test addNoise method with reference signal
% Similar as Test 3, but Eb is calculated based on reference signal instead
% of input.

global testVerbose

maxError = 0.01; % maximum error between desired and measured Eb/N0 (in dB)
maxBlocks = 50; % maximum number of blocks for convergence

EbN0_dB = rand() * 10; % randomly 0-10dB

s = RandStream.getGlobalStream;

if testVerbose
    fprintf('create Noise with Eb/N0 = %f dB, Eb = %fdB\n', EbN0_dB, 1.0);
end
awgn = channel.Noise( s, EbN0_dB );

% generate signal matrix with 2^10 columns.
maxSizeLog = 10;
rows= 10;
cols = 2^maxSizeLog;

bitInterval = 2^randi([0,maxSizeLog-1]);
if testVerbose
    fprintf( '\tgenerate bit sequence with %d samples interval\n', ...
             bitInterval )
end

fading = ( randn() + 1i * randn() )/sqrt(2);

% verify if measured Eb/N0 converges to EbN0_dB1 in maxBlocks data blocks
EbN0 = [];
for block = 1:maxBlocks
    % generate a rows x cols random binary polar signal with unitary bit
    % energy every second sample
    nbits = rows*cols / bitInterval;
    x = zeros(rows, cols);
    x(:,1:bitInterval:end) = 2 * randi([0,1], rows, cols/bitInterval) - 1;
    
    xFaded = x * fading;
    
    % EbN0 in relation to original signal
    y = awgn.addNoise(xFaded, nbits, x);
    
    %calculate Eb/N0
    Eb_in = sum(sum(abs(x).^2))/nbits;
    N0_out = sum(sum(abs(y-xFaded).^2))/(rows * cols );
    EbN0(block) = Eb_in / N0_out;
    EbN0dB_real = 10*log10( EbN0(block) );
    
    averageEbN0 = mean(EbN0);
    avEbN0_dB = 10*log10(averageEbN0);
    
    if testVerbose
        fprintf( '\tadd noise to a %dx%d matrix, output Eb/N0 = %fdB, average Eb/N0 = %fdB\n', ...
                 rows, cols, EbN0dB_real, avEbN0_dB );
    end
    
    error = abs(avEbN0_dB - EbN0_dB);
    if  error < maxError
        break
    end
end

if testVerbose
    figure
    plot(y,'*r')
    str = sprintf('BPSK constellation, Eb/N0 = %fdB', EbN0_dB);
    title(str)
end
assert(error < maxError)

%% Test 5: Test constructor Noise(rnd) and addNoise method 
% Similar to Test 3, but with a default Eb/N0

global testVerbose

maxError = 0.01;
maxBlocks = 50;

s = RandStream.getGlobalStream;

if testVerbose
    fprintf( 'create Noise' );
end
awgn = channel.Noise( s );

if testVerbose
    fprintf('\tEb/N0 is set to %f\n', awgn.EbN0_dB);
end

maxSizeLog = 10;
rows= 10;
cols = 2^maxSizeLog;

bitInterval = 2^randi([0,maxSizeLog-1]);
if testVerbose
    fprintf( '\tgenerate bit sequence with %d samples interval\n', ...
             bitInterval )
end

% verify if measured Eb/N0 converges to EbN0_dB in maxBlocks data blocks
EbN0 = [];
for block = 1:maxBlocks
    % generate a rows x cols random binary polar signal with unitary bit
    % energy every second sample
    nbits = rows*cols / bitInterval;
    x = zeros(rows, cols);
    x(:,1:bitInterval:end) = 2 * randi([0,1], rows, cols/bitInterval) - 1;
    
    y = awgn.addNoise(x, nbits);
    
    %calculate Eb/N0
    Eb_in = sum(sum(abs(x).^2))/nbits;
    N0_out = sum(sum(abs(y-x).^2))/(rows * cols );
    EbN0(block) = Eb_in / N0_out;
    EbN0dB_real = 10*log10( EbN0(block) );
    
    averageEbN0 = mean(EbN0);
    avEbN0_dB = 10*log10(averageEbN0);
    
    if testVerbose
        fprintf( '\tadd noise to a %dx%d matrix, output Eb/N0 = %fdB, average Eb/N0 = %fdB\n', ...
                 rows, cols, EbN0dB_real, avEbN0_dB );
    end
    
    error = abs(avEbN0_dB - awgn.EbN0_dB);
    if  error < maxError
        break
    end
end


