%LTESIMULATIONSETTINGS defines LTE simulation parameters
%
%   Syntax: lteSimulationSettings.m
%
%   Authors: Lilian Freitas (LCF), Erika Almeida (EA),
%            Rafhael Medeiros de Amorim (RMA),
%            Fadhil Firyaguna (FF)
%   Work Address: INDT
%   E-mail: <lilian.freitas, erika.almeida, rafhael.amorim>@indt.org.br,
%           <fadhil.firyaguna@indt.org>
%   History:
%   	v1.0 4 Mar 2015 (LCF, EA, RMA) - created
%       v1.1 22 Apr 2015 (FF) - MIMO settings
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

clear LTE

% settable parameters
LTE.DUPLEX_MODE = enum.modem.lte.DuplexMode.TDD;

LTE.BANDWIDTH_MHz = x;

LTE.CYCLIC_PREFIX = enum.modem.lte.CyclicPrefix.EXTENDED; % LTE Cyclic Prefix

LTE.CARRIER_SPACING_kHz = 15; % carrier spacing in kHz. Values: 15 kHz or 7.5 kHz
                              % 7.5 kHz is not current implemented.

LTE.ENABLE256QAM = true;

% MIMO settings
% see src/+enum/+modem/MimoScheme.m
LTE.MIMO_SCHEME = enum.modem.MimoScheme.NONE;

LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK = 10; % As DEFINED IN STANDARD 3GPP TS 36.213-v12.4.0 Section 7.1.7.2, page 61

LTE.ENCODER.TYPE = enum.modem.CodeType.TURBO; % Encoder Type

LTE.ENCODER.TURBO.ITERATIONS = 4; % Number of Iterations in the Turbo Decoder

% see src/lookupTables/modem/lte/lookupSubframesConfig
LTE.SUBFRAMES_DIRECTION = enum.modem.lte.SubframesDirection.CONFIG_3; % Only used for TDD!!!

LTE.PDCCH_LENGTH = 2; % 1/2/3   Extension of PDCCH in OFDM Symbols per DL Subframe.

% HARQ Parameters:
LTE.HARQ.ENABLED = true; % True or False
LTE.HARQ.MAX_RETX_TIMER = 1; % Time taken to retx the packet
                             % (in number of simulation loops),
LTE.HARQ.MAX_NUMBER_OF_RETX = 4; % Maximum Number Of Retransmisisons

%%

