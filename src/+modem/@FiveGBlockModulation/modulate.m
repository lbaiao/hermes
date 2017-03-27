function modulatedSignal = modulate( this, transmittedFrame )
%FIVEGBLOCKMODULATION.MODULATE block modulation frame, 
%   Detailed explanation is given in the BlockModulation class header.
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v2.0 22 Apr 2015 (AB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been

if (this.numberOfAntennas > 1)
    error('number of antennas not supported')
end

% initialize frame
modulatedSignal = zeros( this.samplesInFrame, this.numberOfAntennas );

              
% perform modulation
switch this.waveform
    case enum.modem.fiveG.Waveform.OFDM
        % map frame to FFT
        signalInFreq = zeros( this.fftSize, ...
                              this.frame.numberOfUsefulBlocks );
        signalInFreq( this.subcarrierFreqMap, :, : ) = transmittedFrame;

        % apply IFFT and add cyclic prefix
        signalInTime = ifft( signalInFreq );
        signalInTime = [ signalInTime( end - this.samplesInPrefix + 1 : end, : ); ...
                         signalInTime ];
        signalInTime = reshape( signalInTime, numel( signalInTime ), 1 );
    case enum.modem.fiveG.Waveform.ZT_DS_OFDM
        usefulSamples = this.frame.numberOfUsefulBlocks;
        % include zero tail and head
        transmittedFrame = [ zeros( this.samplesInPrefix, usefulSamples ); ...
                             transmittedFrame; ...
                             zeros( this.samplesInTail, usefulSamples ) ];

        % apply DFT-spread (and normalize)
        transmittedFrame = fft( transmittedFrame ) / ...
                           sqrt( size( transmittedFrame, 1 ) );
        transmittedFrame = fftshift( transmittedFrame, 1 );
                         
        signalInFreq = zeros( this.fftSize, ...
                              this.frame.numberOfUsefulBlocks );
        signalInFreq( this.subcarrierFreqMap, :, : ) = transmittedFrame;
        
        % apply IFFT                 
        signalInTime = ifft( signalInFreq );
        signalInTime = reshape( signalInTime, numel( signalInTime ), 1 );
    
    case enum.modem.fiveG.Waveform.FBMC
        
        oqamSignal = oqamPreProcessing( this, transmittedFrame );

        signalInFreq = zeros( this.fftSize, ...
                              this.frame.numberOfUsefulBlocks );
        signalInFreq( this.subcarrierFreqMap, :, : ) = oqamSignal;
                
        % apply Filtering
        [ signalInTime, ...
          this.prototypeFilter.polyphaseSynthesisFilter ] = ...
          synthesisFilterBank( this, signalInFreq );
      
        signalInTime = reshape( signalInTime, numel( signalInTime ), 1 );
    
    %FOFDM implementation incomplete. The code below is just a copy of the OFDM implementation    
    case enum.modem.fiveG.Waveform.FOFDM 
        % map frame to FFT
        signalInFreq = zeros( this.fftSize, ...
                              this.frame.numberOfUsefulBlocks );
        signalInFreq( this.subcarrierFreqMap, :, : ) = transmittedFrame;

        % apply IFFT and add cyclic prefix
        signalInTime = ifft( signalInFreq );
        signalInTime = [ signalInTime( end - this.samplesInPrefix + 1 : end, : ); ...
                         signalInTime ];
        
        signalInTime = reshape( signalInTime, numel( signalInTime ), 1 );
        
        % Plotting the signal's spectrum===================================
        %signalSpec1 = fft(signalInTime);
        %signalSpec1 = fftshift(signalSpec1);
       
        
        % Passing the signal through the filter
        y = this.fftSize/2;
        signalInTime = conv(signalInTime, this.fofdmFilterInTime); % Filtering
        
        %largeSpec = fft(signalInTime);
        %largeSpec = fftshift(largeSpec);
        %x = [0:length(largeSpec) - 1];
        %subplot(2, 1, 1);
        %plot(x, signalInTime);
        
        signalInTime = signalInTime(y:length(signalInTime)-y); %===========================================
        
        % ========================================
        [signalSpec, f] = pwelch(signalInTime, [], [], this.fftSize, this.samplingRate);
        %f = [0:length(signalSpec) - 1];
        plot(f, signalSpec);
        
        %signalSpec2 = fft(signalInTime);
        %signalSpec2 = fftshift(signalSpec2);
        %freqs = [0:length(signalSpec2)-1];
        %hold on
        %subplot(2, 1, 2); 
        %plot(freqs, signalSpec2, 'r');
        display('Espectro!');
        
end


% include useful data in frame
modulatedSignal( this.usefulSamplesIndex, : ) = signalInTime;


             


