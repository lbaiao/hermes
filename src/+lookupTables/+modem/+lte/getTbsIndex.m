function tbsIndex = getTbsIndex( mcs, enable256qam )
%GETTBSINDEX returns the transport block size index of a given LTE MCS
%  This scripts loads a LookUp Table for the modulation order and transport
%  block size (TBS) index according to the MCS.
%  See STANDARD 3GPP TS 36.213-v12.5.0:
%           Tables 7.1.7.1-1 and 7.1.7.1-1A - Pages 59 - 60
%
%  Syntax: tbsIndex = getModulationOrder( MCS, enable256qam )
%
%  Inputs:
%     MCS <integer> - modulation and coding scheme, from 0 to 28 (or 0 to 27
%        if 256-QAM is enabled)
%     enable256qam <boolean> - true if 256-QAM is enabled.
%  Outputs:
%     tbsIndex - transport block size index ( further details in 
%              3GPP TS 36.213-v12.5.0 )
%
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 01 Apr 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% modulationOrder( MCS + 1 ) and tbsIndex( MCS + 1 ) indicate the 
% modulation order and TBS index for MCS

% MCS table when 256-QAM is not supported
% 0 <= MCS <= 28
transportBlockSizeIndex{1} = [  0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  9, 10, 11, 12, 13, ...
                14, 15, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 ];
transportBlockSizeIndex{2} = [  0,  2,  4,  6,  8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ...
                20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33 ]; 

    
if enable256qam   
    if mcs < 0 || mcs > 27
        error('invalid MCS');
    end    
    tbsIndex = transportBlockSizeIndex{2}(mcs + 1);
else
    if mcs < 0 || mcs > 28
        error('invalid MCS');
    end    
    tbsIndex = transportBlockSizeIndex{1}(mcs + 1);
end


end
            