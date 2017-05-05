function [ out, impulseResponse, t ] = propagate (this, in, t0)
%CHANNEL.PROPAGATE returns the channel response.
%   Detailed description can be found in class header.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.barreto@indt.org.br
%   History:
%       v1.0 20 Feb 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

nTx = size( in, 2 );
if ( nTx ~= this.numberOfTxAntennas )
    error( 'input vector has wrong number of antennas' );
end

nSamples = size( in, 1 );

this.timeStamp = t0 + nSamples / this.samplingRate;
impulseResponse0 = eye( this.numberOfRxAntennas, this.numberOfTxAntennas );
out = ( in * impulseResponse0.' );

frameDuration = nSamples / this.samplingRate;
t = t0 + ( 0 : this.impulseResponseUpdatePeriod : frameDuration );
numberOfInstants = length( t );

impulseResponse = zeros( numberOfInstants, 1, this.numberOfRxAntennas, ...
                                              this.numberOfTxAntennas );

for instant = 1:numberOfInstants
    impulseResponse( instant, 1, :, : ) = impulseResponse0;
end

end

