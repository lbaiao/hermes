function setInterleaver( this, interleaver, deinterleaver )
%TURBOCODE.SETINTERLEAVER Sets the Interleaver for Turbo Encoder/Decoder
%   Detailed description can be found in class header.
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 03 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

this.interleavers = interleaver;

if ~exist('deinterleaver', 'var' ) || isempty( deinterleaver )
    [~ , this.deinterleavers ] = sort( this.interleavers, 'ascend');
else
    this.deinterleavers = deinterleaver;
end


