function numberOfBits = getNumberOfBits ( this )
%SOURCE.GETNUMBEROFBITS calculates number of bits in all packets.
%   Detailed description is in class header.
%
%   Author: André Noll Barreto (AB)
%   Work Address: INDT Brasilia
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 07 Apr 2015 - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

numberOfBits = 0;
for packIndex = 1 : this.numberOfPackets
    numberOfBits = numberOfBits + length( this.txPackets{ packIndex } );
end

end