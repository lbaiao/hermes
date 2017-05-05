function frameDir = getFrameDirection( this )
%LTEFRAMEASSEMBLER.GETFRAMEDIRECTION provides next subframe Direction for LTE
%   Description at class header
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%   	v2.0 20 Jul 2015 - created (RA)
%     
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


direction = this.subframesDirection( this.subframeCount );
if direction == 'D' || direction == 'S'
    frameDir = enum.FrameDirection.DOWNLINK;
else
    frameDir = enum.FrameDirection.UPLINK;
end
end