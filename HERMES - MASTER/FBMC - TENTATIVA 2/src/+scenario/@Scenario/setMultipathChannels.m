function setMultipathChannels( this, channelParams, txSamplingRate, ...
                               channelUpdatePeriod, randomStreams )
% SCENARIO.SETMULTIPATHCHANNELS a channel to a tx/rx pair.
%       Further description is given in the class header.
%
%   Authors:
%       Rafhael Medeiros de Amorim (RA)
%   
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v1.0 26 Mar 2015 (RA) - Created

numOfTxModems = length( this.txModems );
numOfRxModems = length( this.rxModems );

channelType = channelParams.MODEL;

txList = this.txModems;
rxList = this.rxModems;
% Set Node Parameters
for txCount = 1 : numOfTxModems
    % Antenna Array for Tx:
    txAntenna = this.modems{ txList ( txCount ) }.antenna;
    % Tx Sampling Rate
    samplingRate = txSamplingRate( txCount );
    for rxCount = 1 : numOfRxModems
        % Antenna Array for Rx:
        rxAntenna = this.modems{ rxList ( rxCount ) }.antenna;

        switch channelType
            case enum.channel.MultipathModel.NONE %Unitary Channel
                this.channels{txCount, rxCount } =  ...
                    channel.Channel( txAntenna, rxAntenna, ...
                        randomStreams{ enum.RandomSeeds.MULTIPATH_MODEL }, ...
                        samplingRate );
            
            case enum.channel.MultipathModel.GENERIC
                this.channels{txCount, rxCount } = ...
                    channel.FadingChannel( txAntenna, rxAntenna, ...
                        randomStreams{ enum.RandomSeeds.MULTIPATH_MODEL }, ...
                        samplingRate, channelUpdatePeriod, ...
                        channelParams.GENERIC.DOPPLER, ...
                        channelParams.GENERIC.DELAYS_S, ...
                        channelParams.GENERIC.POWER_DELAY_PROFILE_DB, ...
                        channelParams.GENERIC.K_RICE_DB );

            case enum.channel.MultipathModel.COST259
                this.channels{txCount, rxCount } = ...
                    channel.Cost259FadingChannel( txAntenna, rxAntenna, ...
                        randomStreams{ enum.RandomSeeds.MULTIPATH_MODEL }, ...
                        samplingRate, channelUpdatePeriod, ...
                        channelParams.COST259.DOPPLER, ...
                        channelParams.COST259.TYPE );
                    
            otherwise
                error('Selected Multipath model is not available or no Multipath Model Assigned');
        end

    end

end

end

