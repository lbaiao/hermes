function plotResultsMultiple( resultsDir )
%PLOTRESULTS plots the Simulation Results for HERMES Simulator.
%
%   Syntax: plotResults( resultsDirectory );
%   It plots the results stored in resultsDirectory. If no input directory
%   is assigned, the most recent 'hermes/results' will be considered.
%
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim@indt.org.br>
%   History:
%       15 Apr 2015 (RA) - CREATED
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% -------    Set Results Directory ---------
hermesMainPath = fileparts( which('hermes') );
cd ( hermesMainPath );
% If no resultsDir is assigned, select the most recent subfolder on
% 'hermes/results':
if ~exist( 'resultsDir', 'var' ) || isempty( resultsDir )
    resultsDirAux = [ pwd filesep 'results' ];
    resultsSubfolders = dir ( resultsDirAux );
    resultsSubfolders = resultsSubfolders ( 3:end, : );
    numberOfSubfolders = size ( resultsSubfolders, 1 ) ;
    selectedSubfolder = resultsSubfolders( numberOfSubfolders, : );
    resultsDir = [ resultsDirAux filesep selectedSubfolder.name ];
end

addHermesPaths( resultsDir );

%% ------ Read all Parameter Files Stored in Results Directory -------
    parameterFiles = dir( resultsDir );
    parameterFiles = parameterFiles( 4:end, :);
    numberOfFiles = size( parameterFiles, 1 );   
    for file = 1 : numberOfFiles
        currentParamFile = [ %resultsDir, filesep, ...
                             strtrim( parameterFiles(file, :).name )];
       if file == 4
           load( currentParamFile );
        else
            try 
                run( currentParamFile );
            end
        end
      
    end

%% ----- Read Simulation Parameters ----------
switch SETTINGS.CHANNEL.NOISE_MODEL
    case enum.channel.Noise.AWGN
        NOISE = 'AWGN';
    otherwise
        NOISE = 'NOISELESS';
end

switch SETTINGS.CHANNEL.MULTIPATH.MODEL
    case enum.channel.MultipathModel.NONE
        MULTIPATH = 'Unitary Channel';
    case enum.channel.MultipathModel.GENERIC
        MULTIPATH = 'Generic Channel';
    case enum.channel.MultipathModel.COST259
        MULTIPATH = 'Cost 259 Model';
end

if strcmp(MULTIPATH, 'Cost 259 Model');
    switch SETTINGS.CHANNEL.MULTIPATH.COST259.TYPE
        case enum.channel.Cost259.TYPICAL_URBAN
            TYPECHANNEL = 'TU';
        case enum.channel.Cost259.HILLY_TERRAIN
            TYPECHANNEL = 'HT';
        case enum.channel.Cost259.RURAL_AREA
            TYPECHANNEL = 'RA';
    end    
end

indexMainRxModem = SETTINGS.SCENARIO.MAIN.RX_MODEMS;
modemParameters = SETTINGS.SCENARIO.MODEM{ indexMainRxModem };
switch modemParameters.TECHNOLOGY
    case enum.Technology.LTE_OFDMA
        TECHNOLOGYAUX = 'LTE';
        LTEAUX  = LTE;
        if isfield(modemParameters, 'LTE')
            fields = fieldnames( modemParameters.LTE );
            
            for f = 1 : length( fields )
                LTEAUX.(fields {f}) = ...
                    modemParameters.LTE.(fields{f});
            end
        end
        
        modulationOrder = lookupTables.modem.lte.getModulationOrder ( ...
            LTEAUX.MCS, ...
            LTEAUX.ENABLE256QAM );
        transportBlockSizeIndex = lookupTables.modem.lte.getTbsIndex( LTEAUX.MCS, LTEAUX.ENABLE256QAM);
        numOfPrbs = LTEAUX.NUMBER_PRBS_PER_TRANSPORT_BLOCK;
        transportBlockSize = ...
            lookupTables.modem.lte.getTransportBlockSize( transportBlockSizeIndex , numOfPrbs );
        BLOCK_SIZE = num2str( transportBlockSize );
        
    case enum.Technology.FIVEG
        TECHNOLOGYAUX = '5G';
        FIVEGAUX  = FIVEG;
        if isfield(modemParameters, 'FIVEG')
            fields = fieldnames( modemParameters.FIVEG );
            
            for f = 1 : length( fields )
                FIVEGAUX.(fields {f}) = ...
                    modemParameters.FIVEG.(fields{f});
            end
        end
        
        modulationOrder = lookupTables.modem.fiveG.getMcsParam ( ...
            FIVEGAUX.MCS, ...
            FIVEGAUX.CODE.TYPE );
        BLOCK_SIZE = num2str( FIVEGAUX.TRANSPORT_BLOCK_SIZE_BITS );
        waveformType = FIVEGAUX.WAVEFORM.TYPE;
        
end

switch modulationOrder
    case 2
        MODULATION = 'BPSK';
    case 4
        MODULATION = 'QPSK';
    case 16
        MODULATION = '16QAM';
    case 64
        MODULATION = '64QAM';
    case 256
        MODULATION = '256QAM';
end

switch waveformType
    case enum.modem.fiveG.Waveform.OFDM
        WAVEFORM = 'OFDM';
    case enum.modem.fiveG.Waveform.ZT_DS_OFDM
        WAVEFORM = 'ZT-ds-OFDM';
    case enum.modem.fiveG.Waveform.FBMC
        WAVEFORM = 'FBMC';
end


%% ------------ PLOT BER PERFOMANCE --------------
%load('statistics');
berPerformance = figure;
mainBerPlot = semilogy(statistics.snrVector, statistics.berMean);
hold on;



xlabel('E_B/N_0');
ylabel('BER');
if SETTINGS.CHANNEL.MULTIPATH.MODEL == enum.channel.MultipathModel.COST259
    titleLabel = ['BER Vs E_b/N_0, Channel Type: ' NOISE ' + ' MULTIPATH ' ' TYPECHANNEL ', '  ...
                  'Technology: ' TECHNOLOGYAUX ];
else
    titleLabel = ['BER Vs E_b/N_0, Channel Type: ' NOISE ' + ' MULTIPATH ', '  ...
              'Technology: ' TECHNOLOGYAUX ];
end
title(titleLabel);
legendLabel = [ 'HERMES V1.0 ' MODULATION ' ' WAVEFORM];
legend( [ mainBerPlot ] , legendLabel, 'Confidence Interval');
grid on;

