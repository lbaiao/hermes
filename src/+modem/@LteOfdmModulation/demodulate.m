function frameReceived = demodulate( this, serialReceivedSignal )
%LTEOFDMMODULATION.DEMODULATE demodulates OFDM frame, removes cyclic prefix 
%   Detailed explanation is given in the class header.
%   
%   Author: Rafhael Medeiros de Amorim (RMA), Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br, andre.noll@indt.org
%   History:
%       v1.0 03 Mar 2015 (RMA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been

%Intialize output Matrix
frameReceived  = zeros ( length( this.subcarrierFreqMap ) , this.numberOfSlots * this.ofdmSymbolsPerSlot, this.numberOfAntennas );

for antCount = 1 : this.numberOfAntennas %Receives the frame for each antenna
    
    %Intialize auxiliar vectors
    auxReceivedParallel =  []; %Parallel vector
    auxReceivedSerial = serialReceivedSignal ( :, antCount ) ; %Serial symbol received (only for this antenna)
    %Index to read the Received Serial Signal.
    symbolPointer = 1;
    for slots = 1 : this.numberOfSlots; % Perform the calculation for every slot in the frame:
        symbolPointer = this.cyclicPrefixLengthFirstSymbol + symbolPointer;
        % Isolate 1st Symbol Samples, Removing the CP:
        ofdmFirstSymbol(:,1) = auxReceivedSerial( symbolPointer : this.fftSize + symbolPointer - 1, antCount );
        % Update the index
        symbolPointer = this.fftSize + symbolPointer ;
        
        % Isolate the other slot symbols:
        auxIndexSymbols = ( this.fftSize + this.cyclicPrefixLength ) * ( this.ofdmSymbolsPerSlot - 1 );
        auxiliarMatrixOtherSymbols = auxReceivedSerial ( symbolPointer : symbolPointer + auxIndexSymbols - 1 );
        % Update the index
        symbolPointer = symbolPointer +  auxIndexSymbols;
        % Cyclic Prefix Removal:
        auxiliarMatrixOtherSymbols = reshape( auxiliarMatrixOtherSymbols , this.fftSize + this.cyclicPrefixLength, this.ofdmSymbolsPerSlot - 1, [] );
        ofdmOtherSymbols = auxiliarMatrixOtherSymbols(this.cyclicPrefixLength + 1 : end , :) ;
        %Append the received OFDM Symbols (parallel)
        auxReceivedParallel = [ auxReceivedParallel ofdmFirstSymbol ofdmOtherSymbols ];
    end
    
    % FFT
    auxReceivedFreq = fft( auxReceivedParallel );
    % Ignore Null Subcarriers
    frameReceived( : , : , antCount ) = auxReceivedFreq( this.subcarrierFreqMap, : );
    
end

end