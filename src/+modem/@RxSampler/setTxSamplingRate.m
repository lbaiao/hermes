function setTxSamplingRate (this, txSamplingRate, txCenterFreq )
%RXSAMPLER.SETTXSAMPLINGRATE sets sampling rate of transmitters
%   Detailed explanation in class header
%
%   Author: Rafhael Amorim (RA), Renato Barbosa Abreu (RBA)
%   Work Address: INDT Brasília/Manaus
%   E-mail: rafhael.amorim@indt.org.br, renato.abreu@indt.org.br
%   History:
%       v1.0 23 Mar 2015 (RA) - created
%       v2.0 29 May 2015 (RBA) - call compute factors for resampling
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.



this.txSamplingRate = txSamplingRate;
this.txCenterFreq = txCenterFreq;

% Compute interpolation and decimation factors and filters for resampling
this.computeFactors();

end

