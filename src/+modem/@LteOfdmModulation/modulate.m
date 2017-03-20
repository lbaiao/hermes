function serialModulatedSignal = modulate( this, transmittedFrame )
%LTEOFDMMODULATION.MODULATE OFDM frame, cyclic prefix insertion
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

%Set the Subcarrier Freq. Map.
if isempty( this.subcarrierFreqMap )
    numberOfSubcarriers = size( transmittedFrame, 1);
    this.setCarrierFreqMap(numberOfSubcarriers);
end

%Initialize auxiliar vector to perform the FFT:
ifftAuxiliarFrame = zeros(this.fftSize,  size( transmittedFrame, 2 ), size( transmittedFrame, 3 ));
%Initialize output vector:
serialModulatedSignal =  [];

% Calculates the FFT for each Tx Antenna Transmitted Frame:
for txAntenna = 1 : this.numberOfAntennas
    
    ifftAuxiliarFrame( this.subcarrierFreqMap, : , txAntenna) = transmittedFrame( : , : , txAntenna );
    
    ifftAuxiliarFrame( : , : , txAntenna ) =  ifft( ifftAuxiliarFrame( : , : , txAntenna), this.fftSize );
end

% Insert Cyclic Prefix:

for slots = 1 : this.numberOfSlots % For each frame slot perform this calculation:
    %Select only the OFDM symbols that belongs to this slot, in the output of FFT:
    ofdmSymbolsInSlot = ifftAuxiliarFrame( : , ( slots - 1 ) * this.ofdmSymbolsPerSlot + 1 : (slots) * this.ofdmSymbolsPerSlot, : );
    
    % For the first symbol, calculates the CP (longer than the others'):
    cyclicPrefixInFirstSymbol = ofdmSymbolsInSlot( this.fftSize - this.cyclicPrefixLengthFirstSymbol + 1 : this.fftSize , 1 , : ); % First Symbol CP
    firstSymbolWithCyclicPrefix = vertcat(cyclicPrefixInFirstSymbol, ofdmSymbolsInSlot (: , 1 , : )); % First Symbol with CP inserted
    serialSlotFirstSymbol = reshape(firstSymbolWithCyclicPrefix, [], 1, this.numberOfAntennas); % Put 1st symbol in serial form
    
    cyclicPrefixInOtherSymbols = ofdmSymbolsInSlot( this.fftSize - this.cyclicPrefixLength + 1 : this.fftSize , 2:end , : ); % CP for other Slot Symbols
    otherSymbolsWithCyclicPrefix = vertcat(cyclicPrefixInOtherSymbols, ofdmSymbolsInSlot (: , 2:end , : )); % Insert CP in the other Symbols
    serialSlotOtherSymbols = reshape(otherSymbolsWithCyclicPrefix, [], 1, this.numberOfAntennas); % Put other symbols in serial form
    
    serialModulatedSignal = [serialModulatedSignal; serialSlotFirstSymbol; serialSlotOtherSymbols ]; % append the serial slot in the output variable
end

end

