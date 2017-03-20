function [modulatedSymbols,polyphaseSynthesisFilter] = synthesisFilterBank(this, signalIn)

    numOfSymbols = size(signalIn,2);
    h = this.prototypeFilter.filter;
    K = this.prototypeFilter.filterParameters.K;
    M = this.prototypeFilter.filterParameters.M;
    Lp = this.prototypeFilter.filterParameters.Lp;

    % Initialize Arrays
    %modulatedSymbols = zeros(1,K*M+(numOfSymbols-1)*M/2); % Time signal output
    %ifftInput = ones(M,numOfSymbols); % IFFT Input
    polyphaseSynthesisFilter = zeros(M,K); % Polyphase Synthesis Filter

    % Beta Factor
    for k = 1:M
        %for prototype filters of length KM-1
        beta = ((-1).^((k-1)*(1:numOfSymbols)))*((-1).^((k-1)*K)); 

        betaArray(k,:)=beta;

        % ifft input is oqam_m on kth subchannel multiplied by beta multiplier
        % on that subchannel, in accordance with the order of the OQAM
        % subsymbol
        ifftInput(k,:)= signalIn(k,:).*beta;
    end

    ifftOutput = ifft(ifftInput);

    for k=1:M

        polyphaseSynthesis = h(k:M:Lp+1);

        ppInphase(k,:) = conv(polyphaseSynthesis,ifftOutput(k,1:2:numOfSymbols)); % 1st PPN
        ppQuadrature(k,:) =conv(polyphaseSynthesis,ifftOutput(k,2:2:numOfSymbols)); % 2nd PPN

        polyphaseSynthesisFilter(k,:) = polyphaseSynthesis;

    end

    % Polyphase delay

    % Reshaping (joint implementation of delay chain & upsamplers)
    outputInphase = reshape(ppInphase,1,M*(K+ceil(numOfSymbols/2)-1));
    outputQuadrature = reshape(ppQuadrature,1,M*(K+floor(numOfSymbols/2)-1));
    outputInphase = [outputInphase zeros(1,M/2)];
    outputQuadrature = [zeros(1,M/2) outputQuadrature];

    % Sumation and output time vector
    modulatedSymbols = outputInphase+outputQuadrature;
    

end