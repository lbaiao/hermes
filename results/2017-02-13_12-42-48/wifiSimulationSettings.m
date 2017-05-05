%WIFISIMULATIONSETTINGS defines WiFi 802.11ac simulation parameters
%   v1.0 - Simulation setting only for 802.11ac SU-SISO.
%
%   Syntax: wifiSimulationSettings.m
%
%   Authors: Bruno Faria (BF)
%
%   Work Address: INDT
%   E-mail: bruno.faria@indt.org.br
%   History:
%   	v2.0 19 Jun 2015 (BF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied

clear WIFI

% 802.11 PHY Packet format.
% Only VHT is suported
WIFI.PACKET_FORMAT = enum.modem.wifi.PacketFormat.VHT;

% Channel bandwidth
WIFI.CH_BANDWIDTH = enum.modem.wifi.ChannelBandwidth.CBW20;

% Indicates whether a short Guard Interval is used in the transmission of
% the data field of the PPDU
WIFI.GUARD_INTERVAL_TYPE = enum.modem.wifi.GuardInterval.LONG;

% Indicates the modulation and conding scheme used in the transmission of
% the PPDU.
% Values range from 0 to 9.
% Note that some MCS values are not valid for some CH_BANDWIDTH and NSS
% combinations
WIFI.MCS = 0;

% Number of spatial streams
WIFI.NSS = 1;
