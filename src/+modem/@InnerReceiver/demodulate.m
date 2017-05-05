function [ rxSignal, noiseVariance ] = demodulate ( this, receivedSignal, ...
                                                    impulseResponse, ...
                                                    channelSamplingInstants )                     
%INNERRECEIVER.DEMODULATE equalizes, synchronizes and estimates channel.
%   Detailed description can be found in class header.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 26 Mar 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

noiseVariance = this.estimateNoise( );


rxSignal = this.demodulator.demodulate( receivedSignal );

channelInFreq = this.getChannelInFrequency( rxSignal, ...
                                            impulseResponse, ...
                                            channelSamplingInstants );
                                                                          

[ rxSignal, coefficients ] = this.equalize( rxSignal, channelInFreq, ...
                                            noiseVariance );

rxSignal = this.demodulator.despread( rxSignal );

noiseVariance = this.calculateNoiseVariancePerSymbol ( coefficients, ...
                                                       noiseVariance );

end