%% Test 1: check class constructor

disp('Interleaver: Executing TEST 1');

WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW20;
WIFI.MCS = 0;
WIFI.NSS = 1;

wifiInterleaver = modem.WifiInterleaver(WIFI);

assert(isa(wifiInterleaver, 'modem.WifiInterleaver' ));

%% Test 2: Interleave and deinterleave
% Interleave and de-interleave the input bit stream and check that they
% match.

disp('Interleaver: Executing TEST 2');

WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW20;
WIFI.MCS = 0;
WIFI.NSS = 1;

for mcs = 0:9
    
    % Invalid MCS combination, so skip it.
    if ( WIFI.CH_BANDWIDTH == enum.modem.wifi.ChannelBandwidth.CBW20 && ...
        mcs == 9 && WIFI.NSS == 1 )
        continue;
    end

    msg = sprintf('Executing test with MCS = %i', mcs);
    disp(msg);
    WIFI.MCS = mcs;

    wifiInterleaver = modem.WifiInterleaver(WIFI);

    [ ~, codedBitsPerSymbol, ~ ] = ...
        lookupTables.modem.wifi.getMCSParam(WIFI.MCS, WIFI.CH_BANDWIDTH, 1);
    inputSize = codedBitsPerSymbol * 20;
    inputSequence = randi([0, 1], [inputSize, 1]);

    interleavedSequence = wifiInterleaver.interleave(inputSequence);
    deinterleavedSequence = wifiInterleaver.deinterleave(interleavedSequence);

    assert(all(inputSequence == deinterleavedSequence));
end

%% Test 3: Compare against the standard
% Load the interleaver tables from the IEEE 802.11ac reference waveform
% generator and compare the interleaved bit streams.
% Test for 20, 40, and 80MHz channel bandwidths for all MCSs.

disp('Interleaver: Executing TEST 3');

WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW20;
WIFI.MCS = 0;
WIFI.NSS = 1;

% Load reference interleaver tables
load Interleave_matrices_ac; 

packetTypeNames      = {'HT20M', 'HT40M', 'HT80M'};
modTypes  = {'BPSK', 'QPSK', '', '16QAM', '', '64QAM', '', '256QAM'};

for packetType = 1:3
    
    switch packetTypeNames{packetType}
        case 'HT20M'
            WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW20;
        case 'HT40M'
            WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW40;
        case 'HT80M'
            WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW80;
        otherwise
            error('WiFiInterleaverTest: invalid packetType');
    end

    for mcs = 0:9
        
        if ( WIFI.CH_BANDWIDTH == enum.modem.wifi.ChannelBandwidth.CBW20 && ...
            mcs == 9 && WIFI.NSS == 1 )
            continue;
        end

        msg = sprintf('Executing test with MCS = %i and packetType = %s', ...
            mcs, packetTypeNames{packetType});
        disp(msg);
        
        WIFI.MCS = mcs;

        wifiInterleaver = modem.WifiInterleaver(WIFI);

        [ bitsPerSubCarrier, codedBitsPerSymbol, ~ ] = ...
            lookupTables.modem.wifi.getMCSParam(WIFI.MCS, WIFI.CH_BANDWIDTH, 1);
        inputSize = codedBitsPerSymbol * 20;
        inputSequence = randi([0, 1], [inputSize, 1]);

        interleavedSequence = wifiInterleaver.interleave(inputSequence);

        mname = sprintf('IMAT.Interleave_%s_%s_SS%d', packetTypeNames{packetType}, ...
            modTypes{bitsPerSubCarrier}, 0);

        eval(sprintf('interleaver_table = %s;', mname));

        k = 0:(codedBitsPerSymbol - 1);
        k = k + 1;
        inputLength = length(inputSequence);
        inputBitStream = reshape(inputSequence, codedBitsPerSymbol, ...
        inputLength / codedBitsPerSymbol);
        inputBitStream(interleaver_table, :) = inputBitStream(k, :);
        refSequence = reshape(inputBitStream, inputLength, 1);

        assert(all( refSequence == interleavedSequence ));
    end
end
