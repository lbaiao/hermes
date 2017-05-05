function packets = generatePackets( this, numberOfSymbols, ...
                                          modulationOrder, ...
                                          codeRate )
% SOURCE.GENERATEPACKETS method generates transmission packets.
%   Outputs a cell of arrays (packets) of random generated bits.
%   Detailed description is in class header.
%
%   Author: Artur Rodrigues (AR), Rafhael Medeiros de Amorim (RMA),
%           Fadhil Firyaguna (FF)
%   Work Address: INDT Brasilia
%   E-mail: < artur.rodrigues, rafhael.amorim >@indt.org.br,
%           fadhil.firyaguna@indt.org
%   History:
%       v1.0 23 Mar 2015 - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

	% Bits transmitted per Mapped Symbol:
	bitsPerSymbol = log2( modulationOrder );
	% Total Number of Transmitted Bits:
	numberOfBits = floor( numberOfSymbols * bitsPerSymbol * codeRate );
	% Number of Packets:
	this.numberOfPackets = floor ( numberOfBits / ...
                                   ( this.targetPacketSize_bits ) );
    this.packetSize_bits = ones( this.numberOfPackets, 1 ) .* ...
                           this.targetPacketSize_bits;
                    
   packets = cell( this.numberOfPackets, 1 );
    
    for cnt = 1 : this.numberOfPackets
		
		packets{cnt} = this.rnd.randi( [0,1], ...
                                        this.packetSize_bits(cnt),1 );
		
    end
    this.txPackets = packets;
	
end