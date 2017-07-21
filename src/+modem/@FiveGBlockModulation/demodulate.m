   function frameReceived  = demodulate( this, serialReceivedSignal )
%FIVEGBLOCKMODULATION.DEMODULATE demodulates 5G frame 
%   Detailed explanation is given in the BlockModulation class header.
%   
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 23 Apr 2015 (ANB) - created
%
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been

%Intialize output Matrix
switch this.waveform
    case enum.modem.fiveG.Waveform.OFDM
        numberOfSubcarriers = this.frame.blockSize;
    case enum.modem.fiveG.Waveform.ZT_DS_OFDM
        numberOfSubcarriers = this.frame.blockSize + this.samplesInPrefix + ...
                              this.samplesInTail;
    case enum.modem.fiveG.Waveform.FBMC
        numberOfSubcarriers = 2 * this.frame.blockSize;
    case enum.modem.fiveG.Waveform.FOFDM
        numberOfSubcarriers = this.frame.blockSize;        
end

frameReceived  = zeros ( numberOfSubcarriers, ...
                         this.frame.numberOfUsefulBlocks, ...
                         this.numberOfAntennas );
%RF Impairments object %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rf = modem.RFImpairments;

%Receives the frame for each antenna                     
for antCount = 1 : this.numberOfAntennas 

    % eliminate guard periods
    rxSignal = serialReceivedSignal( this.usefulSamplesIndex, antCount );
    
    
    %IQ Imbalance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(this.rfImpairments.IQ.ENABLE)
        rxSignal = rf.IQImbalance(rxSignal, ...
                       this.rfImpairments.IQ.AMP, this.rfImpairments.IQ.PHASE);        
    end
    
    % reshape, make each symbol a column
        
     % Phase noise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     if(this.rfImpairments.PHASE_NOISE.ENABLE)
         rxSignal = rf.phaseNoise(rxSignal, this.rfImpairments.PHASE_NOISE.VARIANCE); 
     end          
                              
        if this.waveform == enum.modem.fiveG.Waveform.OFDM
            % remove cyclic prefix
            rxSignal = reshape( rxSignal, this.samplesInSymbol, ...
                                this.frame.numberOfUsefulBlocks );
            rxSignal(  1 : this.samplesInPrefix, : ) = [];
            rxSignal = fft( rxSignal );
        end
        
        if this.waveform == enum.modem.fiveG.Waveform.ZT_DS_OFDM
            rxSignal = reshape( rxSignal, this.samplesInSymbol, ...
                                this.frame.numberOfUsefulBlocks );
            rxSignal = fft( rxSignal );
        end
        
        if this.waveform == enum.modem.fiveG.Waveform.FBMC   
            [ rxSignal, ...
              this.prototypeFilter.polyphaseAnalysisFilter ] = ...
              analysisFilterBank( this, rxSignal ); 
               % Remove Filter Delays
               rxSignal = rxSignal(:,2*this.prototypeFilter.filterParameters.K ...
               -1:end-(2*this.prototypeFilter.filterParameters.K-1)+1);
        end
        
        if this.waveform == enum.modem.fiveG.Waveform.FOFDM
            % passing the recovered signal through the filter
            rxSignal = conv(rxSignal, this.fofdmFilterInTime); % filtering
            rxSignal = rxSignal(this.fftSize/2+2:length(rxSignal)-this.fftSize/2+2); % removing the expanded samples after filtering
            
            % remove cyclic prefix
            rxSignal = reshape( rxSignal, this.samplesInSymbol, ...
                                this.frame.numberOfUsefulBlocks );
                            
            rxSignal(  1 : this.samplesInPrefix, : ) = [];
            
            
            rxSignal = fft( rxSignal );        
        end
             
    % recover non-null subcarriers
    frameReceived ( :, :, antCount ) = rxSignal( this.subcarrierFreqMap, : );
    


end