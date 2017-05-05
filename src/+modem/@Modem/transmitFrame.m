function frame = transmitFrame( this )
%MODEM.TRANSMITFRAME transmits a signal frame
%   Description at class header
%
%   Author: Andre Noll Barreto (AB), Erika Almeida (EA), Rafhael Amorim
%   (RA)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org, erika.almeida@indt.org.br,
%   rafhael.amorim@indt.org.br
%   History:
%       v1.0 01 Apr 2015 - (AB) created
%       v2.0 15 May 2015 - (EA)  Scrambler Included       
%       v2.0 19 Jun 2015 - (RA) Encoder Included
%       
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% generate data packets
numberOfSymbols = this.frameAssembler.getAvailableDataSymbols() ...
                    * this.spatialCoder.spatialCodeRate; %ALTERACAO REALIZADA


    modulationOrder = this.mapper.modulationOrder;
    codeRate = this.channelCode.codeRate;
    
    dataPackets = this.source.generatePackets( numberOfSymbols, ...
        modulationOrder, ...
        codeRate );
    
    dataBits = this.channelCode.encode ( dataPackets );
           
    scrambledBits = this.scrambler.scramble( dataBits );
    modulationSymbols = this.mapper.map ( scrambledBits );
    
    modulationSymbols = transpose( modulationSymbols );
    
    modulationSymbols = this.spatialCoder.precode( modulationSymbols );
    
    frame = this.frameAssembler.fillFrame( modulationSymbols );
    
    if ~isempty ( frame )
        frame = this.innerTransceiver.modulate( frame );
    end

end
