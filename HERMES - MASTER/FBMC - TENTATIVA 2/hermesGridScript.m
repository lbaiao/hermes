%HERMESGRIDSCRIPT create input files following a combination of parameters
%   This file needs to be edited every time a new simulation campaing is
%   performed. The user needs to define:
%       The set of parameters to be combined;
%       The simulation campaing name;
%
%   Syntax: hermesGridScript
%
%   Author: Erika Portela Lopes de Almeida
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org
%   History:
%      v2.0 8 Jul 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

clear all;
close all;
clc 

% ========================================================================
%          specify the folder to the base files you want to use
% ========================================================================

FILE.folderName =  'baseParameters'; 

% add hermes path 
addHermesPaths([ pwd filesep FILE.folderName]);

% choose the structs names that will store the parameters.
n = 1;
FILE.parameterStructs{ n } = 'LTE';
n = n + 1;
FILE.parameterStructs{ n } = 'SETTINGS';
% n = n + 1;
% FILE.parameterStructs{ n } = 'FIVEG';
% n = n + 1;
% FILE.parameterStructs{ n } = 'WIFI';

% ========================================================================
%                      Chose your simulation name 
% ========================================================================

% define a prefix to identify your simulation >> this is used to identify
% the folders where your simulation results will be stored.
FILE.simulationPrefix = 'simulationPrefix'; 

% define a index for your simulation
FILE.simulationSuffix = 'simulationSuffix';

% the final simulation folder will be:
% simulationPrefix_Param1Val1Label_ParamNVal1Label_simulationSuffix

% ========================================================================
%                      Chose your script file name suffix
% ========================================================================

% define a suffix for your script file
FILE.scriptSuffix = '0_0';

% ========================================================================
%                      Specify how many jobs / drops you want
% ========================================================================

% number of drops per Job
FILE.numberOfDropsPerJob = 10;

% number of jobs 
FILE.numberOfJobs = 10;

% ========================================================================
%                   Choose the parameters you want to change 
% ========================================================================

% it is VERY important that different parameters have DIFFERENT LABELS!
n = 0;

% >>>>>>>>>>>>>>>> INSERT THE PARAMETER TO BE CHANGED HERE <<<<<<<<<<<<<<<<
n = n + 1;
PARAMETER{ n }.name = {'SETTINGS.SCENARIO.MODEM{1}.CARRIER_FREQUENCY'};
PARAMETER{ n }.value = {'2.4e9','5e9'};
PARAMETER{ n }.label = {'2e4GHz','5e9GHz'};

% >>>>>>>>>>>>>>>> INSERT THE PARAMETER TO BE CHANGED HERE <<<<<<<<<<<<<<<<
n = n + 1;
PARAMETER{ n }.name = {'LTE.BANDWIDTH_MHz'};
PARAMETER{ n }.value = {'5','10','20'};
PARAMETER{ n }.label = {'BW5MHz','BW10MHz','BW20MHz'};

% >>>>>>>>>>>>>>>> INSERT THE PARAMETER TO BE CHANGED HERE <<<<<<<<<<<<<<<<
n = n + 1;
PARAMETER{ n }.name = {'SETTINGS.DROPS.MIN_NUMBER_OF_DROPS'};
PARAMETER{ n }.value = {'2','5'};
PARAMETER{ n }.label = {'minDrops2','minDrops5'};

clear n

% are there any impossible combinations? Put here the labels and values
% that can't be combined. If one parameter has many values that can't be
% combined with others, please, create new avoided combinations. The
% combination name is a cell of size 1 x parametersThatCantBeCombined
% positions. In each position, put the parameter name. In the label part,
% select the correspondent labels of the values that can't be combined.
n = 1;
AVOIDED_COMBINATION{ n }.name = { 'SETTINGS.SCENARIO.MODEM{1}.CARRIER_FREQUENCY', ...
                                  'LTE.BANDWIDTH_MHz' };
AVOIDED_COMBINATION{ n }.label = { '5e9GHz','BW5MHz'};

n = n + 1;
AVOIDED_COMBINATION{ n }.name = { 'SETTINGS.SCENARIO.MODEM{1}.CARRIER_FREQUENCY', ...
                                  'LTE.BANDWIDTH_MHz'};
AVOIDED_COMBINATION{ n }.label = { '5e9GHz', 'BW20MHz' };

% ========================================================================
%                   Combine parameters and write grid scripts
% ========================================================================

combineHermesParameters( FILE, PARAMETER, AVOIDED_COMBINATION );
