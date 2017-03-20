function updateRegisterInitialValue( this, newSeed )
% WIFISCRAMBLER.UPDATEREGISTERINITIALVALUE updates the register value
% Further explanation may be found in the class definition file.
%
%   Author: Sergio Abreu (SA)
%   Work Adress: INDT Manaus
%   E-mail: sergio.abreu@indt.org.br
%   History:
%       v2.0 24 June 2015 (SA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


% update the shift register value

% check for error in update state
if ( newSeed == 0 )
    error( 'Initial seed can not be zero' );
end

this.initialRegisterState = newSeed;
this.shiftRegister = de2bi( newSeed, 7,'left-msb' );

end