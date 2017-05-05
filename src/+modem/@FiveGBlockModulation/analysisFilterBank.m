function [receivedSymbols,polyphaseAnalysisFilter] = analysisFilterBank (this,signalIn)

numOfOqamSymbols = this.frame.numberOfUsefulBlocks;
h = this.prototypeFilter.filter;
K = this.prototypeFilter.filterParameters.K;
M = this.prototypeFilter.filterParameters.M;
Lp = this.prototypeFilter.filterParameters.Lp;

% Initialize Arrays
receivedInphase = zeros(M,K+ceil(numOfOqamSymbols/2)-1); % Inphase received symbols
receivedQuadrature = zeros(M,K+floor(numOfOqamSymbols/2)-1); % Quadrature received symbols

ppOutput1 = zeros(M,K+ceil(numOfOqamSymbols/2)-1+K-1); % output of PPN1 
ppOutput2 = zeros(M,K+floor(numOfOqamSymbols/2)-1+K-1); % output of PPN2
fftInput = zeros(M,size(ppOutput1,2)+size(ppOutput2,2)); % FFT Input
polyphaseAnalysisFilter = zeros(M,K); % Polyphase Analysis Filter


% Reshaping (joint implementation of delay chain & downsamplers)
receivedInphase = reshape(signalIn(1:end-M/2),M,(K+ceil(numOfOqamSymbols/2)-1));
receivedQuadrature = reshape(signalIn(M/2+1:end),M,(K+floor(numOfOqamSymbols/2)-1));

for k=1:M
    polyphaseAnalysis = h(M-k+1:M:Lp+1); % related polyphase filter coefficients sieved
    ppOutput1(k,:) = conv(receivedInphase(k,:),polyphaseAnalysis);
    ppOutput2(k,:) = conv(receivedQuadrature(k,:),polyphaseAnalysis);
    polyphaseAnalysisFilter(k,:) = polyphaseAnalysis;
end

fftInput(:,1:2:end)=ppOutput1;
fftInput(:,2:2:end)=ppOutput2;

fftOutput = fft(fftInput);

% Beta Factor
for k = 1:M
    %for prototype filters of length KM-1
    beta = ((-1).^((k-1)*(1:size(fftOutput,2))))*((-1).^((k-1)*K)); 

    betaArray(k,:)=beta;

    % ifft input is oqam_m on kth subchannel multiplied by beta multiplier
    % on that subchannel, in accordance with the order of the OQAM
    % subsymbol
    receivedSymbols(k,:)= fftOutput(k,:).*beta;
end

end