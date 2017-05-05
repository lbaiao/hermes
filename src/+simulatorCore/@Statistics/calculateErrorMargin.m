function [ sampleMean, errorMargin ] = calculateErrorMargin( this, ...
                                                             sampleValues )
% STATISTICS.CALCULATEERRORMARGIN calculates mean and error margin.
%  This method assumes a t-student distribution for given samples, and based
%  on the requirements of confidence interval and the number of samples, it 
%  estimates the error margin. Reference: 
%  Driels and Shin, "DETERMINING THE NUMBER OF ITERATIONS FOR MONTE CARLO 
%  SIMULATIONS OF WEAPON EFFECTIVENESS," Naval PostGraduate School, April
%  2004 ( NPS-MAE-04-005 ) 
%  http://www.dtic.mil/dtic/tr/fulltext/u2/a423541.pdf
%
%   Syntax: [ sampleMean, errorMargin ] = calculateErrorMargin( sampleValues )
%
%   Inputs:
%       sampleValues < 1 X Nsamps double > - vector containing given metric
%           at different drops. Nan samples are not considered.
%
%   Outputs:
%       sampleMean< double > - sample mean
%       errorMargin < double > - relative error margin
%
%   Author: Erika Almeida (EA), Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: erika.almeida@indt.org.br, andre.noll@indt.org
%   History:
%       v1.0 08 Apr 2015 - (EA,ANB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


sampleValues( isnan( sampleValues ) ) = [];
numberOfSamples = length( sampleValues );

% calculate sample mean
sampleMean = mean( sampleValues );

if numberOfSamples < 2
    errorMargin = inf;
    return
end

% calculate sample variance
sampleVariance = var( sampleValues );

% calculate degrees of freedom
degreesOfFreedom =  numberOfSamples - 1;

% get margin, considering a t-student distribution with
% degreesOfFreedom
margin = -tinv(  ( 1 - this.confidenceLevel ) ./ 2, degreesOfFreedom );

% get error margin
errorMargin = margin * sqrt( sampleVariance ) / ...
              sampleMean / sqrt( numberOfSamples );


end
