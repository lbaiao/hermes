function receivedSequence = descramble( this, inputSequence )
%SCRAMBLER.DESCRAMBLE descrambles input data with a random sequence
%   Further details are given on the class header
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

% descramble the sequence
auxSequence = this.scramblingSequences * (-2) + 1;

receivedSequence = auxSequence .* inputSequence;

end