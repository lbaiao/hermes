function transmittedSequence = scramble( this, inputSequence )
%WIFISCRAMBLER.SCRAMBLE scrambles input data with a random sequence
%   Further details are given on the class header
%
%   Author: Sergio Abreu (SA)
%   Work Adress: INDT Manaus
%   E-mail: sergio.abreu@indt.org.br
%   History:
%       v2.0 23 June 2015 (SA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.



transmittedSequence  = zeros( size(inputSequence ) );
this.shiftRegister = ( de2bi( this.initialRegisterState, 7, 'left-msb' ) );

% TODO: could the scrambling sequence be generated previously and xor-ing
% with the sequence be done in a single vectorized step...
% implement the LFSR for the polynomial: S(x) = x^7 + x^4 + 1
for p = 1: length( inputSequence )
    tmp = bitxor( this.shiftRegister( 1 ),this.shiftRegister( 4 ) );
    transmittedSequence( p ) = bitxor( tmp,inputSequence ( p ) );
    this.shiftRegister ( 1:end-1 ) = this.shiftRegister ( 2:end );
    this.shiftRegister( 7 )= tmp;
end

end

