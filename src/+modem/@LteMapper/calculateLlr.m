function [receivedLlr] = calculateLlr( this, receivedSymbols, noiseVariance )
%LTEMAPPER.CALCULATELLR is an optimized implementation of calculateLlr().
% Detailed description can be found in class header.
%
%   Author: Lilian Freitas (LCF)
%   Work Address: INDT Manaus
%   E-mail: <lilian.freitas>@indt.org.br
%   History:
%       v1.0 10 Apr 2015 (LCF) - created
%       v1.1 19 May 2015 (LCF) - include llrMethod as a parameter
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


if ~exist('noiseVariance','var')
    bitsPerSymbol = log2( this.modulationOrder );
    
    
    % estimate noise variance
    noiseVariance = max( mean( real(receivedSymbols).^2 + ...
                               imag(receivedSymbols).^2 ) - ...
                         this.symbolEnergy( bitsPerSymbol ), 0 );

end


switch this.llrMethod

    case { enum.modem.LlrMethod.IDEAL_AWGN, ...
           enum.modem.LlrMethod.NEAREST_AWGN}

        [receivedLlr] = calculateLlr@modem.Mapper( this, receivedSymbols, ...
                                                   noiseVariance );

    case enum.modem.LlrMethod.LINEAR_APPROXIMATION

        
        % Note that receivedLlr is calculated as follow:
        %  16-QAM  = [ b1, b2, b3, b4 ] => (real | imag ) => ( llr1, llr3 | llr2, llr4 )
        %  64-QAM  = [ b1, b2, b3, b4, b5, b6 ] => ( real | imag ) => ( llr1, llr3, llr5 | llr2, llr4, llr6 )
        %  256-QAM = [ b1, b2, b3, b4, b5, b6, b7, b8 ] => ( real | imag ) => ( llr1, llr3, llr5, llr7 | llr2, llr4, llr6, llr8 )

        symbolsReal = real( receivedSymbols );

        symbolsImag = imag( receivedSymbols );

        switch this.modulationOrder

            case 2  % BPSK symbols = [b1]

                % calculate LLR of b1
                llr( :, 1) = -2 * sqrt(2) .* (symbolsReal + symbolsImag) ;

            case 4 % QPSK symbol = [b1 b2]

                % calculate LLR for b1
                llr( :, 1 ) = -2*sqrt(2) .* symbolsReal;

                % calculate LLR for b2
                llr( :, 2 ) = -2*sqrt(2) .* symbolsImag;

            case 16 %16-QAM symbol = [b1 b2 b3 b4]

                distance = 1/sqrt(10);

                % calculate LLR for b1
                llr( :, 1 ) =  2 .* ( (symbolsReal <= -2* distance).*(-4* distance*( distance + symbolsReal)) + ...
                    (symbolsReal > -2* distance & symbolsReal <= 2* distance).*(-2* distance*symbolsReal) + ...
                    (symbolsReal > 2* distance).*(4* distance*( distance - symbolsReal)));

                % calculate LLR for b2
                llr( :, 2 ) = 2 .* ( (symbolsImag <= -2* distance).*(-4* distance*( distance + symbolsImag)) + ...
                    (symbolsImag > -2* distance & symbolsImag <= 2* distance).*(-2* distance*symbolsImag) + ...
                    (symbolsImag > 2* distance).*(4* distance*( distance - symbolsImag)));

                % calculate LLR for b3
                llr( :, 3 ) = 2 .* ( (symbolsReal <= 0).*(-2* distance *( 2* distance  + symbolsReal)) + ...
                    (symbolsReal > 0).*(-2* distance *(2* distance  - symbolsReal)));

                % calculate LLR for b4
                llr( :, 4 ) = 2 .* ( (symbolsImag <= 0).*(-2* distance *( 2* distance  + symbolsImag)) + ...
                    (symbolsImag > 0).*(-2* distance *(2* distance  - symbolsImag)));

            case 64 %64-QAM symbol = [b1 b2 b3 b4 b5 b6]

                distance = 1/sqrt(42);

                % calculate LLR for b1
                llr( :, 1 ) = 4 .* ( (symbolsReal <= -6*distance).*(-4*distance*(3*distance + symbolsReal)) + ...
                    (symbolsReal > -6*distance & symbolsReal <= -4*distance).*(-3*distance*(2*distance + symbolsReal)) + ...
                    (symbolsReal > -4*distance & symbolsReal <= -2*distance).*(-2*distance*(distance + symbolsReal)) + ...
                    (symbolsReal > -2*distance & symbolsReal <= 2*distance).*(-distance*symbolsReal) + ...
                    (symbolsReal > 2*distance & symbolsReal <= 4*distance).*(2*distance*(distance - symbolsReal)) + ...
                    (symbolsReal > 4*distance & symbolsReal <= 6*distance).*(3*distance*(2*distance - symbolsReal)) + ...
                    (symbolsReal > 6*distance).*(4*distance*(3*distance - symbolsReal)));

                % calculate LLR for b2
                llr( :, 2 ) =  4 .* ( (symbolsImag <= -6*distance).*(-4*distance*(3*distance + symbolsImag)) + ...
                    (symbolsImag > -6*distance & symbolsImag <= -4*distance).*(-3*distance*(2*distance + symbolsImag)) + ...
                    (symbolsImag > -4*distance & symbolsImag <= -2*distance).*(-2*distance*(distance + symbolsImag)) + ...
                    (symbolsImag > -2*distance & symbolsImag <= 2*distance).*(-distance*symbolsImag) + ...
                    (symbolsImag > 2*distance & symbolsImag <= 4*distance).*(2*distance*(distance - symbolsImag)) + ...
                    (symbolsImag > 4*distance & symbolsImag <= 6*distance).*(3*distance*(2*distance - symbolsImag)) + ...
                    (symbolsImag > 6*distance).*(4*distance*(3*distance - symbolsImag)));

                % calculate LLR for b3
                llr( :, 3 ) = 4 .* ( (symbolsReal <= -6* distance).*(-2* distance*(5* distance + symbolsReal)) + ...
                    (symbolsReal > -6* distance & symbolsReal <= -2* distance).*(- distance*(4* distance + symbolsReal)) + ...
                    (symbolsReal > -2* distance & symbolsReal <= 0).*(-2* distance*(3* distance + symbolsReal)) + ...
                    (symbolsReal > 0 & symbolsReal <= 2* distance).*(-2* distance*(3* distance - symbolsReal)) + ...
                    (symbolsReal > 2* distance & symbolsReal <= 6* distance).*(- distance*(4* distance - symbolsReal)) + ...
                    (symbolsReal > 6* distance).*(-2* distance*(5* distance - symbolsReal)) );


                % calculate LLR for b4
                llr( :, 4 ) = 4 .* ( (symbolsImag <= -6* distance).*(-2* distance*(5* distance + symbolsImag)) + ...
                    (symbolsImag > -6* distance & symbolsImag <= -2* distance).*(- distance*(4* distance + symbolsImag)) + ...
                    (symbolsImag > -2* distance & symbolsImag <= 0).*(-2* distance*(3* distance + symbolsImag)) + ...
                    (symbolsImag > 0 & symbolsImag <= 2* distance).*(-2* distance*(3* distance - symbolsImag)) + ...
                    (symbolsImag > 2* distance & symbolsImag <= 6* distance).*(- distance*(4* distance - symbolsImag)) + ...
                    (symbolsImag > 6* distance).*(-2* distance*(5* distance - symbolsImag)) );

                % calculate LLR for b5
                llr( :, 5 ) = 4 .* ( (symbolsReal <= -4* distance).*(- distance*(6* distance + symbolsReal)) + ...
                    (symbolsReal > -4* distance & symbolsReal <= 0).*( distance*(2* distance + symbolsReal)) + ...
                    (symbolsReal > 0 & symbolsReal <= 4* distance).*( distance*(2* distance - symbolsReal)) + ...
                    (symbolsReal > 4* distance).*(- distance*(6* distance - symbolsReal)) );

                % calculate LLR for b6
                llr( :, 6 ) = 4 .* ( (symbolsImag <= -4* distance).*(- distance*(6* distance + symbolsImag)) + ...
                    (symbolsImag > -4* distance & symbolsImag <= 0).*( distance*(2* distance + symbolsImag)) + ...
                    (symbolsImag > 0 & symbolsImag <= 4* distance).*( distance*(2* distance - symbolsImag)) + ...
                    (symbolsImag > 4* distance).*(- distance*(6* distance - symbolsImag)) );

            case 256

                distance = 1/sqrt( 170 );


                %256-QAM symbol = [b1 b2 b3 b4 b5 b6 b7 b8]
                % calculate LLR for b1
                llr( :, 1 ) =  8 .* ( ( symbolsReal <= -14 * distance ) .* ( -4* distance *( 7 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -14 * distance  &  symbolsReal <= -12 * distance ) .* ( -3.5 * distance * ( 6 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -12 * distance  &  symbolsReal <= -10 * distance ) .* ( -3 * distance * ( 5 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -10 * distance  &  symbolsReal <= -8 * distance ) .* ( -2.5 * distance * ( 4 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -8 * distance  &  symbolsReal <= -6 * distance ) .* ( -2 * distance * ( 3 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -6 * distance  &  symbolsReal <= -4 * distance ) .* ( -1.5 * distance * ( 2 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -4 * distance  &  symbolsReal <= -2 * distance ) .* ( - distance * ( distance  +  symbolsReal)) + ...
                    ( symbolsReal > -2 * distance  &  symbolsReal <= 2 * distance ) .* ( -0.5 * distance * symbolsReal) + ...
                    ( symbolsReal > 2 * distance  &  symbolsReal <= 4 * distance ) .* ( distance *( distance  -  symbolsReal)) + ...
                    ( symbolsReal > 4 * distance  &  symbolsReal <= 6 * distance ) .* ( 1.5 * distance * ( 2 * distance  -  symbolsReal)) +  ...
                    ( symbolsReal > 6 * distance  &  symbolsReal <= 8 * distance ) .* ( 2 * distance * ( 3 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 8 * distance  &  symbolsReal <= 10 * distance ) .* ( 2.5 * distance * ( 4 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 10 * distance  &  symbolsReal <= 12 * distance ) .* ( 3 * distance * ( 5 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 12 * distance  &  symbolsReal <= 14 * distance ).* ( 3.5 * distance * ( 6 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 14 * distance ).* ( 4 * distance * ( 7 * distance  -  symbolsReal )) );

                % calculate LLR for b2
                llr( :, 2 ) = 8 .* ( ( symbolsImag <= -14 * distance ) .* ( -4* distance *( 7 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -14 * distance  &  symbolsImag <= -12 * distance ) .* ( -3.5 * distance * ( 6 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -12 * distance  &  symbolsImag <= -10 * distance ) .* ( -3 * distance * ( 5 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -10 * distance  &  symbolsImag <= -8 * distance ) .* ( -2.5 * distance * ( 4 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -8 * distance  &  symbolsImag <= -6 * distance ) .* ( -2 * distance * ( 3 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -6 * distance  &  symbolsImag <= -4 * distance ) .* ( -1.5 * distance * ( 2 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -4 * distance  &  symbolsImag <= -2 * distance ) .* ( - distance * ( distance  +  symbolsImag)) + ...
                    ( symbolsImag > -2 * distance  &  symbolsImag <= 2 * distance ) .* ( -0.5 * distance * symbolsImag) + ...
                    ( symbolsImag > 2 * distance  &  symbolsImag <= 4 * distance ) .* ( distance *( distance  -  symbolsImag)) + ...
                    ( symbolsImag > 4 * distance  &  symbolsImag <= 6 * distance ) .* ( 1.5 * distance * ( 2 * distance  -  symbolsImag)) +  ...
                    ( symbolsImag > 6 * distance  &  symbolsImag <= 8 * distance ) .* ( 2 * distance * ( 3 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 8 * distance  &  symbolsImag <= 10 * distance ) .* ( 2.5 * distance * ( 4 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 10 * distance  &  symbolsImag <= 12 * distance ) .* ( 3 * distance * ( 5 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 12 * distance  &  symbolsImag <= 14 * distance ).* ( 3.5 * distance * ( 6 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 14 * distance ).* ( 4 * distance * ( 7 * distance  -  symbolsImag )) );


                % calculate LLR for b3
                llr( :, 3 ) =  8 .* ( ( symbolsReal <= -14 * distance ) .* ( -2 * distance * ( 11 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -14 * distance  &  symbolsReal <= -12 * distance ) .* ( -1.5 * distance * ( 10 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -12 * distance  &  symbolsReal <= -10 * distance ) .* ( -distance * ( 9 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -10 * distance  &  symbolsReal <= -6 * distance ) .*( -0.5 * distance * ( 8 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -6 * distance  &  symbolsReal <= -4 * distance ) .*( -distance * ( 7 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -4 * distance  &  symbolsReal <= -2 * distance ) .* ( -1.5 * distance *( 6 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -2 * distance  &  symbolsReal <= 0 ) .* ( -2 * distance * ( 5 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > 0 &  symbolsReal <= 2 * distance ) .* ( -2 * distance * ( 5 * distance  -  symbolsReal )) + ...
                    ( symbolsReal > 2 * distance  &  symbolsReal <= 4 * distance ).* ( -1.5 * distance * ( 6 * distance  -  symbolsReal )) + ...
                    ( symbolsReal > 4 * distance  &  symbolsReal <= 6 * distance ).* ( -distance * ( 7 * distance  -  symbolsReal )) + ...
                    ( symbolsReal > 6 * distance  &  symbolsReal <= 10 * distance ).* ( -0.5 * distance * ( 8 * distance  -  symbolsReal )) + ...
                    ( symbolsReal > 10 * distance  &  symbolsReal <= 12 * distance ).* ( -distance * ( 9 * distance  -  symbolsReal )) + ...
                    ( symbolsReal > 12 * distance  &  symbolsReal <= 14 * distance ).* ( -1.5 * distance * ( 10 * distance  -  symbolsReal )) + ...
                    ( symbolsReal > 14 * distance ) .* ( -2 * distance * ( 11* distance  -  symbolsReal )) );

                % calculate LLR for b4
                llr( :, 4 ) = 8 .* ( ( symbolsImag <= -14 * distance ) .* ( -2 * distance * ( 11 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -14 * distance  &  symbolsImag <= -12 * distance ) .* ( -1.5 * distance * ( 10 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -12 * distance  &  symbolsImag <= -10 * distance ) .* ( -distance * ( 9 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -10 * distance  &  symbolsImag <= -6 * distance ) .*( -0.5 * distance * ( 8 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -6 * distance  &  symbolsImag <= -4 * distance ) .*( -distance * ( 7 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -4 * distance  &  symbolsImag <= -2 * distance ) .* ( -1.5 * distance *( 6 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -2 * distance  &  symbolsImag <= 0 ) .* ( -2 * distance * ( 5 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > 0 &  symbolsImag <= 2 * distance ) .* ( -2 * distance * ( 5 * distance  -  symbolsImag )) + ...
                    ( symbolsImag > 2 * distance  &  symbolsImag <= 4 * distance ).* ( -1.5 * distance * ( 6 * distance  -  symbolsImag )) + ...
                    ( symbolsImag > 4 * distance  &  symbolsImag <= 6 * distance ).* ( -distance * ( 7 * distance  -  symbolsImag )) + ...
                    ( symbolsImag > 6 * distance  &  symbolsImag <= 10 * distance ).* ( -0.5 * distance * ( 8 * distance  -  symbolsImag )) + ...
                    ( symbolsImag > 10 * distance  &  symbolsImag <= 12 * distance ).* ( -distance * ( 9 * distance  -  symbolsImag )) + ...
                    ( symbolsImag > 12 * distance  &  symbolsImag <= 14 * distance ).* ( -1.5 * distance * ( 10 * distance  -  symbolsImag )) + ...
                    ( symbolsImag > 14 * distance ) .* ( -2 * distance * ( 11* distance  -  symbolsImag )) );

                % calculate LLR for b5
                llr( :, 5 ) = 8 .* ( ( symbolsReal <= -14 * distance ) .* ( -distance * ( 13 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -14 * distance  &  symbolsReal <= -10 * distance ).* ( -0.5 * distance * ( 12 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -10 * distance  &  symbolsReal <= -8 * distance ) .* ( - distance * ( 11 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -8 * distance  &  symbolsReal <= -6 * distance ) .* ( distance * ( 5 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -6 * distance  &  symbolsReal <= -2 * distance ) .* (0.5 * distance * ( 4 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > -2 * distance  &  symbolsReal <= 0 ) .* ( distance * ( 3 * distance  +  symbolsReal)) + ...
                    ( symbolsReal > 0 & symbolsReal <= 2 * distance ) .* ( distance * ( 3 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 2 * distance  &  symbolsReal <= 6 * distance ) .* ( 0.5 * distance * ( 4 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 6 * distance  &  symbolsReal <= 8 * distance ) .* ( distance *( 5 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 8 * distance  &  symbolsReal <= 10 * distance ) .* (- distance * ( 11 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 10 * distance  &  symbolsReal <= 14 * distance ) .* ( -0.5* distance * ( 12 * distance  -  symbolsReal)) + ...
                    ( symbolsReal > 14 * distance ) .* ( -distance * ( 13 * distance  -  symbolsReal )) );


                % calculate LLR for b6
                llr( :, 6 ) = 8 .* ( ( symbolsImag <= -14 * distance ) .* ( -distance * ( 13 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -14 * distance  &  symbolsImag <= -10 * distance ).* ( -0.5 * distance * ( 12 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -10 * distance  &  symbolsImag <= -8 * distance ) .* ( - distance * ( 11 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -8 * distance  &  symbolsImag <= -6 * distance ) .* ( distance * ( 5 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -6 * distance  &  symbolsImag <= -2 * distance ) .* (0.5 * distance * ( 4 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > -2 * distance  &  symbolsImag <= 0 ) .* ( distance * ( 3 * distance  +  symbolsImag)) + ...
                    ( symbolsImag > 0 & symbolsImag <= 2 * distance ) .* ( distance * ( 3 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 2 * distance  &  symbolsImag <= 6 * distance ) .* ( 0.5 * distance * ( 4 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 6 * distance  &  symbolsImag <= 8 * distance ) .* ( distance *( 5 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 8 * distance  &  symbolsImag <= 10 * distance ) .* (- distance * ( 11 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 10 * distance  &  symbolsImag <= 14 * distance ) .* ( -0.5* distance * ( 12 * distance  -  symbolsImag)) + ...
                    ( symbolsImag > 14 * distance ) .* ( -distance * ( 13 * distance  -  symbolsImag )) );


                % calculate LLR for b7
                llr( :, 7 ) = 8 .* ( ( symbolsReal <= -12 * distance ) .* ( -0.5 * distance * ( 14 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -12 * distance  &  symbolsReal <= -8 * distance ) .* ( 0.5 * distance * ( 10 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -8 * distance  &  symbolsReal <= -4 * distance ) .* ( -0.5 * distance * ( 6 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > -4 * distance  &  symbolsReal <= 0 ) .*( 0.5 * distance * ( 2 * distance  +  symbolsReal )) + ...
                    ( symbolsReal > 0 &  symbolsReal <= 4 * distance ).* ( 0.5 * distance * ( 2 * distance  - symbolsReal )) + ...
                    ( symbolsReal > 4 * distance  &  symbolsReal <= 8 * distance ) .* ( -0.5 * distance * ( 6 * distance  -  symbolsReal )) + ...
                    ( symbolsReal > 8 * distance  &  symbolsReal <= 12 * distance ) .* ( 0.5 * distance * ( 10 * distance  -  symbolsReal )) + ...
                    ( symbolsReal > 12 * distance ) .* ( -0.5 * distance * ( 14 * distance  -  symbolsReal )) );

                % calculate LLR for b8
                llr( :, 8 ) = 8 .* ( ( symbolsImag <= -12 * distance ) .* ( -0.5 * distance * ( 14 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -12 * distance  &  symbolsImag <= -8 * distance ) .* ( 0.5 * distance * ( 10 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -8 * distance  &  symbolsImag <= -4 * distance ) .* ( -0.5 * distance * ( 6 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > -4 * distance  &  symbolsImag <= 0 ) .*( 0.5 * distance * ( 2 * distance  +  symbolsImag )) + ...
                    ( symbolsImag > 0 &  symbolsImag <= 4 * distance ).* ( 0.5 * distance * ( 2 * distance  - symbolsImag )) + ...
                    ( symbolsImag > 4 * distance  &  symbolsImag <= 8 * distance ) .* ( -0.5 * distance * ( 6 * distance  -  symbolsImag )) + ...
                    ( symbolsImag > 8 * distance  &  symbolsImag <= 12 * distance ) .* ( 0.5 * distance * ( 10 * distance  -  symbolsImag )) + ...
                    ( symbolsImag > 12 * distance ) .* ( -0.5 * distance * ( 14 * distance  -  symbolsImag )) );

            otherwise

                error('Choose a valid modulation (BPSK, QPSK, 16-QAM, 64-QAM or 256-QAM)');
        end

        % maximum LLR without overflow
        minNoiseVariance = min(min( abs(llr) )) / (realmax/10);
        noiseVariance( noiseVariance < minNoiseVariance ) = minNoiseVariance;
        
        llr = bsxfun( @rdivide, llr, noiseVariance );
        % see Yoo Soo Choo et all. MIMO-OFDM wireless communications with MATLAB. 2010.
        % Jhon Wiley. Eq. 11.82, pag. 354.

        receivedLlr = reshape( llr', size( llr, 1 ) * size( llr, 2 ), 1 );

    otherwise

        error('Choose a valid method to calculate LLR');
end
