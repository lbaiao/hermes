function createModem( this, inputs )
% MODEM.CREATEMODEM Create modem object with attributes filled.
%   Detailed description is in class header.
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v1.0 26 Mar 2015 - (RA) created (no multipath)
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

modemParameters = inputs { 1 };

if isa( inputs{ 2 }, 'modem.Modem' )
    clone = inputs{2};
    technologyParameters = [];
else
    clone = [];
    technologyParameters = inputs{2};
end

randomStreams = inputs{3};
rxFlag = inputs{4};


% =========================== Antenna Array ===============================
antPosition = modemParameters.ANTENNA_POSITION;
switch modemParameters.ANTENNA_TYPE
    case enum.antenna.AntennaType.OMNI
        % Omni Directional Antennas
        error('Omni Directional Antennas are not available');

    case enum.antenna.AntennaType.ISOTROPIC
        % Isotropic Antennas
        azimuthAngle_rad = [];
        elevationAngle_rad = [];
        polarization = [];
        maxGain_dBi = 0;
        antennaSet =  networkEntity.IsotropicAntenna ( antPosition , ...
            azimuthAngle_rad, ...
            elevationAngle_rad, ...
            polarization, maxGain_dBi);

    case enum.antenna.AntennaType.USER_DEFINED
        %User Defined Antennas
        error('User Defined Antennas are not available');
end

% ========================= rf Imperfection ===============================
rfSet = [];

% Technology Dependent Components:
if ~isempty( clone )

    if ~rxFlag
        error('transmit modem cannot be built upon another modem')
    end

    % use same instances as other modem
    scramblerSet = clone.scrambler;
    mapperSet = clone.mapper;
    mapperSet.setLlrMethod( modemParameters.LLR_METHOD );

    spatialCoderSet = clone.spatialCoder;
    spatialCoderSet.setNumberOfAntennas( [], modemParameters.NUMBER_OF_ANTENNAS );

    frameAssemblerSet = clone.frameAssembler;
    sourceSet = clone.source;
    channelCodeSet = clone.channelCode;
    harqSet = clone.harq;
    switch modemParameters.TECHNOLOGY
        case enum.Technology.LTE_OFDMA
            % Inner Transceiver is a Receiver:
            innerTransceiverSet = modem.LteInnerReceiver( ...
                clone.innerTransceiver, ...
                modemParameters.CHANNEL_ESTIMATION, ...
                modemParameters.EQUALIZATION, ...
                enum.modem.NoiseEstimation.PERFECT );

        case enum.Technology.FIVEG
            % Inner Transceiver is a Receiver:
            innerTransceiverSet = modem.FiveGInnerReceiver( ...
                clone.innerTransceiver, ...
                modemParameters.CHANNEL_ESTIMATION, ...
                modemParameters.EQUALIZATION, ...
                enum.modem.NoiseEstimation.PERFECT, ...
                frameAssemblerSet );

        otherwise
            error('The Technology selected for the Modem is not available in the Simulator');
    end

else
    if rxFlag
        error('transmit modem must be built upon another modem')
    end



    switch modemParameters.TECHNOLOGY
        case enum.Technology.LTE_OFDMA


            %=============== Mapper ===========================================
            modulationOrder = lookupTables.modem.lte.getModulationOrder ( ...
                technologyParameters.MCS, ...
                technologyParameters.ENABLE256QAM );
            mapperSet = modem.LteMapper( modulationOrder );
            %=============== Spatial Coder ====================================
            spatialCoderSet = modem.SpatialCoder ( technologyParameters );
            spatialCoderSet.setNumberOfAntennas( modemParameters.NUMBER_OF_ANTENNAS, [] );

            %============== Frame Assembler ===================================
            frameAssemblerSet = modem.LteFrameAssembler ( ...
                technologyParameters, ...
                randomStreams{ enum.RandomSeeds.FRAME } );
            frameAssemblerSet.setNumberOfAntennas( modemParameters.NUMBER_OF_ANTENNAS );

            %==================== Scrambler ===================================
            scramblerSet = modem.LteScrambler ( frameAssemblerSet );

            %=============  Modulator =========================================
            modulationSet = modem.LteOfdmModulation ( technologyParameters, ...
                frameAssemblerSet );
            modulationSet.setCenterFrequency( modemParameters.CARRIER_FREQUENCY );

            innerTransceiverSet = modulationSet;
            %===================== HARQ =============================
            numberOfUes = technologyParameters.N_PRB / technologyParameters.NUMBER_PRBS_PER_TRANSPORT_BLOCK;
            harqSet = modem.Harq ( technologyParameters.HARQ , numberOfUes, ...
                                    enum.FrameDirection.DOWNLINK );
            
            %============ Source ===========================
            sourceSet = source.LteSource( ...
                randomStreams{ enum.RandomSeeds.SOURCE }, ...
                technologyParameters , harqSet );


            % =================== Encoder ========================
            switch technologyParameters.ENCODER.TYPE
                case enum.modem.CodeType.NONE
                    channelCodeSet = modem.ChannelCode();

                case enum.modem.CodeType.TURBO
                    channelCodeSet = modem.LteEncoder( technologyParameters, ...
                        frameAssemblerSet, ...
                        randomStreams{ enum.RandomSeeds.ENCODER } , harqSet );
            end
            
            
        case enum.Technology.FIVEG
            %=============== Mapper ===========================================
            mapperSet = modem.LteMapper( technologyParameters.MODULATION_ORDER );

            %=============== Spatial Coder ====================================
            spatialCoderSet = modem.SpatialCoder ( technologyParameters );
            spatialCoderSet.setNumberOfAntennas( modemParameters.NUMBER_OF_ANTENNAS, [] );

            %============== Frame Assembler ===================================
            frameAssemblerSet = modem.FiveGFrameAssembler ( ...
                technologyParameters, ...
                randomStreams{ enum.RandomSeeds.FRAME } );
            frameAssemblerSet.setNumberOfAntennas( modemParameters.NUMBER_OF_ANTENNAS );

            %==================== Scrambler ===================================
            scramblerSet = modem.Scrambler ( randomStreams{ enum.RandomSeeds.FRAME } );


            %=============  Modulator =========================================
            modulationSet = modem.FiveGBlockModulation ( technologyParameters, ...
                frameAssemblerSet );
            modulationSet.setCenterFrequency( modemParameters.CARRIER_FREQUENCY );
            %===================== HARQ =============================
            harqSet = modem.Harq ( technologyParameters.HARQ , technologyParameters.NUMBER_OF_UES, ...
                                   frameAssemblerSet.frameType );
            
            %============ Source ===========================
            sourceSet = source.Source( randomStreams{ enum.RandomSeeds.SOURCE }, ...
                technologyParameters.TRANSPORT_BLOCK_SIZE_BITS, harqSet );
            innerTransceiverSet = modulationSet;
            % =================== Encoder ========================

            channelCodeSet = modem.FiveGEncoder( technologyParameters , ...
			                                     randomStreams{ enum.RandomSeeds.ENCODER }, ...
                                                 harqSet);

        otherwise
            error('The Technology selected for the Modem is not available in the Simulator');
    end


end



% ========================== Rx Sampler ===================================
if rxFlag

    rxSamplerSet = modem.RxSampler( innerTransceiverSet.demodulator.samplingRate , ...
        innerTransceiverSet.demodulator.centerFrequency );
    thermalNoiseSet = channel.Noise( randomStreams{ enum.RandomSeeds.NOISE } );

    innerTransceiverSet.setThermalNoise( thermalNoiseSet );
else
    rxSamplerSet = [];
    thermalNoiseSet = [];
end


% Create the entire Modem Object

this.scrambler = scramblerSet;

this.source = sourceSet;

this.antenna = antennaSet;

this.channelCode = channelCodeSet;

this.mapper = mapperSet;

this.spatialCoder = spatialCoderSet;

this.frameAssembler = frameAssemblerSet;

this.innerTransceiver = innerTransceiverSet;

this.rf = rfSet;

this.rxSampler = rxSamplerSet;

this.thermalNoise = thermalNoiseSet;

this.node = [];

this.harq = harqSet;
end
