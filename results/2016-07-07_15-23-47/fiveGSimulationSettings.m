%FIVEGSIMULATIONSETTINGS defines 5G simulation parameters
%
%   Syntax: fiveGSimulationSettings.m
%
%   Authors: Andre Noll Barreto (AB)
%   Work Address: INDT
%   E-mail: andre.noll@indt.org
%   History:
%      v2.0 20 Apr 2015  - created (AB)
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

clear FIVEG

%%
% Settable parameters

%% Define modulation parameters

% subcarrier spacing in Hz
FIVEG.SUBCARRIER_SPACING = 60e3;

FIVEG.FFT_SIZE = 2048;

% number of subcarriers, i.e., except null subcarriers (must be even)
FIVEG.USEFUL_SUBCARRIERS = 1650;

% waveform, see allowed values in +enum/+modem/+fiveG/Waveform.m
FIVEG.WAVEFORM.TYPE = enum.modem.fiveG.Waveform.OFDM;

% OFDM parameters,
% samples in cyclic prefix
FIVEG.WAVEFORM.OFDM.CYCLIC_PREFIX = 1; % round ( 1/8 * FIVEG.FFT_SIZE );

% ZT_DS_OFDM parameters
% number of samples in zero tail
FIVEG.WAVEFORM.ZT_DS_OFDM.TAIL = round ( 1/8 * FIVEG.USEFUL_SUBCARRIERS );
% number of samples in low-power head
FIVEG.WAVEFORM.ZT_DS_OFDM.HEAD = 2;

% FBMC parameters
FIVEG.WAVEFORM.FBMC.OVERLAPPING_FACTOR = 4;
FIVEG.WAVEFORM.FBMC.FILTER_TAIL = FIVEG.FFT_SIZE/2;

% MIMO settings
% see src/+enum/+modem/MimoScheme.m
FIVEG.MIMO_SCHEME = enum.modem.MimoScheme.NONE;

%%
% Define frame structure

% frameType, see allowed values in +enum/+modem/+fiveG/FrameType.m
FIVEG.FRAME_TYPE = enum.modem.fiveG.FrameType.DOWNLINK;

% Define frame fields, i.e., define in which order signalling and data
% symbols are transmitted. The frame is divided into fields, and it is
% assumed that each field contains just one kind of information.
FIVEG.FRAME = [ enum.modem.fiveG.FrameMap.DL_CONTROL, ...
               enum.modem.fiveG.FrameMap.GUARD, ...
               enum.modem.fiveG.FrameMap.UL_CONTROL, ...
               enum.modem.fiveG.FrameMap.GUARD, ...
               enum.modem.fiveG.FrameMap.REF_SIGNAL, ...
               enum.modem.fiveG.FrameMap.DATA, ...
               enum.modem.fiveG.FrameMap.GUARD ];

% Define number of symbols in each of the fields listed in FIVEG.FRAME.
% For data and control signals the symbol length can be obtained from the
% parameters in FIVEG.WAVEFORM, for guard periods the length must be
% defined in FIVEG.GUARD_PERIOD.
FIVEG.NUMBER_OF_SYMBOLS = [ 1 1 1 1 1 11 1];

% Guard period (filled up with zeros )
FIVEG.GUARD_PERIOD = .89e-6;

% Useful blocks pre counting

FIVEG.USEFUL_BLOCKS = sum(FIVEG.NUMBER_OF_SYMBOLS) - ...
                     numel(find(FIVEG.FRAME == enum.modem.fiveG.FrameMap.GUARD));


%% Define MAC parameters

FIVEG.TRANSPORT_BLOCK_SIZE_BITS = 4000;


%% Define MCS Parameters.
FIVEG.MCS = 10;  % See Table in lookupTables.modem.fiveG.getMcsParam
FIVEG.CODE.TYPE = enum.modem.CodeType.TURBO;
FIVEG.CODE.TURBO.ITERATIONS = 4;


%% Define HARQ Parameters
FIVEG.HARQ.ENABLED = true;              % True or False
FIVEG.HARQ.MAX_RETX_TIMER = 1;          % Time taken to retx the packet
% (in number of simulation loops),
% after receiving a NACK.
FIVEG.HARQ.MAX_NUMBER_OF_RETX = 4;      % Maximum Number Of Retransmisisons
FIVEG.HARQ.NUMBER_OF_HARQ_PROCESS = 15; % Max. Number of HARQ Process
FIVEG.HARQ.MAX_ACK_TIMER = 4;           % Receiver timer to send an ACK after
% receiving the packet
FIVEG.HARQ.MAX_NUM_OF_RV = 4; % Number of Redundancy Versions Available.

%% Define DL/UL Load Ratio:
FIVEG.DL_LOAD_RATIO = 0.75; % In interval [ 0 , 1 ]. It measures the amount of
% cell load correspondent to DL.
% UL LOAD = 1 - ( DL LOAD ).
