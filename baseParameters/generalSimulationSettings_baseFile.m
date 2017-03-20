%GENERALSIMULATIONSETTINGS_BASEFILE defines general simulation parameters
%   This file is used as a base to the simulations that will run on grid
%   engine. How to use this file: chose the parameters that will be changed
%   during this simulation campaign, and replace them with an x.
%
%   Syntax: generalSimulationSettings_baseFile.m
%
%   Authors: Lilian Freitas (LCF), Erika Almeida (EA), André Noll Barreto (ANB)
%   Work Address: INDT Manaus/Brasília
%   E-mail: <lilian.freitas, erika.almeida, andre.noll>@indt.org
%   History:
%      v1.0 04 Mar 2015 (LCF, EA, ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

clear SETTINGS

% ========================================================================
%                       Simulation Loop Parameters
% ========================================================================

% drop duration in seconds.
SETTINGS.DROPS.DURATION = .05;

% simulation stopping criteria
SETTINGS.DROPS.STOPPING_CRITERIA = ...
    [ enum.drops.StoppingCriteria.MAX_DROPS, ...
      enum.drops.StoppingCriteria.CONFIDENCE_INTERVAL_BER ];

% in case of multiple criteria, create a vector with the corresponding
% enums.
% A list of permitted values may be found at:
% src\+enum\+drops\StoppingCriteria.m

% Maximum number of drops - positive integer
% only used if STOPPING_CRITERIA contains the "MAX_DROPS" criterion
SETTINGS.DROPS.MAX_NUMBER_OF_DROPS = x;

% Minimum number of drops - positive integer
SETTINGS.DROPS.MIN_NUMBER_OF_DROPS = x;

% Confidence level - range: [ 0 - 1 ];
SETTINGS.DROPS.CONFIDENCE_LEVEL = 0.94;
% only used if STOPPING_CRITERIA contains the "CONFIDENCE_INTERVAL"
% criterion

% Relative Error Margin - range: [ 0 - 1 ];
SETTINGS.DROPS.ERROR_MARGIN = 0.1;
% only used if STOPPING_CRITERIA contains the "CONFIDENCE_INTERVAL"
% criterion

% Exact meaning of SNR
SETTINGS.SNR.TYPE = enum.snr.Type.EBNO;
% A list of permitted values may be found at:
% src\+enum\+snr\Type.m

% SNR values to be used to create the BLER curves in dB. Its type is
% defined by parameter SETTINGS.SNR.TYPE
SETTINGS.SNR.VECTOR_dB = 0:2:30;


% display options 
SETTINGS.SHOW_PROGRESS = true; % display simulation progress
SETTINGS.DISPLAY_INTERVAL = 0.01; % display at a given simulation interval

% ========================================================================
%
%
% ==========================  SCENARIO  ==================================
% ========================================================================
%                       Node Parameters
% ========================================================================
% SETTINGS.SCENARIO.NODE{ N } contains the statistics for the n-th node in scenario.

% node position in 3D-space in meters
SETTINGS.SCENARIO.NODE{1}.POSITION = [0 0 0];
SETTINGS.SCENARIO.NODE{2}.POSITION = [0 0 0];

% node velocity in 3D in m/s. If a scalar is given, then velocity in
% x-axis only is considered
SETTINGS.SCENARIO.NODE{1}.VELOCITY = 0;
SETTINGS.SCENARIO.NODE{2}.VELOCITY = 10;


% ========================================================================
%                       Modem Parameters
% ========================================================================
% SETTINGS.SCENARIO.MODEM{ N } contains the statistics for the n-th modem in scenario.
% SETTINGS.SCENARIO.MODEM{ N }.NODE defines the node which the modem N belongs to.
% node associated to each modem. More than one modem may be associated to
% same node
SETTINGS.SCENARIO.MODEM{1}.NODE = 1;
SETTINGS.SCENARIO.MODEM{2}.NODE = 2;

% define radio access technology for each modem
% specific technology parameters are given in specific technology
% configuration file
SETTINGS.SCENARIO.MODEM{1}.TECHNOLOGY = enum.Technology.LTE_OFDMA;
SETTINGS.SCENARIO.MODEM{2}.TECHNOLOGY = ...
    SETTINGS.SCENARIO.MODEM{1}.TECHNOLOGY;

SETTINGS.SCENARIO.MODEM{1}.LTE.MCS = 10;
% The default values for technology parameters will be loaded in the
% specific settings file for each technology.
% The default parameters may be overridden, as in this example:
% SETTINGS.SCENARIO.MODEM{n}.LTE.PARAM1 = Override
SETTINGS.SCENARIO.MODEM{2}.LTE = SETTINGS.SCENARIO.MODEM{1}.LTE;
%Define the number of Antennas per Modem.
SETTINGS.SCENARIO.MODEM{ 1 }.NUMBER_OF_ANTENNAS = 1;
SETTINGS.SCENARIO.MODEM{ 2 }.NUMBER_OF_ANTENNAS = 1;

SETTINGS.SCENARIO.MODEM{ 1 }.ANTENNA_POSITION = [0 0 0];
SETTINGS.SCENARIO.MODEM{ 2 }.ANTENNA_POSITION = [0 0 0];

SETTINGS.SCENARIO.MODEM{ 1 }.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;
SETTINGS.SCENARIO.MODEM{ 2 }.ANTENNA_TYPE = enum.antenna.AntennaType.ISOTROPIC;


% The default values for technology parameters will be loaded in the specific settings file for each technology.
% The default parameters may be overridden, as in this example:
% SETTINGS.SCENARIO.MODEM{n}.LTE.PARAM1 = Override


% Define the pair of Tx-Rx MODEMS involved in the link where the statistics will be measured.
% Ex: SETTINGS.SCENARIO.MAIN.TX_MODEMS = [1 2] and SETTINGS.SCENARIO.MAIN.RX_MODEMS = [3 4]
% represents two links, formed by Modems 1-3 and 2-4 respectively.
SETTINGS.SCENARIO.MAIN.TX_MODEMS = 1;
SETTINGS.SCENARIO.MAIN.RX_MODEMS = 2;


% carrier frequency in Hertz
SETTINGS.SCENARIO.MODEM{1}.CARRIER_FREQUENCY = x;
SETTINGS.SCENARIO.MODEM{2}.CARRIER_FREQUENCY = ...
    SETTINGS.SCENARIO.MODEM{1}.CARRIER_FREQUENCY;

% channel estimation (only relevant for receiving modems)
SETTINGS.SCENARIO.MODEM{2}.CHANNEL_ESTIMATION = enum.modem.ChannelEstimation.PERFECT;
SETTINGS.SCENARIO.MODEM{2}.EQUALIZATION = enum.modem.Equalization.ZF;
% A list of permitted values may be found at:
% src\+enum\+modem\ChannelEstimation.m

% LLR calculation method
SETTINGS.SCENARIO.MODEM{2}.LLR_METHOD = enum.modem.LlrMethod.IDEAL_AWGN;
% A list of permitted values may be found at:
% src\+enum\+modem\LlrMethod.m


% ========================================================================
%                       Channel Parameters
% ========================================================================

% multipath channel model
SETTINGS.CHANNEL.MULTIPATH.MODEL = enum.channel.MultipathModel.COST259;
% A list of permitted values may be found at:
% src\+enum\+channel\MultipathModel.m

% parameters of generic multipath channel
SETTINGS.CHANNEL.MULTIPATH.GENERIC.DELAYS_S = [0 100e-9 200e-9];
SETTINGS.CHANNEL.MULTIPATH.GENERIC.POWER_DELAY_PROFILE_DB = [0 -3 -6];
SETTINGS.CHANNEL.MULTIPATH.GENERIC.K_RICE_DB = [-inf -inf -inf];
SETTINGS.CHANNEL.MULTIPATH.GENERIC.DOPPLER = 0;
    
% parameters of COST 259
SETTINGS.CHANNEL.MULTIPATH.COST259.TYPE = enum.channel.Cost259.RURAL_AREA; 
SETTINGS.CHANNEL.MULTIPATH.COST259.DOPPLER = ...
    norm ( SETTINGS.SCENARIO.NODE{2}.VELOCITY ) / 3e8 * ...
    SETTINGS.SCENARIO.MODEM{2}.CARRIER_FREQUENCY;


% noise model
SETTINGS.CHANNEL.NOISE_MODEL =  enum.channel.Noise.AWGN;
% A list of permitted values may be found at:
% src\+enum\+channel\Noise.m



