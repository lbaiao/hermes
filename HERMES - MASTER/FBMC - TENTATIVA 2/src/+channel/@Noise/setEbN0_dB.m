function setEbN0_dB( this, ebn0_dB )
%NOISE.SETEBN0_DB
%   Detailed description can be found in class header.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <andre.barreto>@indt.org.br
%   History:
%       v1.0 10 Feb 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


this.EbN0_dB = ebn0_dB;
this.EbN0 = 10^(ebn0_dB/10);

end
