function frameReceived  = demodulate( this, serialReceivedSignal )
%FIVEGBLOCKMODULATION.DEMODULATE demodulates 5G frame 
%   Detailed explanation is given in the BlockModulation class header.
%   
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Bras�lia
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
end

frameReceived  = zeros ( numberOfSubcarriers, ...
                         this.frame.numberOfUsefulBlocks, ...
                         this.numberOfAntennas );

%Receives the frame for each antenna                     
for antCount = 1 : this.numberOfAntennas 

    % eliminate guard periods
    rxSignal = serialReceivedSignal( this.usefulSamplesIndex, antCount );
        % reshape, make each symbol a column
          
                    
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
    
             
    % recover non-null subcarriers
    frameReceived ( :, :, antCount ) = rxSignal( this.subcarrierFreqMap, : );
    


end