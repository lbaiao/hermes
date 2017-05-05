function maxNumOfHarqProcess = getHarqProcess( LTE )
%GETHARQPROCESS returns the maximum number of HARQ Process for LTE.
%  This scripts loads a LookUp Table for the HARQ Max. Number of Process.
%  for LTE Downlink OFDMA
%  See STANDARD 3GPP TS 36.213-v12.5.0
%
%  Syntax: maxNumOfHarqProcess = getHarqProcess( LTE )
%
%  Inputs:
%      LTE < struct > - LTE Parameters such as:
%           .DUPLEX_MODE
%           .SUBFRAMES_DIRECTION
%
%  Outputs:
%     maxNumOfHarqProcess - Max. Number of HARQ Process.
%
%   Author: Rafhael Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%       v2.0 14 Jul 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

switch LTE.DUPLEX_MODE
    case enum.modem.lte.DuplexMode.FDD
        maxNumOfHarqProcess = 8;
        
    case enum.modem.lte.DuplexMode.TDD
        
        switch LTE.SUBFRAMES_DIRECTION
            case enum.modem.lte.SubframesDirection.CONFIG_0
                maxNumOfHarqProcess = 4;
            case enum.modem.lte.SubframesDirection.CONFIG_1
                maxNumOfHarqProcess = 7;
            case enum.modem.lte.SubframesDirection.CONFIG_2
                maxNumOfHarqProcess = 10;
            case enum.modem.lte.SubframesDirection.CONFIG_3
                maxNumOfHarqProcess = 9;
            case enum.modem.lte.SubframesDirection.CONFIG_4
                maxNumOfHarqProcess = 12;
            case enum.modem.lte.SubframesDirection.CONFIG_5
                maxNumOfHarqProcess = 15;
            case enum.modem.lte.SubframesDirection.CONFIG_6
                maxNumOfHarqProcess = 6;
        end
end


            