classdef Type
%TYPE class defines enum for SNR type enumerated constants.
%
%   Read-Only Public Properties:
%      EBNO - energy per bit to noise density
%      EBNO_EFFECTIVE - effective energy per bit to noise density (control symbols are
%             also considered in Eb calculation
%      SN - signal to noise ratio
%      CNO - carrier to noise density
%      CI - carrier to interference
%      ESNO - energy per symbol to noise density
%
%   Author: Erika Portela Lopes de Almeida (EA)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org.br
%   History:
%       v1.0 03 Mar 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration

        EBNO;
        EBNO_EFFECTIVE;
        SN;
        CNO;
        CI;
        ESNO;

    end

end
