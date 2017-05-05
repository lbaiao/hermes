classdef Scenario < handle
% SCENARIO implements Hermes simulation scenario.
% This class calls node and modem constructors according to parameter
% files.
%
%   Read-Only Public Properties
%       nodes < 1 X N networkEntity.Node > - vector containing
%           networkEntity.Node objects. The number of nodes is defined
%           in simulation scenario.
%       modems <  1 x P modem.Modem > - Vector Containing all modems
%           created for the simulation environment.
%       txModems < 1 x Mtx int > - contain the modem position in the modems
%           array for all Mtx transmitting modems
%       txModems < 1 x Mrx int > - contain the modem position in the modems
%           array for all Mrx receiving modems
%       channels < Mtx x Mrx Channel> - Contains channel Objects for each
%         link.
%
% METHODS
%   Constructor:
%       Syntax: this = scenario.Scenario( SETTINGS , randomStreams )
%       Inputs: SETTINGS struct containing Scenario Parameters
%               randomStreams: Struct with randomStreams objects.
%               Different objects (seeds) used for:
%               *Noise Channel objects
%               *Multipath Channel objects
%               *Source Objects
%               *Frame Assembler Objects
%
%     setScenarioNodes
%       This method creates scenario nodes
%       Syntax: setScenarioNodes( nodesInfo );
%       Inputs: nodesInfo < struct >: node settings for all nodes
%                   POSITION
%                   VELOCITY
%                   * See nodes constructor for further description on
%                   Nodes Attributes.
%
%    setMultipathChannels
%       This method assigns a channel to a tx-rx pair
%       Syntax: setMultipathChannels( channelParams, samplingRate,
%                                     channelUpdatePeriod, randomStream);
%       Inputs: channelParams < struct >: struct containing the channel
%               parameters
%               samplingRate < 1 x N double>: Sampling rate for each of
%                   N transmitters in scenario
%               channelUpdatePeriod < double > : period at which channel
%                   impulse response is reported
%               randomStream < RandStream >: random number generator
%
%   resetScenario
%       Resets Scenario Parameters for a new Simulation Drop.
%       Syntax: resetScenario()
%
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v1.0 16 Mar 2015 (RA) - created
%       v1.1 25 Apr 2015 (RA) - Modems objects are no longer attributes of
%       nodes. Nodes are now attributes of Modems.
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    properties ( GetAccess = 'public', SetAccess = 'protected' )
        
        nodes
        modems
        rxModems
        txModems
        channels

    end

    methods
        %% Class constructor

        function this = Scenario( SETTINGS , randomStreams )
            % Initialize rxModems:
            this.rxModems = [];
            % Initialize txModems:
            this.txModems = [];
            % Tx Sampling Rate and Tx Center Frequency ( Temporary
            % variables) - Used to build rxSampler
            txCenterFreq = [];
            txSamplingRate = [];
            % Get the number of elements in Scenario:
            numOfModems = length( SETTINGS.SCENARIO.MODEM );

            %% Set Scenario Nodes
            this.setScenarioNodes( SETTINGS.SCENARIO.NODE );

            % Load Parameters Table for all Hermes Technologies in order to
            % perform Parameters Consistency check
            lteParamTable = parameterCheck.loadLteParametersTable;
            fiveGParamTable = parameterCheck.loadFiveGParametersTable;
            
            %% 
            % First create all transmit modems
            for modemCount = 1: numOfModems
                %Check if this Modem is not one of simulation's receivers.
                rxIndex = ...
                    find( SETTINGS.SCENARIO.MAIN.RX_MODEMS == modemCount, 1 );

                if isempty(rxIndex) %If this is a TX Modem:

                    % Identify the placement (node and modem) of this Modem
                    % in scenario:
                    this.txModems = [this.txModems, modemCount];
                    rxFlag = false;
                    
                    % create transmission modem
                    modemParameters =  SETTINGS.SCENARIO.MODEM{ modemCount };
                    
                    switch SETTINGS.SCENARIO.MODEM{ modemCount }.TECHNOLOGY
                        case enum.Technology.LTE_OFDMA
                            fieldName = 'LTE';
                            checkTechParam = @parameterCheck.lteCheckParameters;
                            techParamTable = lteParamTable;
                        case enum.Technology.FIVEG
                            fieldName = 'FIVEG';
                            checkTechParam = @parameterCheck.fiveGCheckParameters;
                            techParamTable = fiveGParamTable;
                        otherwise
                            error('Technology not supported')
                    end
                    techParams = SETTINGS.( fieldName );
                    
                    % eventually override technology parameters
                    if isfield(modemParameters, fieldName)
                        fields = fieldnames( modemParameters.(fieldName) );
                        
        
                        for fieldCount = 1 : length( fields )
                            techParams.(fields {fieldCount}) = ...
                                modemParameters.(fieldName).(fields{fieldCount});
                        end
                    end
                    
                    techParams = checkTechParam( techParams, techParamTable );
                    
                    newModem = modem.Modem( modemParameters, ...
                                            techParams, randomStreams, ...
                                            rxFlag );
                                        
                    % Assign Node Info to this Node:
                    nodeIndex = modemParameters.NODE;
                    newModem.setNode( this.nodes{ nodeIndex } );
                                        
                    % Assign this Modem to the Scenario.
                    this.modems{ modemCount } = newModem;

                    txCenterFreq = [ txCenterFreq ...
                        newModem.innerTransceiver.centerFrequency ];
                    txSamplingRate = [ txSamplingRate ...
                        newModem.innerTransceiver.samplingRate];

                    %Check if this Modem is one of simulation's transmitters...
                    linkNumber = ...
                        find( SETTINGS.SCENARIO.MAIN.TX_MODEMS == ...
                              modemCount, 1 );
                    % ... if so, then store its value in a temporary variable.
                    if ~isempty ( linkNumber )
                        txModemLink( linkNumber ) = modemCount;
                    end
                    
                end



            end

            %%
            % Now create all receive modems
            channelUpdatePeriod = inf;
            
            for modemCount = 1: numOfModems
                %Check if this Modem is one of simulation's receivers.
                linkNumber = ...
                    find( SETTINGS.SCENARIO.MAIN.RX_MODEMS == modemCount, 1 );    
                
                if ~isempty( linkNumber )
                    
                    rxFlag = true;
                    
                    this.rxModems = [ this.rxModems modemCount ];
                    
                 
                    txModem = txModemLink( linkNumber );
                    
                    % create modem with same parameters as transmit modem
                    modemParameters =  SETTINGS.SCENARIO.MODEM{ modemCount };
                    newModem = modem.Modem( modemParameters, ...
                                            this.modems{ txModem }, ...
                                            randomStreams, ...
                                            rxFlag );
                                        
                                        
                    % Assign Sampling Rates and Center Freq to Rx Sampler:
                    newModem.rxSampler.setTxSamplingRate ( txSamplingRate, ...
                                                          txCenterFreq );
                                        
                    % Assign Node Info to this Node:
                    nodeIndex = modemParameters.NODE;
                    newModem.setNode( this.nodes{ nodeIndex } );

                    newModem.setLink( txModem );
                    this.modems{ txModem }.setLink( modemCount );
                                                        
                    % Assign this Modem to the Scenario.
                    this.modems{ modemCount } = newModem;                    
                    
                    numberOfSymbols = ...
                        newModem.frameAssembler.numberOfBlocks;
                    channelUpdatePeriod = min( channelUpdatePeriod, ...
                        newModem.frameAssembler.duration / numberOfSymbols );
                end
            end
            

            %% Assign Channel Objects for scenario
            this.setMultipathChannels( SETTINGS.CHANNEL.MULTIPATH, ...
                                       txSamplingRate, channelUpdatePeriod, ...
                                       randomStreams );

        end

        setScenarioNodes( this, nodesInfo );
        setMultipathChannels( this,  channelModel, samplingRate, ...
                              channelUpdatePeriod, randomStreams);
        resetScenario( this );
    end
end
