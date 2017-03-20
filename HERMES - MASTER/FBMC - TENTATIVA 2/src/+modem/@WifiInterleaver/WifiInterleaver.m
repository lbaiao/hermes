classdef WifiInterleaver < handle
%WIFIINTERLEAVER class implements the 802.11ac Interleaver object.
% The WifiInterleaver object is responsible for interleaving and
% deinterleaving the bit stream from/to BCC encoder. 
% The interleaver takes sequential bits from the carriers and separates
% them to avoid errors in burst.
% The operation is based on 802.11ac PHY specification.
%
%
%   Methods
%   constructor
%       Construct the WifiInterleaver object and initialized the
%       interleaver table
%
%           Syntax:
%               this = WiFiInteleaver(WIFI);
%  
%           Input:
%               WIFI < struct > - parameters structure
%
%   interleave
%       Interleave the packet in codedBitsPerSymbol blocks.
%
%       Syntax
%           interleavedBitStream = this.interleave(inputBitStream);
%
%       Input
%           inputBitStream <bitsPerInterleaverBlock x 1>: array of bits to be
%           interleaved
%       
%       Output
%           interleavedBitStream <bitsPerInterleaverBlock x 1>: array of
%           interleaved bits
%
%   deinterleave
%       Deinterleave the packet in codedBitsPerSymbol blocks.
%
%       Syntax
%           deinterleavedBitStream = this.deinterleave(inputBitStream);
%
%       Input
%           inputBitStream <bitsPerInterleaverBlock x 1>: array of bits to be
%           deinterleaved
%       
%       Output
%           deinterleavedBitStream <bitsPerInterleaverBlock x 1>: array of
%           deinterleaved bits
%
%   Author: Bruno Faria (BF)
%   Work Adress: INDT Brasilia
%   E-mail: bruno.faria@indt.org.br
%   History:
%       v2.0 19 Jun 2015 (BF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    % properties definition
    properties ( Access = 'protected' )
        % Number of coded bits per OFDM symbol
        codedBitsPerSymbol
        
        % Interleaving table that contains output array positions for bits 
        % in the input array
        interleaverTable = [];
    end
    
    methods
        % constructor
        function this = WifiInterleaver( WIFI )

            % Initialize necessary data needed for bit permutation
            [ bitsPerSubCarrier, this.codedBitsPerSymbol, ~ ] = ...
                lookupTables.modem.wifi.getMCSParam( WIFI.MCS, ...
                    WIFI.CH_BANDWIDTH, WIFI.NSS );
            
            switch WIFI.CH_BANDWIDTH
                case enum.modem.wifi.ChannelBandwidth.CBW20
                    numCol = 13;
                    numRow = 4 * bitsPerSubCarrier;                   
                case enum.modem.wifi.ChannelBandwidth.CBW40
                    numCol = 18;
                    numRow = 6 * bitsPerSubCarrier;
                case enum.modem.wifi.ChannelBandwidth.CBW80
                    numCol = 26;
                    numRow = 9 * bitsPerSubCarrier;
                otherwise
                    error( 'WifiInterleaver: invalid Channel Bandwidth' );
            end

            % Initialiaze the interleving tables according to IEEE Std
            % 802.11ac - 22.3.10.8 
            
            % Sorted array
            k = 0:( this.codedBitsPerSymbol - 1 );
            
            % First permutation
            i = numRow * rem( k, numCol ) + floor( k / numCol );
            
            % Bits per axis
            bitsPerAxis = max( bitsPerSubCarrier / 2, 1 );
            
            % Second permutation
            tmp = i + this.codedBitsPerSymbol - ...
                floor( ( numCol * i ) / this.codedBitsPerSymbol );
            this.interleaverTable = bitsPerAxis * floor( i / bitsPerAxis ) + ...
                rem( tmp, bitsPerAxis ) + 1;
            
            % TODO: For NSS > 1 there is a third permutation that is
            % actually a bit rotation.
            
        end
        % other methods
        interleavedBitStream = interleave( this, inputBitStream );
        deinterleavedBitStream = deinterleave( this, inputBitStream );
    end
    
end

