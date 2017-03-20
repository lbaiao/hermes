function [ out, ...
           impulseResponse, ...
           channelSamplingInstants ] = propagate ( this, in, t0 )
%FADINGCHANNEL.PROPAGATE sends a signal through a multipath channel
%   Usage description can be found in class header.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <andre.barreto>@indt.org.br
%   History:
%       v1.0 20 Feb 2015 (ANB) - created
%       v2.0 01 Jul 2015 (ANB) - impulse response interpolation added
%                                interframe interference added
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


if ( size( in, 2 ) ~= this.numberOfTxAntennas )
    error( 'input vector has wrong number of antennas' );
end

% calculate number of samples and time reference
% output may have more samples on account of delayed paths
nSamplesIn = size( in, 1 );
nSamplesPrev = size( this.previousFrame, 1 );
nSamplesOut = nSamplesPrev + nSamplesIn + this.maxDelay_samples;
out = zeros( nSamplesOut, this.numberOfRxAntennas );

in = [ this.previousFrame; in ]; 

% initialize impulse response
impulseResponse = this.update( t0 - nSamplesPrev / this.samplingRate, ...
                               nSamplesIn + nSamplesPrev );

% transmit antenna correlation
in = in * this.precodingMatrix;

% Add paths to form received signal
for rxAnt = 1 : this.numberOfRxAntennas
    outAnt = zeros( nSamplesOut, 1 );
    
    % add signal coming from all transmit antennas
    for txAnt = 1 : this.numberOfTxAntennas
       inAnt = in( :, txAnt );
       
       % add signal in all delayed paths
       for delay = 0 : this.maxDelay_samples
           padding = this.maxDelay_samples - delay;

           % add faded path to received signal
           outPath = [ zeros(delay, 1); ...
                       inAnt .* impulseResponse( :, delay + 1, rxAnt, txAnt ); ...
                       zeros(padding, 1) ];
           outAnt = outAnt + outPath;           
       end
    end
    
    out( :, rxAnt ) = outAnt;
    
end


switch this.interFrameInterf
    case enum.channel.InterFrameInterference.TAIL_BITING
        
        out( 1:this.maxDelay_samples, : ) = out( 1:this.maxDelay_samples, : ) + ...
                                  out( nSamplesIn + 1 : end, : ); 
                              
    case enum.channel.InterFrameInterference.ACTUAL
        
        out = out( nSamplesPrev + 1 : end, :, : , :);
        this.previousFrame = out( end - this.maxDelay_samples + 1 : end, :, :, : );
        
end
        

% downsample impulse response
frameDuration = nSamplesIn / this.samplingRate;
channelSamplingInstants = 0 : this.impulseResponseUpdatePeriod : ...
                          frameDuration;
channelSamplingInstants = nSamplesPrev + 1 + ...
                          round ( channelSamplingInstants * ...
                                  this.samplingRate );
channelSamplingInstants( channelSamplingInstants > nSamplesIn ) = [];                              

impulseResponse = impulseResponse(channelSamplingInstants, :, :, : );

% receive antenna correlation
out = ( out * this.postcodingMatrix  );

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

% update timestamp
this.timeStamp = t0 + frameDuration;


channelSamplingInstants = channelSamplingInstants / this.samplingRate + t0;
end
