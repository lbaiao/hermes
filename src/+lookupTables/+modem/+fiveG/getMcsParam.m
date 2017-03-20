function [ modulationOrder , codeRate] = getMcsParam( mcsIndex, codeType )
%GETMCSPARAM returns the modulation and code rate based on MCS Index 
%
%  The values defined in this table were created by Hermes Users. No MCS is
%  defined for 5G Simulations yet. 
%
%  Syntax:    
%       [ bitsPerSymbol codeRate] = getMcsParam( mcsIndex, codeType )
%
%  Inputs:
%      mcsIndex <integer> - modulation and coding scheme index, from 0 to
%      12.
%      codeType < enum.modem.codeType> - TURBO, CONVOLUTIONAL or NONE
%
%  Output:
%      modulationOrder < integer > - Number of bits per symbol
%      codeRate < double >- Number of coded bits per OFDM symbol
%
%   Author: Rafhael Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org
%   History:
%       v2.0 07 Jul 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


switch codeType
    case enum.modem.CodeType.NONE
        if mcsIndex > 4
            error('invalid MCS for the selected Code Type');
        end
        codeRate = 1;
        modulationTable = [ 2 , 4 , 16 , 64 , 256 ];
        modulationOrder = modulationTable (  mcsIndex + 1 ); 

    case enum.modem.CodeType.CONVOLUTIONAL
        if mcsIndex > 9
            error('invalid MCS for the selected Code Type');
        end
        codeRateTable = [ 1/2 , 1/2 , 3/4 , ...
                          1/2 , 3/4 , 2/3 , ...
                          3/4 , 5/6 , 3/4 , ...
                          5/6 ];
        modulationTable = [ 2 , 4 , 4 , ...
                            16 , 16 , 64 , ...
                            64 , 64 , 256 , ...
                            256 ];
        %Define Outputs:                
        codeRate = codeRateTable( mcsIndex + 1 );
        modulationOrder = modulationTable ( mcsIndex + 1 );

    case enum.modem.CodeType.TURBO
        if mcsIndex > 16
            error('invalid MCS for the selected Code Type');
        end
        codeRateTable = [ 1/3 , 1/2 , 1/3 , ...
                          2/5 , 1/2 , 2/3 , ...
                          3/4 , 2/5 , 1/2 , ...
                          2/3 , 3/4 , 2/3 , ...
                          3/4 , 5/6 , 2/3 , ...
                          3/4 , 5/6];
        modulationTable = [ 2 , 2 , 4 , ...
                            4 , 4 , 4 , ...
                            4 , 16 , 16 , ...
                            16 , 16 , 64 , ...
                            64 , 64 , 256 , ...
                            256 , 256 ];
        %Define Outputs:                
        codeRate = codeRateTable( mcsIndex + 1 );
        modulationOrder = modulationTable ( mcsIndex + 1 );
end

