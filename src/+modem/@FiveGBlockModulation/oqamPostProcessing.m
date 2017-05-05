function qamDemodSymbols = oqamPostProcessing (this, oqamSymbols )    

    numberOfSymbols = this.frame.numberOfUsefulBlocks/2;
    M = size(oqamSymbols,1); % numberOfSubchannels;

    demodAux = zeros(M,2*numberOfSymbols); % auxiliar matrix
    oqamInput = zeros(M,2*numberOfSymbols); % auxiliar matrix
    
    this.prototypeFilter.sumFactor = sum( conv...
    (this.prototypeFilter.polyphaseSynthesisFilter(1,:), ...
    this.prototypeFilter.polyphaseAnalysisFilter(1,:)));
    
    jn= (-1j).^((1:2*numberOfSymbols)-1); % (-j)^n

    for k=1:M

        theta = jn*(-1j)^(k-1);
        oqamInput(k,:) =  real(oqamSymbols(k,:).*theta);
        if ~mod((k-1),2) % even k
            demodAux(k,:) = oqamInput(k,:).*repmat([1 1j],1,numberOfSymbols);
        else % odd k
            demodAux(k,:) = oqamInput(k,:).*repmat([1j 1],1,numberOfSymbols);
        end
    end

    for k=1:M
        qamDemodSymbols(k,:)= (1/this.prototypeFilter.sumFactor) * ...
        (demodAux(k,1:2:2*this.frame.numberOfUsefulBlocks/2-1) + ...
        demodAux(k,2:2:2*this.frame.numberOfUsefulBlocks/2));
    end
    
    %for l=1:numberOfSymbols
    %    demodulatedSymbols(:,l) = demodAux(:,2*l-1)+demodAux(:,2*l);
    %end
    qamDemodSymbols = reshape(qamDemodSymbols,M/2,2*numberOfSymbols);
    
end