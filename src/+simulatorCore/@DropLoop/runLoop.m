function runLoop( this, statistics, scenario )
%DROPLOOP.RUNLOOP runs the main simulation loop.
% Description in class header.
%
%   Author: Erika Portela Lopes de Almeida (EA), Fadhil Firyaguna (FF),
%           Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: erika.almeida@indt.org.br, fadhil.firyaguna@indt.org,
%           andre.noll@indt.org
%   History:
%       v1.0 10 Apr 2015 (EA, FF, ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% initialize stop criteria
metStopCriteria = 0;


% drops loop, until meets all stopping criteria
while ~metStopCriteria

    %%
    % Initialize drop

    % updateDropNumber
    this.currentDrop = this.currentDrop + 1;

    % call the simulator, run the frame loop and the SNR loop.
    % missing
    if this.showProgress
        fprintf('running drop number %d\n', this.currentDrop );
    end
    % find receiving modem ( assuming a single rx modem for whole simulation)
    rxModemIndex = scenario.rxModems;
    rxModem = scenario.modems{ rxModemIndex };

    % initalize time information
    this.timeStamp = 0;
    frameNumber = 0;

    numberOfTxModems = length( scenario.txModems );

    lastDisplay = 0;
    while this.timeStamp < this.dropDuration

        frameNumber = frameNumber + 1;

        rxFrameDuration = rxModem.frameAssembler.duration;

        %%
        % generate signal from all transmit modems
        txSignal = cell( numberOfTxModems );
        channelSignal = cell( numberOfTxModems );
        for modemIndex = 1 : numberOfTxModems

            modem = scenario.txModems( modemIndex );

            txModem = scenario.modems{ modem };
            txFrameDuration = txModem.frameAssembler.duration;
            numberOfFrames = ceil( txFrameDuration / rxFrameDuration );

            % generate enough frames from each transmitter to fill a
            % rx frame
            for frame = 1 : numberOfFrames
                txSignal{modemIndex} = [ txSignal{modemIndex} ...
                                         txModem.transmitFrame() ];
            end
        end



        %% send signal from all transmitters through wireless channels
        for txModemIndex = 1 : numberOfTxModems
            channelTmp.impulseResponse = [];
            channelTmp.samplingInstants = [];
            
            if isempty( txSignal{ txModemIndex } ); continue; end
            
            [ channelSignal{txModemIndex}, ...
              impulseResponse, ...
              samplingInstants ] = ...
                        scenario.channels{txModemIndex, 1}.propagate ...
                            ( txSignal{txModemIndex}, this.timeStamp );

            % store information of desired link
            if rxModem.link == scenario.txModems( txModemIndex )
                channel.impulseResponse = impulseResponse;
                channel.samplingInstants = samplingInstants;

                mainTxSignal = txSignal{ txModemIndex };

            end
        end

        % adjust sampling rate and carrier frequency to the ones of the rx
        % modem
        rxSignalNoNoise = rxModem.rxSampler.resample( channelSignal );

        % get information from desired transmitter
        txModem = scenario.modems{ rxModem.link };
        numberOfTxBits = txModem.source.getNumberOfBits ();

        
        % free some memory
        clear txSignal channelSignal;
        
        %%
        % add noise with different SNR levels
        for snrIndex = 1 : length( this.snrVector )

            % verify if simulation results at given SNR satisfy
            % requirements
            if( ~this.metStoppingCriteriaPerSNR( snrIndex ) )
                %%
                % add noise
                switch this.snrType
                    case enum.snr.Type.EBNO
                        % consider that signalling symbols are also part
                        % of the signal for calculating number of bits
                        numberOfBits = numberOfTxBits / ...
                            txModem.frameAssembler.dataLoad;
                    case enum.snr.Type.EBNO_EFFECTIVE
                        % consider only data bits, but energy will be
                        % calculated for whole frame
                        numberOfBits = numberOfTxBits;
                    otherwise
                        error( 'invalid SNR type');
                end

                % change Eb/N0
                rxModem.thermalNoise.setEbN0_dB (this.snrVector( snrIndex ));

                % Add thermal noise, note that Eb is calculated based on the
                % transmitted signal
                rxSignal = rxModem.thermalNoise.addNoise( rxSignalNoNoise, ...
                                                          numberOfBits, ...
                                                          mainTxSignal );

                %%
                
                
                % receive and demodulate signal
                detectedBits = rxModem.receiveFrame( rxSignal, channel );

                linkTxModem = scenario.modems{ rxModem.link };
                source = linkTxModem.source;

                % calculate number of errors and update statistics
                [ bitErrors,...
                  packetErrors, ...
                  throughput ] = source.calculateErrors( detectedBits );

                statistics.addNewFrameStats( snrIndex, bitErrors, ...
                            source.getNumberOfBits(), packetErrors, ...
                            source.numberOfPackets, throughput );
                        
   
            end
        end
        
        
        this.timeStamp = this.timeStamp + rxFrameDuration;
        
        if this.showProgress && ...
           this.timeStamp - lastDisplay >= this.displayInterval
            
            fprintf('\tframe %d, time stamp = %f\n', frameNumber, ...
                this.timeStamp );
            lastDisplay = lastDisplay + this.displayInterval;
        end
    end

    %%
    % wrap up Drop
    statistics.updateDrop( this.timeStamp );

    % After this drop is complete, check which SNR indexes have met the
    % stopping criteria
    stopCriteriaValue = this.checkAllStoppingCriteria( statistics );

    % check if the stop criteria was found for all values of SNR
    metStopCriteria = prod( stopCriteriaValue );
    
    % Reset all frame Counts to 0.
    scenario.resetScenario();
end
