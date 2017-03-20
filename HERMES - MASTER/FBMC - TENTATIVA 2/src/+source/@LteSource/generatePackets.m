function packets = generatePackets( this, numberOfSymbols, ...
                                          modulationOrder, ...
                                          codeRate )
% LTESOURCE.GENERATEPACKETS method generates transmission packets.
%   Outputs a cell of arrays (packets) of random generated bits, used for
%   LTE.
%
%   Detailed description is in class header.
%
%   Author: Artur Rodrigues (AR), Rafhael Medeiros de Amorim (RMA),
%           Fadhil Firyaguna (FF)
%   Work Address: INDT Brasilia
%   E-mail: < artur.rodrigues, rafhael.amorim >@indt.org.br,
%              < fadhil.firyaguna > @indt.org
%   History:
%       v1.0 23 Mar 2015 - created
%       v2.0 02 Jun 2015 - Source.generatePackets used to create
%           LteSource.generatePackets (RMA)
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

	% Check if the Frame is enabled for transmission ( TDD ) and assign the
	% number of Packets Accordingly:
    if numberOfSymbols > 0
        % # of Packets:
        this.numberOfPackets = this.maxNumberOfPackets;
        % Packet Sizes:
        this.packetSize_bits = ones( this.numberOfPackets, 1 ) .* ...
                           this.targetPacketSize_bits;
    else
        this.numberOfPackets = 0;
        this.packetSize_bits = [];
    end

                    
   packets = cell( this.numberOfPackets, 1 );
    
    for cnt = 1 : this.numberOfPackets
		
		packets{cnt} = this.rnd.randi( [0,1], ...
                                        this.packetSize_bits(cnt),1 );
		
    end
    this.txPackets = packets;
	
end