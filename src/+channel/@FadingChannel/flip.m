function flip (this)
%FADINGCHANNEL.FLIP changes transmitting direction of channel
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

this.flip@channel.Channel();

% permute dimensions from receiving and transmitting antennas
this.phi = permute( this.phi, [1,2,3,4]);
this.theta = permute( this.theta, [1,2,4,3]);

auxMatrix = this.precodingMatrix;
this.precodingMatrix = this.postcodingMatrix;
this.postcodingMatrix = auxMatrix;


end