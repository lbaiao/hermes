function bits = receiveFrame( this, rxSignal, channel )
%MODEM.RECEIVEFRAME receives and demodulates a signal frame
%   Description at class header
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 01 Apr 2015 - (AB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if ~isempty( rxSignal )
    [ equalizedSignal, ...
      noiseVariance ] = this.innerTransceiver.demodulate( rxSignal, ...
        channel.impulseResponse, ...
        channel.samplingInstants );

    [ dataSymbols, ...
      noiseVariance ] = this.frameAssembler.readFrame( equalizedSignal, ...
                                                       noiseVariance );
        
    % >>>>>>>>>>>>>>>> TO BE REMOVED 
    dataSymbols = transpose( dataSymbols );
    
    scrambledLlr = this.mapper.calculateLlr ( dataSymbols, noiseVariance );

    
    codedBits = this.scrambler.descramble( scrambledLlr );
    bits = this.channelCode.decode( codedBits );
    
else
    bits = [];
end
end
