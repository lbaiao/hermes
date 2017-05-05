function setNumberOfAntennas( this, numberOfTxAntennas, numberOfRxAntennas )
%MIMO.SETNUMBEROFANTENNAS sets the number of antennas
%   Description at class header
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%   	v2.0 14 May 2015 (FF) - created
%     
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if ~isempty( numberOfTxAntennas )
    this.numberOfTxAntennas = numberOfTxAntennas;
    
    if ( this.mimoScheme == enum.modem.MimoScheme.OPEN_LOOP || ...
         this.mimoScheme == enum.modem.MimoScheme.CLOSED_LOOP )
        this.spatialCodeRate = numberOfTxAntennas;
    end
        
end

if ~isempty( numberOfRxAntennas )
    this.numberOfRxAntennas = numberOfRxAntennas;
end
        
end