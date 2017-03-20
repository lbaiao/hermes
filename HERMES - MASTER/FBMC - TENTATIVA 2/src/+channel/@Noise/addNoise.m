function out = addNoise( this, in, numberOfBits, referenceSignal )
%NOISE.ADDNOISE adds noise to input vector.
%   Detailed description can be found in class header.
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <andre.barreto>@indt.org.br
%   History:
%       v1.0 10 Feb 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

if isempty( this.Eb )
    
    if ~exist('referenceSignal', 'var')
        referenceSignal = in;
    end
    
    % calculate total energy
    energy = real(referenceSignal).^2+imag(referenceSignal).^2;
    for dim = 1:ndims(referenceSignal)
        energy = sum( energy );
    end
    
    currentEb = energy / numberOfBits;
    
    N0 = currentEb / this.EbN0;
else
    N0 = this.Eb/this.EbN0;
end

noise = this.rng.randn(size(in)) + 1i* this.rng.randn(size(in));
noise = noise * sqrt(N0/2);
out = in + noise;

this.variance = N0;

end
        


