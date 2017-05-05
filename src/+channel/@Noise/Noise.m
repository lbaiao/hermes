classdef Noise < handle
%NOISE class adds complex white gaussian noise to an input signal
%   This class defines objects that will add white gaussian noise to a
%   given multidimensional input signal.
%
%   Read-Only Public Properties:
%       EbN0 - <1 x 1 double> bit-energy (Eb) to noise-PSD (N0) ratio in
%              linear scale.
%       EbN0_dB - <1 x 1 double> (dB) bit-energy (Eb) to noise-PSD (N0)
%                 ratio.
%
%   Public Methods
%   Constructor
%       Syntax 1: this = channel.Noise( rndgen, ebn0_dB, Eb ), if bit
%             energy is known a priori.
%       Syntax 2: this = channel.Noise( rndgen, ebn0_dB ), if bit energy
%             should be calculated each time noise is added to a signal.
%       Syntax 3: this = channel.Noise( rndgen ), initializes Eb/N0 as
%             0 dB, value can be changed later.
%       Input:
%             rndgen - <1 x 1 RandStream> random number generator
%             ebn0_dB - <1 x 1 double>(dB) bit-energy (Eb) to noise-PSD
%                       (N0) ratio. If left empty, a value of 0dB will be
%                       assumed.
%             Eb - <1 x 1 double> (J) bit energy (if known a priori).
%
%   addNoise
%       Syntax 1: [ out ] = addNoise( in ) 
%       	Adds noise to matrix/tensor 'in' with dimensions ( N x M x ...)
%       	considering the bit energy set at construction. It will fail if
%           Eb was not previously set. Noisy vector will be output at 'out'.
%       Syntax 2: [ out ] = addNoise( in, numberOfBits ) 
%           Adds noise to vector 'in' considering its own average bit
%           energy, considering that 'numberOfBits' bits are transmitted in
%           this vector.
%       Syntax 3: [ out ] = addNoise( in, numberOfBits, referenceSignal )
%           Adds noise to vector 'in' considering the average bit energy in
%           'referenceSignal'.
%       Input:
%           in - <N x M x ... complex> : Matrix/tensor input.
%           out - <N x M x ... complex> : Noisy vector.
%           numberOfBits - <1x1 positive integer> : Number of bits
%               transmitted in the vector 'in'.
%           referenceSignal - <N x M x ... complex> : Average bit energy in
%               reference signal.
%
%   setEbN0_dB
%       Syntax: setEbN0_dB( ebn0_dB )
%           Sets the 'EbN0_dB' property.
%       Input:
%           ebn0_dB - <1 x 1 double> (dB) bit-energy (Eb) to noise-PSD
%                     (N0) ratio.
%
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

    properties ( GetAccess = 'public', SetAccess = 'protected' )
        
        EbN0_dB;
        EbN0;
        variance;
        
    end
        
    properties (Access = 'protected')

        rng; % random number generator
        Eb; %Bit energy
        
    end
    
    methods (Access = 'public')
        %%
        % constructor
        function this = Noise( rndgen,... 
                               ebn0_dB, ...
                               Eb )
            
            if exist('ebn0_dB', 'var') && ~isempty(ebn0_dB)
                if ~isreal(ebn0_dB) || length(ebn0_dB) > 1
                    error('invalid EbN0_dB value')
                end
                this.EbN0_dB = ebn0_dB;
            else
                this.EbN0_dB = 0;
            end
            
            this.EbN0 = 10^(this.EbN0_dB/10); 
                           
            this.rng = rndgen;
            
            if exist('Eb','var')
                if ~isreal(Eb) || length(Eb) > 1 || Eb <= 0
                    error('invalid Eb value')
                end
                this.Eb = Eb;
            else
                this.Eb = [];
            end
                     
            this.variance = [];
            
        end
        % end constructor
        
        %%
        out = addNoise( this, in, numberOfBits, referenceSignal );   
        setEbN0_dB( this, ebn0_dB )
        
    end
    
    
end

