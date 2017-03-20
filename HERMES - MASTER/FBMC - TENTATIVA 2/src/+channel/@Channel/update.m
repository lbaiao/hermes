function impulseResponse = update (this, time, nSamples, samplingRate)
%CHANNEL.UPDATE updtates the channel and returns the impulse response.
%   Detailed description can be found in class header.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: 
%   History:
%       v1.0 20 Feb 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if min(time) < this.timeStamp
    error('cannot update to time before current time stamp') 
end

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

this.timeStamp = max( time );
impulseResponse = zeros( nSamples, 1, this.numberOfRxAntennas, ...
                                              this.numberOfTxAntennas );

for instant = 1:nSamples
    impulseResponse( instant, 1, :, : ) = eye( this.numberOfRxAntennas, ...
                                              this.numberOfTxAntennas );
end

end