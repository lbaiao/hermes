function LTE = lteCheckParameters( LTE, paramTable )
%LTECHECKPARAMETERS This function checks LTE parameters.
%  This function is responsible for checking LTE parameters.
%  Range of defined parameters, as well as the validity of assigned parameters
%  should be tested in this function. If the parameters are not
%  compliant, error messages will stop the execution of HERMES Link Simulator.
%  After all parameters are checked, this function will load all LTE
%  parameters fixed or that have a dependency relationship with user
%  defined parameters. 
%
%   Syntax: lteCheckParameters
%   Input: LTE < struct > : Contains all user set LTE Parameters
%          paramTable < parameterCheck.ParameterDef > : Object with the
%          table of expected User Defined LTE Parameters.
%
%   Author: Rafhael Amorim ( RA )
%   Work Address: INDT
%   E-mail: < rafhael.amorim >@indt.org.br
%   History:
%     v2.0 21 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% ====================== Verify syntax ==================================                     
% verify if any invalid field is listed in parameters
assert( ~paramTable.anyInvalidField( LTE ) );

% verify if all mandatory fields are defined and assign default values
LTE = paramTable.checkMandatoryFields( LTE );
assert( ~isempty( LTE ) );


%% ================= Load LTE Fixed Parameters ===========================
LTE.FRAME_DURATION = 1*10^-3; % As DEFINED IN STANDARD 3GPP TS 36.211-v12.4.0 Section 4 Page 10
                              % LTE SUBFRAME DURATION!! In LTE the
                              % simulation unity is the subframe.
LTE.NUMBER_OF_SUBFRAMES = 10; % As DEFINED IN STANDARD 3GPP TS 36.211-v12.4.0 Section 4 Page 11

LTE.NUMBER_OF_SLOTS_PER_SUBFRAME = 2; % As DEFINED IN STANDARD 3GPP TS 36.211-v12.4.0 Section 4 Page 11

LTE.SUBCARRIERS_PER_PRB = 12; % As DEFINED IN STANDARD 3GPP TS 36.211-v12.4.0 Table 6.2.3-1 Page 60

LTE.MAX_CELL_ID =  503; % As DEFINED IN STANDARD 3GPP TS 36.211-v12.4.0 Section 6.11, page 109

LTE.SAMPLING_RATE = 15000 * 2048; % As DEFINED IN STANDARD 3GPP TS 36.211-v12.4.0 Section 4, page 10

LTE.NUMBER_OF_CRC_BITS = 24; % As DEFINED IN STANDARD 3GPP TS 36.212-v10.0.0 Section 5.1.1, page 8

LTE.ENCODER.TURBO.GENERATOR_POLYNOMIAL = [ 13 15; 13 15]; % As DEFINED IN STANDARD 3GPP TS 36.212-v10.0.0

LTE.ENCODER.TURBO.FEEDBACK_CONNECTION = [ 13; 13 ];  % As DEFINED IN STANDARD 3GPP TS 36.212-v10.0.0

LTE.MEX_FLAG = true;

LTE.ENCODER.TURBO.TAILBITING = false; % Use Turbo Encoder Tail Biting
%% ======== LTE Parameters that depends on previous set Parameters =======

% Max FFT Size
switch LTE.CARRIER_SPACING_kHz
    case 15

    LTE.MODULATOR.MAX_FFT_SIZE = 2048;

    case 7.5
    error( 'LTE CARRIER SPACING OF 7.5 kHz is not implemented');

    otherwise
    error( 'LTE CARRIER SPACING SELECTED IS INVALID');
end

% Cyclic Prefix Size and OFDM Symbols per Subframe
if LTE.CYCLIC_PREFIX == enum.modem.lte.CyclicPrefix.NORMAL
    LTE.OFDM_SYMBOLS_PER_SUBFRAME = 14; %LTE OFDM Symbols Per Subframe

    LTE.MODULATOR.NORMAL_CYCLIC_PREFIX_SAMPLES = 144;                 %Cyclic Prefix Length in Samples
     LTE.MODULATOR.NORMAL_FIRST_SYMBOL_CYCLIC_PREFIX_SAMPLES = 160;   % STANDARD DEFINED IN TS 36.211-v12.4.0 TABLE 6.12.1, page 113
                                                                      % Reference Values for LTE Modulator


elseif LTE.CYCLIC_PREFIX == enum.modem.lte.CyclicPrefix.EXTENDED
    LTE.OFDM_SYMBOLS_PER_SUBFRAME = 12;  %LTE OFDM Symbols Per Subframe

    LTE.MODULATOR.EXTENDED_CYCLIC_PREFIX_SAMPLES = 512; %Cyclic Prefix Length in Samples
                                                        % STANDARD DEFINED IN TS 36.211-v12.4.0 TABLE 6.12.1, page 113
                                                        % This are reference values for the LTE MODULATOR:
end

LTE.OFDM_SYMBOLS_PER_SLOT = LTE.OFDM_SYMBOLS_PER_SUBFRAME / LTE.NUMBER_OF_SLOTS_PER_SUBFRAME; 

% LTE Number of Subcarriers
% Number of PRBs Calculation DEFINED IN STANDARD 3GPP TS 36.104-V12.6.0,
% Table 5.6-1, Page 23
switch LTE.BANDWIDTH_MHz
    case 1.4
        LTE.N_PRB = 6; % 6 PRBs for 1.4 MHz frame
    case { 5, 10 , 15, 20 } % For other bandwidths
        LTE.N_PRB = LTE.BANDWIDTH_MHz * 0.9 / ( LTE.CARRIER_SPACING_kHz * LTE.SUBCARRIERS_PER_PRB ) * 1000 ;
    otherwise
        error( 'Selected Bandwidth is not available for LTE' );
end

% LTE Subframes Configuration
lookupTables.modem.lte.lookupSubframesConfig; % Load lookup Table for Subframes Configuration
LTE.SUBFRAMES_CONFIG = SUBFRAMES_DIRECTION; % Assign subframes directions.

LTE.HARQ.NUMBER_OF_HARQ_PROCESS = lookupTables.modem.lte.getHarqProcess( LTE ); % Max. Number of HARQ Process
LTE.HARQ.MAX_ACK_TIMER = 4; % Receiver timer to send an ACK after 
                            % receiving the packet
LTE.HARQ.MAX_NUM_OF_RV = 4; % Number of Redundancy Versions Available.

end


