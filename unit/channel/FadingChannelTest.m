%FADINGCHANNELTEST script tests the FadingChannel class
% This function tests the creation of a FadingChannel object and its methods
%
%   Syntax: FadingChannelTest
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


%% Test 1: Check constructor
% verify if properties are correctly initialized with full and with empty
% constructor calls

global testVerbose;
if isempty(testVerbose)
    testVerbose = true;
end

txAnts = networkEntity.IsotropicAntenna([0 0 0]);
rxAnts = networkEntity.IsotropicAntenna([0 0 0]);
rnd = RandStream.getGlobalStream;
samplingRate = 1e6;
updatePeriod = 10e6;
dopplerSpread = rand()*20;
delays_s = [1 2 3 4 5]/samplingRate;
powerDelayProfile_dB = rand( 1, length(delays_s) ) * (-10);
kRice_dB = rand( 1, length(delays_s) ) * 20 - 10;
rxCov = 1;
txCov = 1;
nSin = 10;

ch = channel.FadingChannel( txAnts, rxAnts, rnd, samplingRate, ...
                            updatePeriod, dopplerSpread, delays_s, ...
                            powerDelayProfile_dB, kRice_dB, ...
                            rxCov, txCov, nSin, ...
                            enum.channel.InterFrameInterference.NONE);

propertiesChecked = ( ch.samplingRate == samplingRate ) && ...
                    ( ch.numberOfTxAntennas == length( txAnts ) ) && ...
                    ( ch.numberOfRxAntennas == length( rxAnts ) ) && ...
                    ( ch.timeStamp == 0 ) && ...
                    ( ch.impulseResponseUpdatePeriod == updatePeriod ) && ...
                    ( ch.dopplerSpread == dopplerSpread ) && ...
                    isequal( ch.delays_s, delays_s ) && ...
                    ( ch.numberOfPaths == length( delays_s ) ) && ...
                    isequal ( ch.powerDelayProfile_dB, powerDelayProfile_dB ) && ...
                    isequal ( ch.kRice_dB, kRice_dB ) && ...
                    isequal ( ch.rxCorrelationMatrix, rxCov ) && ...
                    isequal ( ch.txCorrelationMatrix, txCov ) && ...
                    ( ch.numberOfSinusoids == nSin ) && ...
                    ( ch.interFrameInterf == ...
                      enum.channel.InterFrameInterference.NONE );

  
ch = channel.FadingChannel( txAnts, rxAnts, rnd, samplingRate );                
                
propertiesChecked = propertiesChecked && ...
                    ( ch.samplingRate == samplingRate ) && ...
                    ( ch.numberOfTxAntennas == length( txAnts ) ) && ...
                    ( ch.numberOfRxAntennas == length( rxAnts ) ) && ...
                    ( ch.timeStamp == 0 ) && ...
                    ( ch.impulseResponseUpdatePeriod == inf ) && ...
                    ( ch.dopplerSpread == 0 ) && ...
                    ( ch.delays_s == 0 ) && ...
                    ( ch.numberOfPaths == 1 ) && ...
                    ( ch.powerDelayProfile_dB == 0 ) && ...
                    ( ch.kRice_dB == -inf ) && ...
                    ( ch.rxCorrelationMatrix == 1 ) && ...
                    ( ch.txCorrelationMatrix == 1 ) && ...
                    ( ch.numberOfSinusoids == 10 ) && ...
                    ( ch.interFrameInterf == ...
                      enum.channel.InterFrameInterference.ACTUAL );
                   
assert( propertiesChecked )

%% Test 2: 1x1 single-path Rayleigh/Rice channel - verify reported response
% 1 - compare the generated impulse response with the output of a unit
%     input
% 2 - compare the measured and the theoretical channel autocorrelation
% 3 - compare the output amplitude distribution with the theoretical 
%     Rayleigh distribution using the Kullback-Leibler divergence

% set verbose here if performing test for this class only
global testVerbose;

if testVerbose
    fprintf('\nTesting 1x1 single path Rayleigh channel\n')
end

passedAllTests = true;

rnd = RandStream.getGlobalStream;

samplingRate = 1e5; 
dt = 1e-2; % time interval between channel samples
nSymbs = 5000000; % number of samples in frame for single-path test
nsins = randi([10,20]); % number of sinusoids in model
                              % (between 10 and 20)

fd = rand() * 40 + 10; % Doppler spread in Hz (between 10 and 50 Hz)

NCorr = round( 2 * samplingRate/fd ); % number of samples in autocorrelation

txAnts = 1;
rxAnts = 1;

if testVerbose
    fprintf('\nsingle-path Rayleigh channel created with %d tx and %d rx antennas, f_d %fHz\n', ...
        length(txAnts), length(rxAnts), fd );
end

ch = channel.FadingChannel( 1, 1, rnd, samplingRate, dt, fd, 0,0, [], ...
                            [], [], nsins, false );
x = ones(nSymbs,1);
[y, h, tsamp] = ch.propagate(x,0);
tref = (1:nSymbs) / samplingRate;

if testVerbose
    figure
    fprintf('\tshowing sample response\n' );
    plot(tref,20*log10(abs(y)), tsamp, 20*log10(abs(h)));
    legend('output', 'channel response');
end

% compare actual output with impulse response
ysamp = interp1( tref, y, tsamp, 'pchip', 'extrap' );
mse = sum(abs(ysamp(2:end)-h(2:end).').^2)/length(ysamp);
normMse = mse/ sum(abs(h).^2);

if(normMse > 0.01)
    passedAllTests = false;
    fprintf('reported channel response is different from actual one\n');
end

Rhr = xcorr(real(y),real(y), NCorr)/length(y);
Rhi = xcorr(imag(y),imag(y), NCorr)/length(y);
Rhx = xcorr(real(y),imag(y), NCorr)/length(y);
tcorr = (-NCorr:NCorr)'/samplingRate;
theoryCorr = .5 * real( besselj( 0,2*pi*fd*tcorr ) );

if testVerbose
    figure
    fprintf('\tshowing correlation and spectrum\n' );
    plot( tcorr, Rhr, tcorr,Rhi, tcorr, Rhx, ...
          tcorr, theoryCorr );
    title('autocorrelation')
    legend('measured  (R)','measured (I)','measured (cross)', ...
           'theoretical (I,R)')
    
    figure
    f = [-1.25*fd:fd/100:1.25*fd];
    pwelch(h,[],[],f,1/dt)
 
end

% compare measured autocorrelation with theory
mse = sum( (Rhr - theoryCorr).^2 + (Rhi - theoryCorr).^2 )/ 2 / NCorr;

if mse > 0.1
    passedAllTests = false;
    fprintf('measured autocorrelation function is different than theoretical one by more than the allowed error margin\n');
end

hmod = abs(y);
[n,bins] = hist(hmod,100);
varh = 1/2;
pdf = n/length(hmod)/(bins(2)-bins(1));
rayleigh = raylpdf(bins, sqrt(varh));

% verify the Kullback-Leibler divergence
binWidth = bins(2) - bins(1);
pmf = pdf * binWidth;
raylPmf = rayleigh * binWidth;
kl_div = sum(raylPmf .* log(raylPmf./pmf));

if testVerbose
    figure()
    fprintf( '\tshowing probability density, Kullback-Leibler divergence = %d\n', ...
             kl_div );
    plot(bins, pdf, bins, rayleigh);
    title('Rayleigh Channel')
    legend('simulation','theory');
end

if (kl_div > 0.01)
    passedAllTests = false;
    fprintf('measured probability density diverges from theoretical Rayleigh by more than the allowed margin\n');
end


assert(passedAllTests)


%% Test 3: 1x1 single-path Rice channel

% 1 - compare the output amplitude distribution with the theoretical 
%     Rice distribution using the Kullback-Leibler divergence

global testVerbose;

if testVerbose
    fprintf('\nTesting 1x1 single path Ricean channel\n')
end

samplingRate = 1e5;
rnd = RandStream.getGlobalStream;
dt = 1e-2; % time interval between channel samples
nSymbs = 5000000; % number of samples in frame for single-path test
nsins = 20; % number of sinusoids in model
KRice = rand()*10; % Ricean K factor in dB
fd = rand() * 40 + 10; % Doppler spread in Hz

   
ch = channel.FadingChannel( 1, 1, rnd, samplingRate, dt, fd, 0,0, KRice, ...
                            [], [], nsins, false );

if testVerbose
    fprintf('\nsingle-path Ricean channel created with %d tx and %d rx antennas, f_d %fHz, K = %f dB\n', ...
        length(txAnts), length(rxAnts), fd, KRice );
end    

x = ones(nSymbs,1);
y = ch.propagate(x,0);


hmod = abs(y);
[n,bins] = hist(hmod,100);
pdf = n/length(hmod)/(bins(2)-bins(1));
K = 10^(KRice/10);
nu = sqrt(K/(1+K)); % nu^2/(1-nu^2)=K
sigma2 = (1-nu^2)/2; % nu^2 + 2 sigma^2 = 1;
pdfTheory = (bins/sigma2).*exp(-(bins.^2+nu^2)/(2*sigma2)).*besseli(0,bins*nu/sigma2);

% verify the Kullback-Leibler divergence
binWidth = bins(2) - bins(1);
pmf = pdf * binWidth;
ricePmf = pdfTheory * binWidth;
kl_div = sum(ricePmf .* log(ricePmf./pmf));

if testVerbose
    figure(5)
    fprintf('\tshowing probability density, Kullback-Leibler divergence = %d\n', ...
             kl_div  );

    plot(bins, pdf, bins, pdfTheory);
    legend('simulation','theory');
end

assert( kl_div < .1 );

%% Test 4: 1x1 multipath Rayleigh channel

% 1 - compare the desired power delay profile with the one obtained in
%     simulation
% 2 - compare the given impulse response with the output with a unitary
%     input

global testVerbose

if testVerbose
    fprintf('\nTesting 1x1 multipath channel\n')
end

passedAllTests = true;

rnd = RandStream.getGlobalStream;
samplingRate = 1e6;
dt = 1e-3; % time interval between channel samples
nSymbs = 100000; % number of samples in frame for single-path test
nsins = 20; % number of sinusoids in model
KRice = rnd.rand()*10; % Ricean K factor in dB
fd = rnd.rand() * 40 + 10; % Doppler spread in Hz

% number of Paths
maxPaths = 10;
nPaths = rnd.randi( [3, maxPaths] );


% multipath delays
maxDelay = 20;
delays = randi([0, maxDelay], 1, nPaths) / samplingRate;
delays = unique( sort( delays - min( delays) ) );
nPaths = length( delays );


% power delay profile in dB
pdp = -rand(1, nPaths) * 10;
pdp = pdp - max(pdp);

tmax = 10; % simulation time in seconds for multipath test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testing multipath channel and update function
txAnts = 1;
rxAnts = 1;
fprintf('\n%n-path channel created with %d tx and %d rx antennas, f_d %fHz\n', ...
        nPaths, length(txAnts), length(rxAnts), fd );
ch = channel.FadingChannel( txAnts, rxAnts, rnd, samplingRate, dt, fd, ...
                            delays, pdp, [], [], [], nsins, false);

tref = (0:dt:tmax)';
h = ch.update( tref );

delays_index = round( delays * samplingRate ) + 1;

realPDP = mean(real(h).^2 + imag(h).^2 );
realPDP = realPDP( delays_index );
real_PDP_dB = 10*log10(realPDP);
real_PDP_dB = real_PDP_dB - max( real_PDP_dB );

if testVerbose
    delaysPlot = 0:1/samplingRate:max(delays);
    
    fprintf('\tshowing multipath channel sample\n' );
    figure()
    if length(delaysPlot) > 1
        surf( delaysPlot, tref, abs(h))
        xlabel('time')
        ylabel('\tau(delay)')
        title('channel impulse response')
    else
        plot(tref, abs(h))
        xlabel('time')
        title('channel impulse response')
    end

    fprintf('\tdesired power delay profile = %s\n', mat2str(pdp) );
    fprintf('\tmeasured power delay profile = %s\n', mat2str(real_PDP_dB) );

end

mse = sum( ( pdp - real_PDP_dB).^2 ) / nPaths;

if mse > 0.1
    passedAllTests = false;
    fprintf('measured power delay profile is different from desired one by more than the allowed margin\n');
end

% compare the given impulse response with the output with a unitary input
in = zeros( nSymbs, 1 );
impulseInterval = round( dt * samplingRate );
nImpulses = floor( nSymbs / impulseInterval );
in( (0 : nImpulses - 1) * impulseInterval + 1 ) = 1;
[y, h, t] = ch.propagate( in, 10 * dt );

h = squeeze( h );
h = h.';

yh = y( 1: nImpulses * impulseInterval );
yh = reshape( yh,  impulseInterval, nImpulses );
yh = yh( 1 : size(h,1), : );
h = h( : , 1 : size(yh,2) ); 

mse = sum( sum ( abs( h - yh )'.^2 ) ) / numel( h ) ;

if mse > 1e-4
    passedAllTests = false;
    fprintf('measured impulse response is different from the one reported\n')
end

assert( passedAllTests );

%% Test 5: 1x1 multipath channel with tail biting
% verify if difference between signal with tail biting and without tail
% biting corresponds to the expected

global testVerbose

if testVerbose
    fprintf('\nTesting 1x1 multipath channel with tail biting\n')
end
passedAllTests = true;

seed = randi(10000);

samplingRate = 1e6;
dt = 1e-3; % time interval between channel samples
nSymbs = 100000; % number of samples in frame for single-path test
nsins = 20; % number of sinusoids in model
KRice = rand()*10; % Ricean K factor in dB
fd = rand() * 40 + 10; % Doppler spread in Hz

% number of Paths
maxPaths = 10;
nPaths = randi( [3, maxPaths] );


% multipath delays
maxDelay = 20;
delays = randi([0, maxDelay], 1, nPaths) / samplingRate;
delays = unique( sort( delays - min( delays) ) );
nPaths = length( delays );

% power delay profile in dB
pdp = -rand(1, nPaths) * 10;
pdp = pdp - max(pdp);

tmax = 10; % simulation time in seconds for multipath test
in = randn( nSymbs, 1 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% channel without tail biting
txAnts = 1;
rxAnts = 1;
rnd = RandStream('mt19937ar','Seed',seed);

fprintf('\n%n-path channel created with %d tx and %d rx antennas, f_d %fHz\n', ...
        nPaths, length(txAnts), length(rxAnts), fd );
ch1 = channel.FadingChannel( txAnts, rxAnts, rnd, samplingRate, dt, fd, ...
                            delays, pdp, [], [], [], nsins, ...
                            enum.channel.InterFrameInterference.NONE );
outNoTailBiting = ch1.propagate( in, 0 );
excessDelay = length( outNoTailBiting ) - length( in ); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% channel with tail biting
rnd = RandStream('mt19937ar','Seed',seed);

fprintf('\n%n-path channel created with %d tx and %d rx antennas, f_d %fHz\n', ...
        nPaths, length(txAnts), length(rxAnts), fd );
ch2 = channel.FadingChannel( txAnts, rxAnts, rnd, samplingRate, dt, fd, ...
                            delays, pdp, [], [], [], nsins, ...
                            enum.channel.InterFrameInterference.TAIL_BITING );

outTailBiting = ch2.propagate( in, 0 );

expectedTailBiting = outNoTailBiting;
expectedTailBiting( 1:excessDelay ) = ...
                                expectedTailBiting ( 1:excessDelay ) + ...
                                outNoTailBiting( length(in) + 1:end );
err = outTailBiting - expectedTailBiting;
mse = mean( real(err).^2 + imag(err).^2 );

assert(mse < 1e-10);






