function resetScenario( this )
%SCNERARIO.RESETSCENARIO Resets Scenario Parameters for a new Drop Loop
%   Description at class header
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History: 
%   	v2.0 5 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

numberOfModems = length ( this.modems );

%Reset All Frame Counts:
for modemCount = 1 : numberOfModems

    this.modems { modemCount }.frameAssembler.resetFrame();

end





