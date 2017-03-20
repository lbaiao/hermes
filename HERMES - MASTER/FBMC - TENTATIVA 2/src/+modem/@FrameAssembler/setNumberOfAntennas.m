function setNumberOfAntennas( this, numberOfAntennas )
%FRAMEASSEMBLER.SETNUMBEROFANTENNAS sets the antenna attribute
%   Description at class header
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%   	v1.0 04 Mar 2015 - created
%     
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


this.numberOfAntennas = numberOfAntennas;
this.frameMapDesign();
        
        
end