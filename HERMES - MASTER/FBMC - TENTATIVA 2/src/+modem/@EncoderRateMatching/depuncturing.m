function depuncturedArray =  depuncturing ( this, receivedArray) 
%EncoderRateMatching.depuncturing applies the depuncturing in the encoded array.
%   Further details are given on the class header
%
%   Author: Rafhael Amorim (RA)
%   Work Adress: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 30 June 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if this.puncturePattern == 1 % If there is no puncturing, no action is needed
    depuncturedArray = receivedArray;    
    return
end

depuncturedArray = zeros( size( this.punctureVector ) );

% Performs the depuncture.
depuncturedArray( this.punctureVector ) = receivedArray;
end