classdef LlrMethod
%LLRMETHOD defines a ENUM list for how to calculate LLR.
%
%   Read-Only Public Properties
%      IDEAL_AWGN - calculates the true LLR for an AWGN channel
%                   (considering all constellation points)
%      NEAREST_AWGN - calculate LLR based on the nearest constellation
%                     points only for an AWGN channel
%      LINEAR_APPROXIMATION - calculate LLR based on a piece-wise linear 
%                             aproximation for a known constellation
%
%   Author: Lilian Coelho de Freitas (LCF), André Noll Barreto
%   Work Address: INDT Manaus / Brasília
%   E-mail: lilian.freitas@indt.org.br, andre.noll@indt.org
%   History:
%       v2.0 19 May 2015 (LCF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration

        IDEAL_AWGN
        NEAREST_AWGN
        LINEAR_APPROXIMATION
        
    end
end
