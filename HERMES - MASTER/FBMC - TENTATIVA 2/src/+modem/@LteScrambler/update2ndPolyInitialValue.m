function update2ndPolyInitialValue( this, subframeNumber )
%LTESCRAMBLER.UPDATE2NDPOLYINITIALVALUE updates 2nd polynomium value
% Further explanation may be found in the class definition file.
%
%   Author: Erika Almeida (EA)
%   Work Adress: INDT Brasilia
%   E-mail: erika.almeida@indt.org.br
%   History:
%       v2.0 07 May 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% hard coded parameters
codewordNumber = 0;
NcellID = 10;
RNTI = 100;

% initialization of the 2nd polynom according to TR 36.211
c_init = RNTI * ( 2^14 ) +  codewordNumber * ( 2^13 ) + ...
    floor( subframeNumber/2 ) * ( 2^9 ) + NcellID;

this.secondPolyInitialConditions = de2bi( c_init, 31, 'right-msb')';
