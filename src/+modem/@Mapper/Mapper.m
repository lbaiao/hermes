classdef Mapper < handle
%MAPPER class defines the modulation mapper for different technology types.
%   This class defines the common properties and methods for mapper
%   according to a given constellation. Specific constellations and
%   optimized algorithms for different technologies can be defined inside
%   sub-classes.
%
%   Properties:
%
%       symbolAlphabet - cell array of < 1 x M complex-values > : defines
%               the symbol alphabet for each modulation type. Orientation
%               is MSB to the left. M is the constellation size. Each
%               element of the cell array corresponds to a different
%               modulation order. The index of the cell array corresponds
%               to the number of bits per symbol n = log2 M.
%       modulationOrder < integer > : current modulation order (must
%               be available in alphabet).
%       llrMethod < 1 x enum.modem.LlrMethod> : defines the method used to
%               calculate LLR as defined at enum.modem.LlrMethod
%
%   Methods:
%   Constructor
%       Syntax: this = modem.Mapper( alphabet, modulationOrder )
%       	Creates an instance of mapper class with a given alphabet,
%           using a particular modulation order.
%
%   map
%       Syntax: [ modulatedSignal ] = map( bits2Transmit )
%       	Takes binary digits, 0 or 1, as input and produces
%       	complex-valued modulation symbols, x = I + j * Q, as output.
%       Inputs:
%       	bits2Transmit < 1 x N binary > : defines the set of bits to be
%               transmitted.
%       Outputs:
%       	modulatedSignal < 1 x K complex > : modulation symbols,
%                        x = I + j * Q, K is the number of symbols,
%                        K = N / log2(modulationOrder). If N is not a
%                        multiple of log2(modulationOrder), then padding
%                        bits are added.
%
%   calculateLlr
%   	Syntax 1: [ receivedLlr ] = calculateLlr( receivedSymbols, ...
%                                                 noiseVariance )
%   	Syntax 2: [ receivedLlr ] = calculateLlr( receivedSymbols )
%       	Takes complex-valued noisy received symbols,and returns Log
%       	Likelihood Ratio soft bits.
%   	Inputs:
%       	receivedSymbols <1 x K complex> : symbols to be demapped.
%       	noiseVariance < 1 x K double> : noise variance of
%                         received symbols. If left empty, then
%                         noiseVariance is estimated based on the current
%                         signal vector.
%       Outputs:
%       	receivedLlr < 1 x N double > : received soft bits,
%                         N = K * log2(modulationOrder). If bit is
%                         1, then LLR>0.
%
%   setModulationOrder
%       Syntax: setModulationOrder( modulationOrder )
%           Changes the modulation order
%       Input:
%           modulationOrder < 1 x 1 integer > : number of different
%           	symbols in constellation. Must be a power of 2.
%
%   setLlrMethod
%       Syntax: setLlrMethod( llrMethod )
%           Changes the LLR calculation method
%       Input:
%           llrMethod < enum.modem.LlrMethod > : method for calculating
%               LLR, as defined in src\+enum\+modem\LlrMethod.m
%
%   Author: Lilian Freitas (LCF), Andre Noll Barreto (ANB)
%   Work Address: INDT Manaus/Brasilia
%   E-mail: <lilian.freitas>@indt.org.br, andre.noll@indt.org
%   History:
%       v1.0 10 Apr 2015 (LCF, ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    properties ( GetAccess = 'public', SetAccess = 'protected' )

        symbolAlphabet;
        symbolEnergy;
        modulationOrder;
        llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;

    end

    properties ( Access = 'protected' )
    % cell arrays of <M x B integer > defining respectively the indices of
    % bits ones and zeros used to calculate LLR.
    % M is the modulation order and B is number of bits per symbol.
    % The elements of the cell array correspond to different modulation
    % schemes.
    % These properties are derived from symbolAlphabet
    onesIndex;
    zerosIndex;

    end

    methods

        function this = Mapper( alphabet, modulationOrder )

            this.symbolAlphabet = alphabet;

            for bitsPerSymbol = 1 : length( this.symbolAlphabet )
                if ~isempty ( this.symbolAlphabet{bitsPerSymbol} )
                    modulationOrderTmp = 2^bitsPerSymbol;

                    if length(this.symbolAlphabet{bitsPerSymbol}) ~= ...
                       modulationOrderTmp
                        error('invalid constellation size')
                    end

                    this.symbolEnergy( bitsPerSymbol ) = ...
                        mean( real(this.symbolAlphabet{bitsPerSymbol}).^2 + ...
                              real(this.symbolAlphabet{bitsPerSymbol}).^2);
                    
                    tableBits = de2bi(0:modulationOrderTmp-1);

                    for bit = 1:bitsPerSymbol
                        this.onesIndex{bitsPerSymbol}(bit,:) = ...
                            find( tableBits( :, bitsPerSymbol + 1 - bit) == 1 );
                        this.zerosIndex{bitsPerSymbol}(bit,:) = ...
                            find( tableBits( :, bitsPerSymbol + 1 - bit) == 0 );
                    end

                end
            end

            if ~exist('modulationOrder', 'var') || ...
                isempty( modulationOrder )
                % consider lowest modulation order possible
                numberOfBits = find( ~isempty( this.symbolAlphabet ), 1 );
                modulationOrder = 2^numberOfBits;
            end

            this.setModulationOrder( modulationOrder );

        end

        modulatedSignal = map( this, bits2Transmit );

        receivedLlr = calculateLlr( this, receivedSymbols, noiseVariance );

        setModulationOrder( this, modulationOrder );
        
        setLlrMethod( this, llrMethod );

    end

end