function [ numBitErrors, ...
           numPacketErrors, ...
           throughput ] = calculateErrors ( this, rxBits )
%SOURCE.CALCULATEERRORS method calculates number errors.
%   Outputs the number of bit errors and the number of packet errors.
%   Detailed description is in class header.
%
%   Author: Fadhil Firyaguna (FF), André Noll Barreto (AB)
%   Work Address: INDT Brasilia
%   E-mail: <fadhil.firyaguna, andre.noll>@indt.org
%   History:
%       v1.0 23 Mar 2015 - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

	numPacketErrors = 0;
	numBitErrors = 0;
	packetPointer = 1;
    throughput = 0;
    
	for cnt = 1 : this.numberOfPackets
		txBits = this.txPackets{ cnt };
        numberOfBits = length( txBits );
		rxPacketBits = rxBits( packetPointer : packetPointer + numberOfBits - 1 );
        packetPointer = packetPointer + numberOfBits;
		nErrors = sum( bsxfun(@xor, txBits, rxPacketBits) );
		numBitErrors = numBitErrors + nErrors;
		if nErrors > 0
			numPacketErrors = numPacketErrors + 1;
        else
            throughput = throughput + numberOfBits;
		end
	end
end