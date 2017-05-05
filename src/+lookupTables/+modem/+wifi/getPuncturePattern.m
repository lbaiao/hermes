function [ puncturePattern ] = getPuncturePattern( desiredCodeRate )
%getPuncturePattern loads the lookup table for the encoder puncture pattern 
%
%  See STANDARD IEEE Std 802.11ac:
%     * Sub-clause 18, Figure 18-9: Example of the bit-stealing and bit
%     and bit-insertion procedure (r = 3/4, 2/3).
%     * Sub-clause 20, Figure 20-11: Puncturing at rate 5/6.
%
%  Syntax:    
%       [ puncturePattern ] = getPuncturePattern( desiredCodeRate )
%
%  Inputs:
%      desiredCodeRate < double > - expected code rate after puncturing.
%
%  Output:
%      puncturePattern < KxM Double > - Contains the atomic part for the
%           puncture pattern. K is the number of input bits and M is
%           the original number of encoder outputs, for WiFi, M=2. 
%           Example: For a 3/4 rate, K=3 and M = 2.
%           In the puncture vector, '1's represent the bits to be kept in
%           the message, while '0's represent bits to be punctured.
%
%   Author: Rafhael Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 30 Jun 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

switch desiredCodeRate
    case 1/2
        puncturePattern = 1;
    case 3/4
        puncturePattern = [ 1 1 0; ... 
                            1 0 1] ;
    case 2/3
        puncturePattern = [ 1 1; ...
                            1 0];
    case 5/6
        puncturePattern = [ 1 1 0 1 0; ...
                            1 0 1 0 1 ];
    otherwise
        error('Selected Code Rate is not allowed for the specified encoder');
end