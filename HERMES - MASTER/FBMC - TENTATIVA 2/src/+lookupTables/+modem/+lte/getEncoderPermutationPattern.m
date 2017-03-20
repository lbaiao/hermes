function permutationPattern = getEncoderPermutationPattern(  )
%GETENCODERPERMUTATIONPATTERN returns Table 5.1.4-1 3GPP TS 36.212-v12.3.0.
%  This scripts loads a LookUp Table for the column permutation indexes 
%  for bit selection and interleaving used in LTE Rate Matching
%
%  Syntax:   permutationPattern = getEncoderPermutationPattern(  )
%
%
%   Author: Rafhael Medeiros de Amorim (RMA)
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 19 May 2015 (RMA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.



permutationPattern = [ 0, 16, 8 , 24, 4, 20, 12, 28, 2, 18, 10, 26, 6 , 22, 14, 30 ...
                       1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7 , 23, 15, 31 ];
            