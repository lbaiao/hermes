function rxSignal  = despread( this, signalIn )
%FIVEGBLOCKMODULATION.DESPREAD signal despreading after equalization 
%   Detailed explanation is given in the BlockModulation class header.
%   
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 23 Apr 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been


switch this.waveform
    case enum.modem.fiveG.Waveform.OFDM
        rxSignal = signalIn;
    case enum.modem.fiveG.Waveform.ZT_DS_OFDM
        % despread
        signalIn = ifftshift( signalIn, 1 );
        rxSignal = ifft( signalIn ) * sqrt(size( signalIn, 1 ));

        %eliminate head
        rxSignal( 1:this.samplesInPrefix, : ) = [];
        %eliminate tail
        rxSignal( end - this.samplesInTail + 1 : end, : ) = [];        
    case enum.modem.fiveG.Waveform.FBMC
        % Apply OQAM PostProcessing
        rxSignal = oqamPostProcessing( this, signalIn ); 
    case enum.modem.fiveG.Waveform.FOFDM
        rxSignal = signalIn;        
end


end