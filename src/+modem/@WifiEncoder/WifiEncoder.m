classdef WifiEncoder < modem.ChannelCode
% WifiEncoder class implements the 802.11 convolutional encoder/decoder.
%
%   The WifiEncoder object implements the 802.11 block convoltional
%   encoder as defined in 802.11ac standard sub-clauses 18.3.5.6 and
%   22.3.10.5.
%
%   The convolutional encoder generator polynomials are g0 = {133} and g1 =
%   {171} (octal basis) and K = 7.
%
%   The enconded bits are then punctured to match 1/2, 2/3, 3/4 and 5/6 code
%   rates.
%
%   Read-Only Public Properties:
%
%   Methods
%   Constructor:
%       Syntax: this = WifiEncoder( WIFI )
%       Inputs: WIFI < struct > - WiFi parameters structure
%
%   encode:
%       Syntax: encodedBits = encode( inputBits );
%           Intpus: inputBits < 1 x dataBitsPerSymbol > - input bit array
%           to be encoded.
%           Output: encodedBits <1 x codedBitsPerSymbol > - encoded bit
%           array.
%
%   decode:
%       Syntax: decodedBits = decode( llrEstimation );
%           Intpus: llrEstimation < 1 x codedBitsPerSymbol > - array with
%           Log-Likelihood Estimation (LLR) for received bits.
%           Output: decodedBits < 1 x dataBitsPerSymbol > - array with
%           decoded bits
%
%   Author: Bruno Faria
%   Work Address: INDT Brasília
%   E-mail: bruno.faria@indt.org.br
%   History:
%       v2.0 2 Jul 2015 (BF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    properties ( GetAccess = 'protected', SetAccess = 'protected' )
        convEncoder
        puncturer
    end

    methods ( Access = public )

        % constructor
        function this = WifiEncoder( WIFI )

            % Initialize constant parameters
            MCS = WIFI.MCS;
            CHANNEL_BW = WIFI.CH_BANDWIDTH;
            NUM_SPATIAL_STREAMS = WIFI.NSS;

            % Generator polynomals
            POLY_GENERATOR = [ 133 171 ];
            mexFlag = true;

            this.convEncoder = modem.ConvolutionalCode( POLY_GENERATOR, [], ...
                mexFlag  );

            % Get the code rate for the configured MCS
            [ ~, ~, ~, codeRate ] = ...
                lookupTables.modem.wifi.getMCSParam( MCS, ...
                    CHANNEL_BW, NUM_SPATIAL_STREAMS );

            this.puncturer = modem.EncoderRateMatching( codeRate, ...
                this.convEncoder );

        end

        % Other methods.

        encodedBits = encode( this, inputBits );

        decodedBits = decode( this, llrEstimation );

    end
    methods( Access = 'protected' )

    end
end

