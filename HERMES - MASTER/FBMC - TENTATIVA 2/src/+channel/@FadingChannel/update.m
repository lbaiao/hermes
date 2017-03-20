function impulseResponse = update ( this, time, nSamples, samplingRate )
%FADINGCHANNEL.UPDATE updates channel and returns impulse response
%   Usage description can be found in class header.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <andre.barreto>@indt.org.br
%   History:
%       v2.0 01 Jul 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if  exist( 'nSamples', 'var' )
    if length( time ) > 1
        error( 'time must be a scalar')
    end
    
    if ~exist( 'samplingRate', 'var' )
        samplingRate = this.samplingRate;
    end
    
    time = time + ( 0 : nSamples - 1 ).' / samplingRate;
else
    nSamples = length( time );
end

% initialize impulse response
impulseResponse = zeros( nSamples, this.maxDelay_samples + 1, ...
                         this.numberOfRxAntennas, this.numberOfTxAntennas );

% normalization factor                     
normFactor = sqrt( 1 / this.numberOfSinusoids );

dopplerFreq = this.dopplerSpread;


if this.dopplerSpread <= 0
    % choose random phases of sinusoids in model to guarantee independent
    % channel samples for each block

    sizeNSin = [ this.numberOfPaths, this.numberOfSinusoids, ...
                 this.numberOfRxAntennas, this.numberOfTxAntennas ];
    this.phi = this.random.rand( sizeNSin ) * 2 * pi - pi;
    this.theta =  this.random.rand( sizeNSin  ) * 2 * pi - pi;
                                        
end

% calculate time-varying impulse response at each receive antenna
for rxAnt = 1 : this.numberOfRxAntennas
   
    % add signal coming from all transmit antennas
    for txAnt = 1 : this.numberOfTxAntennas
       
       % add signal in all delayed paths
       for path = 1 : this.numberOfPaths
           pathGain = zeros( nSamples, 1 );           
           
           % add random sinusoids to generate Rayleigh fading
           for sinusoid = 1 : this.numberOfSinusoids
               phi = this.phi( path, sinusoid, rxAnt, txAnt );
               theta = this.theta( path, sinusoid, rxAnt, txAnt );
               alpha = ( 2*pi * sinusoid + theta )/ this.numberOfSinusoids;
              
               pathGainR = cos( 2*pi * dopplerFreq  *time * cos(alpha)+ phi );
               pathGainI = sin( 2*pi * dopplerFreq * time * cos(alpha)+ phi );
               pathGain = pathGain + pathGainR + 1i * pathGainI;
               
           end % for sinusoid
           pathGain = pathGain * normFactor;
           
           % add LOS component
           losComponent = exp( 1i* ( 2*pi * dopplerFreq * ...
                               cos(this.losTheta( path )) * time + ...
                               this.losPhi( path ) ) );
           losComponent = losComponent * this.losGain( path );
           pathGain = losComponent + pathGain * this.nonLosGain( path );
           
           % adjust power according do power delay profile
           pathGain = pathGain * sqrt( this.powerDelayProfile( path ));
           
           % filter path gains
           impulseResponse( :, :, rxAnt, txAnt ) = ...
               impulseResponse( :, :, rxAnt, txAnt ) + ...
               pathGain * this.filter( path, : ) ;                
           
       end % for path
    end % for txAnt
end % for rxAnt
       

% add antenna correlation to impulse response
% include antenna correlation
if ~isdiag( this.precodingMatrix ) || ~isdiag( this.postcodingMatrix )
    for instant = 1 : size( impulseResponse, 1 )
        for delay = 0 : this.maxDelaySamples
            H = impulseResponse( instant, delay + 1, :, : );
            H = squeeze( H );
            H = this.postcodingMatrix * H * this.precodingMatrix;
            impulseResponse( instant, delay + 1, :, : ) = H;
        end
    end
end

end
