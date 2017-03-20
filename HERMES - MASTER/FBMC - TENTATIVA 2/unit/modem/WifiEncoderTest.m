%WIFIENCODERTEST script tests the WifiEncoder class
% This function test the instantiation of a WifiEncoder object and its
% methods
%
%   Syntax: WifiEncoderTest
%
%   Author: Bruno Faria
%   Work Address: INDT Brasília
%   E-mail: bruno.faria@indt.org.br
%   History:
%       v2.0 03 Jul 2015 (BF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check class constructor
wifiSimulationSettings;

WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW20;
WIFI.MCS = 0;
WIFI.NSS = 1;

wifiEncoder = modem.WifiEncoder( WIFI );

assert( isa ( wifiEncoder, 'modem.WifiEncoder' ) );

%% Test 2: Check encoding and decoding methods

WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW20;
WIFI.MCS = 0;
WIFI.NSS = 1;

numOFDMSymbols = 10;

for mcs = 0:8 % Excluding MCS = 9 because it is invalid for BW = 20MHz and NSS = 1

    [ ~, codedBitsPerSymbol, ~, codeRate ] = ...
        lookupTables.modem.wifi.getMCSParam(mcs, WIFI.CH_BANDWIDTH, WIFI.NSS);

    numDataBits = codedBitsPerSymbol * codeRate * numOFDMSymbols;
    inputDataBits = randi( [ 0 , 1 ], 1, numDataBits );

    wifiEncoder = modem.WifiEncoder( WIFI );

    encodedArray = wifiEncoder.encode( inputDataBits );

    % Dummy LLR estimation
    llrVector = sign( encodedArray * 2 - 1 );

    decodedArray = wifiEncoder.decode( llrVector );

    assert( all( inputDataBits == decodedArray )  );

end