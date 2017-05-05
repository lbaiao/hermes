function [ puncturePattern ] = getTurboPuncturePattern( desiredCodeRate )
%getTurboPuncturePattern loads the puncture pattern for turbo encoders
%
%  The puncture patterns were built following the rules presented in:
%       3GPP 3GPP/TSG/RAN/WG1 meeting 4: TSGR1#4(99) 338
%       Title: Puncturing Algorithm for Turbo Code
%       Avilable in: 
%       ftp://www.3gpp.org/tsg_ran/WG1_RL1/TSGR1_04/Docs/Pdfs/R1-99338.PDF
%     
%  Syntax:    
%       [ puncturePattern ] = getTurboPuncturePattern( desiredCodeRate )
%
%  Inputs:
%      desiredCodeRate < double > - expected code rate after puncturing.
%
%  Output:
%      puncturePattern < KxM Double > - Contains the atomic part for the
%           puncture pattern. K is the number of input bits considered 
%           for the atomic part and M is the original number of encoder 
%           outputs, for Turbo Encoders, M=3. 
%           Example: For a 3/4 rate, K=6 and M = 3.
%           In the puncture vector, '1's represent the bits to be kept in
%           the message, while '0's represent bits to be punctured.
%
%   Author: Rafhael Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 01 Jul 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

switch desiredCodeRate
    case 1/3
        puncturePattern = 1;
    case 2/5
        puncturePattern = [ 1 1 1 1; ...
                            1 1 1 0; ...
                            1 0 1 1];
     case 1/2
        puncturePattern = [ 1 1; ... 
                            1 0; ...
                            0 1 ];
    case 2/3
        puncturePattern = [ 1 1 1 1; ...
                            1 0 0 0; ...
                            0 0 0 1];
    case 3/4
        puncturePattern = [ 1 1 1 1 1 1; ...
                            1 0 0 0 0 0; ...
                            0 0 0 1 0 0];
    case 5/6
        puncturePattern = [ 1 1 1 1 1 1 1 1 1 1; ...
                            1 0 0 0 0 0 0 0 0 0; ...
                            0 0 0 0 0 1 0 0 0 0];
    otherwise
        error('Selected Code Rate is not allowed for the specified encoder');
end