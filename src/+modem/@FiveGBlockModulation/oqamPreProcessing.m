function oqamSymbols = oqamPreProcessing ( this, signalIn )
    
    numberOfSymbols = this.frame.numberOfUsefulBlocks;
    M = 2*size(signalIn,1); % numberOfSubchannels;
    
    signalIn = reshape(signalIn,M,numberOfSymbols/2);
    
    % Vetor auxiliar jn para simbolos no tempo
    jn = 1j.^((1:numberOfSymbols)-1);

    oqamSymbols = zeros(M,numberOfSymbols);

    for k = 1:M 
        theta = jn*(1j^(k-1)); % Mantem a ortogonalidade
        if ~mod((k-1),2) % k even
            realAux = upsample(real(signalIn(k,:).'),2).';
            imagAux = circshift(upsample(imag(signalIn(k,:).'),2).',[0,1]);        
        else % k odd
            realAux = circshift(upsample(real(signalIn(k,:)).',2).',[0,1]);
            imagAux = upsample(imag(signalIn(k,:).'),2).';           
        end
        oqamSymbols(k,:) = (realAux+imagAux).*theta; 
    end

end