function modulationOrder = getModulationOrder( mcs, enable256qam )
%GETMODULATIONORDER returns the modulation order of a given LTE MCS
%  This scripts loads a LookUp Table for the modulation order and transport
%  block size (TBS) index according to the MCS.
%  See STANDARD 3GPP TS 36.213-v12.5.0:
%           Tables 7.1.7.1-1 and 7.1.7.1-1A - Pages 59 - 60
%
%  Syntax:    modulationOrder = getModulationOrder( MCS, enable256qam )
%
%  Inputs:
%      MCS <integer> - modulation and coding scheme, from 0 to 28 (or 0 to 27
%         if 256-QAM is enabled)
%      enable256qam <boolean> - true if 256-QAM is enabled.
%
%  Output:
%      modulationOrder < integer > - the number of constellation points,
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
modulationOrderTable{1} = [ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, ...
                            4, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 ];
                        
% MCS table when 256-QAM is supported
% 0 <= MCS <= 27                        
modulationOrderTable{2} = [ 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6, 6, ...
                            6, 6, 6, 6, 8, 8, 8, 8, 8, 8, 8, 8 ];
if enable256qam  
    if mcs < 0 || mcs > 27
        error('invalid MCS');
    end

    bitsPerSymbol = modulationOrderTable{2}(mcs + 1);
else
    if mcs < 0 || mcs > 28
        error('invalid MCS');
    end
    bitsPerSymbol = modulationOrderTable{1}(mcs + 1);
end

modulationOrder = 2^bitsPerSymbol;

end
            