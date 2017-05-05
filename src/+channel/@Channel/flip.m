function flip (this)
%CHANNEL.FLIP changes the transmitting direction of the channel
%   Detailed description can be found in class header.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <andre.barreto>@indt.org.br
%   History:
%       v1.0 20 Feb 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


auxAntennas = this.txAntennas;
nAntennas = this.numberOfTxAntennas;

this.txAntennas = this.rxAntennas;
this.numberOfTxAntennas = this.numberOfRxAntennas;
this.rxAntennas = auxAntennas;
this.numberOfRxAntennas = nAntennas;


end