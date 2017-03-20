function FIVEG = fiveGCheckParameters( FIVEG, paramTable )
%FIVEGCHECKPARAMETERS This function Set the fixed FIVEG Simulation parameters.
%  This function is responsible for checking FIVEG parameters.
%  Range of defined parameters, as well as the validity of assigned parameters
%  should be tested in this function. If the parameters are not
%  compliant, error messages will stop the execution of HERMES Link Simulator.
%  After all parameters are checked, this function will load all 5G
%  fixed parameters or those that have a dependency relationship with user
%  defined parameters. 
%
%   Syntax: FIVEG = fiveGSetParameters( FIVEG, paramTable )
%   Inputs: FIVEG < struct > : Contais all FIVEG set parameters.
%           paramTable < 1x1 parameterCheck.ParameterDef >: Object with the
%           list of expected 5G Parameters.
%
%   Author: Rafhael Amorim ( RA)
%   Work Address: INDT
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%     v2.0 20 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% ====================== Verify syntax ==================================                     
% verify if any invalid field is listed in parameters
assert( ~paramTable.anyInvalidField( FIVEG ) );

% verify if all mandatory fields are defined and assign default values
FIVEG = paramTable.checkMandatoryFields( FIVEG );
assert( ~isempty( FIVEG ) );

% ==================== Load 5G Fixed Parameters ==========================
% Load MCS Parameters
FIVEG.SAMPLING_RATE = FIVEG.SUBCARRIER_SPACING * FIVEG.FFT_SIZE;
[FIVEG.MODULATION_ORDER, FIVEG.CODE.CODE_RATE ] = ...
    lookupTables.modem.fiveG.getMcsParam( FIVEG.MCS ,FIVEG.CODE.TYPE );

% Encoder Parameters
switch FIVEG.CODE.TYPE
    case enum.modem.CodeType.CONVOLUTIONAL
        FIVEG.CODE.CONVOLUTIONAL.POLYNOMIAL = [133 171];
        FIVEG.CODE.CONVOLUTIONAL.FEEDBACK = [];
    case enum.modem.CodeType.TURBO
        FIVEG.CODE.TURBO.POLYNOMIAL = [ 13 15; 13 15];
        FIVEG.CODE.TURBO.FEEDBACK = [13; 13];
        FIVEG.CODE.TURBO.TAILBITS = 4;
end

% Load
FIVEG.UL_LOAD_RATIO = 1 - FIVEG.DL_LOAD_RATIO;
% NUMBER OF UES Expected
numberOfDlSymbols = FIVEG.NUMBER_OF_SYMBOLS( ...
            find( FIVEG.FRAME == enum.modem.fiveG.FrameMap.DATA ) );
FIVEG.NUMBER_OF_UES = floor( FIVEG.USEFUL_SUBCARRIERS * log2( FIVEG.MODULATION_ORDER ) * ...
                             FIVEG.CODE.CODE_RATE * numberOfDlSymbols ...
                             / FIVEG.TRANSPORT_BLOCK_SIZE_BITS ) ;