function setCarrierFreqMap( this, numberOfSubcarriers )
%LTEOFDMMODULATION.SETCARRIERFREQMAP sets downsampling factor & FFT size
%   Detailed explanation is given in the class header.
%
%   Author: Rafhael Medeiros de Amorim (RMA)
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v1.0 03 Mar 2015 (RMA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been

if ~exist('numberOfSubcarriers', 'var')
    
    error (' Missing numberOfCarriers in SETFFTSIZE operation for LTE Modulator')
    
else
    this.downsamplingFactor = 2 ^ ( log2 ( this.fftMaxSize ) - ...
        ceil ( log2 ( numberOfSubcarriers ) ) );  %Downsampling Factor
    this.fftSize = this.fftMaxSize / this.downsamplingFactor; % Modulator FFT Size
    this.cyclicPrefixLength = this.cyclicPrefixLength / this.downsamplingFactor; %Downsampling CP Samples
    this.cyclicPrefixLengthFirstSymbol = this.cyclicPrefixLengthFirstSymbol / this.downsamplingFactor;
    this.samplingRate = this.samplingRate / this.downsamplingFactor;
    
end

%Map the subcarriers into Frame Frequencies
auxFreqShift = numberOfSubcarriers / 2 ;
this.subcarrierFreqMap = [ this.fftSize - auxFreqShift + 1 : this.fftSize , 2 : auxFreqShift + 1  ];


end