classdef FadingChannel < channel.Channel
%FADINGCHANNEL class implements a multipath fading wireless channel
%   This class defines a multipath fading channel, multiple inputs and
%   multiple outputs.
%   Rayleigh/Rice fading and uncorrelated scattering is considered.
%   Fading follows Jakes' Doppler spectrum, using the simulation approach
%   from:
%   - C. Xiao, Zheng, Y. and Beaulieu, N. "Novel sum-of-sinusoids
%     simulation models for rayleigh and rician fading channels. IEEE
%     Trans. Wireless Comm., 5(12), 2006, 3667-3678
%   which is based on the sum of sinusoids with random phases.
%   This class is a subclass from channel.Channel.
%
%   Read-Only Public Properties:
%       delay_s - as described in constructor
%       dopplerSpread - as described in constructor
%       kRice_dB - as described in constructor
%       numberOfPaths - < 1 x 1 integer>
%       nuberOfSinusoids - as described in constructor (nSin)
%       rxCorrelationMatrix - as described in constructor
%                                            (rxCov)
%       txCorrelationMatrix - as described in constructor
%                                            (txCov)
%       powerDelayProfile_dB - as described in constructor
%                                            (powerDelayProfile_dB)
%   Constructor
%       Syntax: this = channel.FadingChannel( txAnts, rxAnts, random, 
%                             samplingRate, impulseResponseUpdatePeriod 
%                             dopplerSpread, delay_s, powerDelayProfile_dB,
%                             kRice_dB, rxCov, txCov, nSin, tailBiting )
%       Inputs:
%           profile - described in Channel
%           txAnts - described in Channel
%           rxAnts - described in Channel
%           random - described in Channel
%           samplingRate - described in Channel
%           impulseResponseUpdatePeriod - described in Channel
%           dopplerSpread - <1x1 double> (Hz) maximum Doppler frequency
%               fd = centerFrequency * velocity / speed of light
%               If dopplerSpread <= 0, then each transmitted block has a
%               multipath channel with independent fades at each block.
%           delay_s - <1 x L double> (s) is a vector containing the delays
%               in each of the L paths. If left empty, a single path with
%               zero delay is considered. Delays will be rounded to an
%               integer multiple of the sampling interval.
%           powerDelayProfile_dB - <1 x L double> (dB) is a vector
%               containing the power delay profile, i.e., the average power
%               of each path.
%               If left empty, then it is assumed that all the paths have
%               the same average power.
%           kRice_dB - <1 x L double> (dB) is a vector with the K factor
%               of the Ricean distribution for each path, i.e, the ratio
%               between the line-of-sight (LOS) and the scattered 
%               components. If left empty, then no LOS components are
%               considered. If a scalar is given, then it is assumed that
%               only the first path has a LOS component.
%           rxCov - <Nrx x Nrx complex> correlation matrix of receive 
%               antennas. If left empty,then uncorrelated antennas are
%               considered. Warning: The correlation matrix is not 
%               normalized inside the code.
%           txCov - <Ntx x Ntx complex> correlation matrix of receive 
%               antennas. If left empty,then uncorrelated antennas are
%               considered.
%           nSin - <1 x 1 integer> is the number of sinusoids considered in
%               the sum-of-sinusoids approach. If left empty, then 10
%               sinusoids are considered.
%           interFrameInterf - < enum.channel.InterFrameInterference > 
%               model of inter-frame interference
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <andre.barreto>@indt.org.br
%   History:
%       v1.0 20 Feb 2015 (ANB) - created (no multipath)
%       v2.0 25 Jun 2015 (ANB) - interframe interference added
%                                impulse response interpolation added
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


properties ( GetAccess = 'public', SetAccess = 'protected' )
    dopplerSpread = 0; % max Doppler frequency    
    delays_s = 0; % path delays in seconds
    numberOfPaths = 1;
    powerDelayProfile_dB = 0;
    kRice_dB = -inf % k factor in Ricean distribution
    rxCorrelationMatrix; %correlation matrix of rx antennas
    txCorrelationMatrix; %correlation matrix of tx antennas
    numberOfSinusoids = 10 % number o sinusoids in model
    % inter frame interference model
    interFrameInterf = enum.channel.InterFrameInterference.ACTUAL;
end

properties ( Access = 'protected' )
    maxDelay_samples; % maximum delay in samples
    filter; % interpolation filter matrix 
    powerDelayProfile; % PDP in linear scale   
    kRice; % k factor in Ricean distribution in linear scale
    losPhi; % initial phase of line-of-sight components
    losTheta; % angle of arrival of LOS component( default = 0);
    losGain; % gain of LOS Component
    nonLosGain; % gain of non-LOS component
    precodingMatrix; % precoding matrix for transmit antenna correlation
    postcodingMatrix; % postcoding matrix for receive antenna correlation
    phi, theta; % random phases of sinusoids representing initial phase and 
                % angle of arrival
    previousFrame = []; % interference samples from previous frame
end

methods
    
    % constructor
    function this = FadingChannel( txAnts, ...
                                   rxAnts, ...
                                   randomGen, ...
                                   samplingRate, ...
                                   updatePeriod, ...
                                   dopplerSpread, ...
                                   delays_s, powerDelayProfile_dB, kRice_dB, ...
                                   rxCov, txCov, nSin, interFrameInterf )
        
        if ~exist('updatePeriod', 'var')
            updatePeriod = inf;
        end
        
        this@channel.Channel ( txAnts, rxAnts, randomGen, samplingRate, ...
                               updatePeriod )
                           
        if exist( 'dopplerSpread', 'var' ) && ~isempty(dopplerSpread)
            this.dopplerSpread = dopplerSpread;
        else
            this.dopplerSpread = 0;
        end           
                                    
        % initialize delays
        if exist( 'delays_s', 'var' ) && ~isempty(delays_s)
            if size(delays_s, 1) > 1
                error ('''delays'' must be a row vector')
            end
            this.delays_s = delays_s;
        end
        this.numberOfPaths = size ( this.delays_s, 2 );
        
        
        % initialize power delay spectrum
        if exist( 'powerDelayProfile_dB', 'var' ) && ...
           ~isempty(powerDelayProfile_dB)
            if ~isequal( size( powerDelayProfile_dB ), size( this.delays_s ) )
                error ('PDP and delays must have the same size')
            end
            this.powerDelayProfile_dB = powerDelayProfile_dB;
        else
            this.powerDelayProfile_dB = zeros( 1, this.numberOfPaths );
        end
        
        % initialize parameters of Ricean distribution
        if exist('kRice_dB', 'var') && ~isempty( kRice_dB )
            if any( size( kRice_dB ) ~= size( this.delays_s ) )
                if length( kRice_dB ) > 1
                    error ('kRice and PDP vectors must have the same size')
                else
                    kRice_dB = [ kRice_dB, ...
                                 zeros( 1, this.numberOfPaths - 1 ) ];
                end
            end
            this.kRice_dB  = kRice_dB;
        else
            this.kRice_dB = -inf * ones( 1, this.numberOfPaths );
        end
       
        
        if exist('rxCov','var') && ~isempty(rxCov)
            if any ( size(rxCov) ~= this.numberOfRxAntennas )
                error ('rxCov has wrong size')
            end
            this.rxCorrelationMatrix = rxCov;
        else
            this.rxCorrelationMatrix = eye(this.numberOfRxAntennas);
        end
        
        if ~ishermitian( this.rxCorrelationMatrix ) 
            error( 'rx correlation matrix must be Hermitian')
        end
        
        if any( eig( this.rxCorrelationMatrix ) <= 0 )
            error( 'rx correlation matrix must be positive definite')
        end
        
        if exist('txCov','var') && ~isempty(txCov)
            if any ( size(txCov) ~= this.numberOfTxAntennas )
                error ('txCov has wrong size')
            end
            this.txCorrelationMatrix = txCov;
        else
            this.txCorrelationMatrix = eye(this.numberOfTxAntennas);
        end      
        
        if ~ishermitian( this.txCorrelationMatrix ) 
            error( 'tx correlation matrix must be Hermitian')
        end
        
        if any( eig( this.txCorrelationMatrix ) <= 0 )
            error( 'tx correlation matrix must be positive definite')
        end

        
        if exist( 'nSin', 'var') && ~isempty( nSin )
            this.numberOfSinusoids = nSin;
        end
        
        if exist( 'interFrameInterf', 'var') && ~isempty( interFrameInterf )
            this.interFrameInterf = interFrameInterf;
        end
        
        
        this.maxDelay_samples = ceil( max( this.delays_s ) * ...
                                      this.samplingRate );
                                  
        % calculate filter gains
        this.filter = zeros( this.numberOfPaths, ...
                             this.maxDelay_samples + 1 );
        for path = 1: this.numberOfPaths
            delay = (0: this.maxDelay_samples )/this.samplingRate;
            filter = sinc ( (delay - this.delays_s(path)) * ...
                            this.samplingRate );
            filterEnergy = sum( filter.^2 );
            filter = filter / sqrt( filterEnergy );
            this.filter( path, : ) = filter;
        end
        
        % calculate and normalize power delay profile
        this.powerDelayProfile = 10.^( this.powerDelayProfile_dB / 10 );        
        totalPower = sum ( real( this.powerDelayProfile ).^2 + ...
                           imag( this.powerDelayProfile ).^2 );
        this.powerDelayProfile = this.powerDelayProfile / sqrt(totalPower);
        
        this.kRice = 10 .^ ( this.kRice_dB / 10 );
        
        % initialize LOS component with random phase
        this.losPhi = 2 * pi * this.random.rand(1, this.numberOfPaths);
        this.losTheta = zeros( 1, this.numberOfPaths );
        this.losGain = sqrt( this.kRice ) ./ sqrt( 1 + this.kRice );
        this.nonLosGain = 1 ./ sqrt( 1 + this.kRice );
        this.losGain( this.kRice == inf ) = 1;
        this.nonLosGain( this.kRice == inf ) = 0;
        
        % calculate pre- and post-coding matrix for antenna correlation
        
        % normalize correlation matrices
                         
        
        this.precodingMatrix = (this.txCorrelationMatrix).^(1/2);
        this.postcodingMatrix = (this.rxCorrelationMatrix).^(1/2);
        
        % choose random phases of sinusoids in model
        sizeNSin = [ this.numberOfPaths, this.numberOfSinusoids, ...
                     this.numberOfRxAntennas, this.numberOfTxAntennas ];
        this.phi = this.random.rand( sizeNSin ) * 2 * pi - pi;
        this.theta =  this.random.rand( sizeNSin  ) * 2 * pi - pi;
        
        % initialize interference samples from previous frame
        if this.interFrameInterf == ...
           enum.channel.InterFrameInterference.ACTUAL
            this.previousFrame = zeros( this.maxDelay_samples, ...
                                        this.numberOfTxAntennas );
        end

    end
end

end