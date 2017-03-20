function [ bitsPerSubCarrier codedBitsPerSymbol numDataSubCarriers codeRate] = ...
    getMCSParam(mcs, channelBandwidth, nss)
%GETMCSPARAM returns the VHT MCS parameters according to the MCS index 
%
%  See STANDARD IEEE Std 802.11ac:
%           Sub-clause 22.5: Parameters for VHT-MCSs
%
%  Syntax:    
%       [ bitsPerSubCarrier codedBitsPerSymbol numDataSubCarriers codeRate] = ...
%                                       getMCSParam(mcs, channelBandwidth, nss)
%
%  Inputs:
%      mcs <integer> - modulation and coding scheme, from 0 to 9.
%      channelBandwidth <enum> - enum.modem.wifi.ChannelBandwith
%      nss <integer> - number os spatial streams
%
%  Output:
%      bitsPerSubCarrier < integer > - Number of bits per Subcarrier per
%      spatial stream
%      codedBitsPerSymbol < integer >- Number of coded bits per OFDM symbol
%      numDataSubCarriers < integer > - Number of data sub-carriers
%      codeRate < integer > - Code rate of the convolutional encoder
%
%   Author: Bruno Faria (BF)
%   Work Address: INDT Brasília
%   E-mail: bruno.faria@indt.org
%   History:
%       v2.0 18 Jun 2015 (BF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if mcs < 0 || mcs > 9
    error('invalid MCS');
    return;
end

% Number of bits per sub-carrier table (modulation order)
bitsPerSubcarrierTable = [1; 2; 2; 4; 4; 6; 6; 6; 8; 8];

% Code rate for each MCS
codeRateTable = [1/2; 1/2; 3/4; 1/2; 3/4; 2/3; 3/4; 5/6; 3/4; 5/6];

codeRate = codeRateTable(mcs + 1);

bitsPerSubCarrier = bitsPerSubcarrierTable(mcs + 1);

switch channelBandwidth
    case enum.modem.wifi.ChannelBandwidth.CBW20
        numDataSubCarriers = 52;
    case enum.modem.wifi.ChannelBandwidth.CBW40
        numDataSubCarriers = 108;
    case enum.modem.wifi.ChannelBandwidth.CBW80
        numDataSubCarriers = 234;
    otherwise
        error('getCodedBitsPerOFDMSymbol: invalid Channel Bandwidth');
end

codedBitsPerSymbol = numDataSubCarriers * bitsPerSubCarrier * nss;

% Some MCS, BW and NSS combinations are invalid in 802.11ac. The number of 
% punctured blocks for each BCC encoder per OFDM symbol must be integer
if rem( ( codedBitsPerSymbol * codeRate ), 1 ) ~= 0
    error('getCodedBitsPerOFDMSymbol: invalid MCS combination');
end


            