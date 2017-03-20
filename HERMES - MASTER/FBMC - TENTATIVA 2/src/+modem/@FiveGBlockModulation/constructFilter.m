function [filter,filterParameters] = constructFilter (this, overlappingFactor)

filterParameters.K = overlappingFactor; % overlappingFactor (2,3 or 4)
filterParameters.M = this.fftSize;
filterParameters.Lp = filterParameters.K*filterParameters.M-1; % filter length
filterParameters.Delay = filterParameters.K*filterParameters.M+1-filterParameters.Lp; %delay requirement

% Prototype filter frequency coefficients
% K will select the row
P=[ zeros(1,4); ...
    1 sqrt(2)/2 0 0; ...
    1 .911438 .411438 0; ...
    1 .97195983 sqrt(2)/2 .23514695];

filter = zeros(1,filterParameters.Lp);

for m=1:filterParameters.Lp
    filter(m) = P(filterParameters.K,1);
    for k = 1:(filterParameters.K-1)
        filter(m) = filter(m) + 2*(((-1)^k)*P(filterParameters.K,k+1)*cos((2*pi*k*m)/(filterParameters.K*filterParameters.M)));
    end
end

%normalization of coefficients
norm = P(filterParameters.K,1)+2*sum(P(filterParameters.K,2:4));
filter=filter/norm; %normalization

% Delay changes 
if filterParameters.Delay > 1
    filter = [0 filter 0];
    filterParameters.Delay = filterParameters.Delay - 1;
end