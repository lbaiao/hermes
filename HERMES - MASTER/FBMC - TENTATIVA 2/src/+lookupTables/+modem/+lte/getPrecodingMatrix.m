function [ precodingMatrix ] = getPrecodingMatrix( mimoScheme, ...
                                                   txAntennas, ...
                                                   codebookIndex, ...
                                                   numberOfLayers )
%GETPRECODINGMATRIX returns the precoding matrices for multiple antennas.
%   
%   
%   Syntax 1: precodingMatrix = getPrecodingMatrix( mimoScheme );
%       Precoding matrix for none MIMO scheme, it returns a unitary scalar.
%   Input:
%       mimoScheme < enum > - MIMO scheme enumerator type defined in
%           enum.modem.MimoScheme.
%   Output:
%       precodingMatrix < M x N complex > - precoding matrix for multiple
%           antenna transmission.
%           M: number of output streams.
%           N: number of input streams.
%   
%   Syntax 2: precodingMatrix = getPrecodingMatrix( mimoScheme, ...
%                                                   txAntennas );
%       Precoding matrix for transmit diversity
%   Input:
%       txAntennas < 1 x 1 int > - number of transmit antennas { 1, 2, 4 }.
%   Output:
%       precodingMatrix < M x N complex > - precoding matrix for multiple
%           antenna transmission.
%           M: number of output streams.
%           N: number of input streams.
%   
%   Syntax 3: precodingMatrix = getPrecodingMatrix( mimoScheme, ...
%                                                   txAntennas, ...
%                                                   codebookIndex, ...
%                                                   numberOfLayers );
%       Precoding matrix for spatial multiplexing
%   Input:
%       codebookIndex < 1 x 1 int > - codebook index { 0, ..., 15 }.
%       numberOfLayers < 1 x 1 int > - number of streams { 1, ..., 4 }.
%   Output:
%       precodingMatrix < M x N complex > - precoding matrix for multiple
%           antenna transmission.
%           M: number of output streams.
%           N: number of input streams.
% 
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasilia
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 07 May 2015 (FF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

switch mimoScheme
    case enum.modem.MimoScheme.NONE
        
        precodingMatrix = 1;
        
    case enum.modem.MimoScheme.TRANSMIT_DIVERSITY
        switch txAntennas
            case 2
                % Alamouti space-time block coding 2xN
                % S.M. Alamouti (October 1998). "A simple transmit diversity
                % technique for wireless communications". IEEE Journal on 
                % Selected Areas in Communications 16 (8): 1451–1458
                precodingMatrix = [  1   0   1i  0   ; ...
                                     0   1   0   1i  ; ...
                                     0   -1  0   1i  ; ...
                                     1   0   -1i 0   ] ./ sqrt(2);
            case 4
                % As defined in TS 36.211 v10.7.0 R10, Sec. 6.3.4.3, p. 62
                precodingMatrix = [ 1   0   0   0   1i  0   0   0   ; ...
                                    0   0   0   0   0   0   0   0   ; ...
                                    0   -1  0   0   0   1i  0   0   ; ...
                                    0   0   0   0   0   0   0   0   ; ...
                                    0   1   0   0   0   1i  0   0   ; ...
                                    0   0   0   0   0   0   0   0   ; ...
                                    1   0   0   0   -1i 0   0   0   ; ...
                                    0   0   0   0   0   0   0   0   ; ...
                                    0   0   0   0   0   0   0   0   ; ...
                                    0   0   1   0   0   0   1i  0   ; ...
                                    0   0   0   0   0   0   0   0   ; ...
                                    0   0   0   -1  0   0   0   1i  ; ...
                                    0   0   0   0   0   0   0   0   ; ...
                                    0   0   0   1   0   0   0   1i  ; ...
                                    0   0   0   0   0   0   0   0   ; ...
                                    0   0   1   0   0   0   -1i 0   ] ./ sqrt(2);
            otherwise
                error( 'Invalid number of transmit antennas.' );
                
        end
        
    case { enum.modem.MimoScheme.CLOSED_LOOP, enum.modem.MimoScheme.OPEN_LOOP }
        codebookIndex = codebookIndex + 1;
        
        switch txAntennas
            case 2
            % As defined in TS 36.211 v10.7.0 R10, Sec. 6.3.4.2.2, p. 60
                codebook = cell( 4, 2 );
                
                % codebook for 1 layer
                codebook{ 1, 1 } = [ 1 ; 1 ] ./ sqrt(2);
                codebook{ 2, 1 } = [ 1 ; -1 ] ./ sqrt(2);
                codebook{ 3, 1 } = [ 1 ; 1i ] ./ sqrt(2);
                codebook{ 4, 1 } = [ 1 ; -1i ] ./ sqrt(2);
                
                % codebook for 2 layers
                codebook{ 1, 2 } = [ 1 0 ; 0 1 ] ./ sqrt(2);
                codebook{ 2, 2 } = [ 1 1 ; 1 -1 ] ./ 2;
                codebook{ 3, 2 } = [ 1 1 ; 1i -1i ] ./ 2;
                
                precodingMatrix = codebook{ codebookIndex, numberOfLayers };
                                
            case 4
            % As defined in TS 36.211 v10.7.0 R10, Sec. 6.3.4.2.2, p. 61
                u = cell( 1, 16);
                u{ 1 } = [ 1 -1 -1 -1 ].';
                u{ 2 } = [ 1 -1i 1 1i ].';
                u{ 3 } = [ 1 1 -1 1 ].';
                u{ 4 } = [ 1 1i 1 -1i ].';
                u{ 5 } = [ 1 (-1-1i)/sqrt(2) -1i (1-1i)/sqrt(2) ].';
                u{ 6 } = [ 1 (1-1i)/sqrt(2) 1i (-1-1i)/sqrt(2) ].';
                u{ 7 } = [ 1 (1+1i)/sqrt(2) -1i (-1+1i)/sqrt(2) ].';
                u{ 8 } = [ 1 (-1+1i)/sqrt(2) 1i (1+1i)/sqrt(2) ].';
                u{ 9 } = [ 1 -1 1 1 ].';
                u{ 10 } = [ 1 -1i -1 -1i ].';
                u{ 11 } = [ 1 1 1 -1 ].';
                u{ 12 } = [ 1 1i -1 1i ].';
                u{ 13 } = [ 1 -1 -1 1 ].';
                u{ 14 } = [ 1 -1 1 -1 ].';
                u{ 15 } = [ 1 1 -1 -1 ].';
                u{ 16 } = [ 1 1 1 1 ].';
                
                codebook = cell( 16, 4 );
                W = cell( 1, 16 );
                
                for n = 1 : 16
                    
                    W{ n } = eye(4) - 2 * u{ n } * u{ n }' / ( u{ n }' * u{ n } );
                    
                    % codebook for 1 layer
                    codebook{ n, 1 } = W{ n }( :, 1 );
                    
                end
                
                % codebook for 2 layers
                codebook{ 1, 2 } = [ W{ 1 }( :, 1 ) W{ 1 }( :, 4 ) ] ./ sqrt(2);
                codebook{ 2, 2 } = [ W{ 2 }( :, 1 ) W{ 2 }( :, 2 ) ] ./ sqrt(2);
                codebook{ 3, 2 } = [ W{ 3 }( :, 1 ) W{ 3 }( :, 2 ) ] ./ sqrt(2);
                codebook{ 4, 2 } = [ W{ 4 }( :, 1 ) W{ 4 }( :, 2 ) ] ./ sqrt(2);
                codebook{ 5, 2 } = [ W{ 5 }( :, 1 ) W{ 5 }( :, 4 ) ] ./ sqrt(2);
                codebook{ 6, 2 } = [ W{ 6 }( :, 1 ) W{ 6 }( :, 4 ) ] ./ sqrt(2);
                codebook{ 7, 2 } = [ W{ 7 }( :, 1 ) W{ 7 }( :, 3 ) ] ./ sqrt(2);
                codebook{ 8, 2 } = [ W{ 8 }( :, 1 ) W{ 8 }( :, 3 ) ] ./ sqrt(2);
                codebook{ 9, 2 } = [ W{ 9 }( :, 1 ) W{ 9 }( :, 2 ) ] ./ sqrt(2);
                codebook{ 10, 2 } = [ W{ 10 }( :, 1 ) W{ 10 }( :, 4 ) ] ./ sqrt(2);
                codebook{ 11, 2 } = [ W{ 11 }( :, 1 ) W{ 11 }( :, 3 ) ] ./ sqrt(2);
                codebook{ 12, 2 } = [ W{ 12 }( :, 1 ) W{ 12 }( :, 3 ) ] ./ sqrt(2);
                codebook{ 13, 2 } = [ W{ 13 }( :, 1 ) W{ 13 }( :, 2 ) ] ./ sqrt(2);
                codebook{ 14, 2 } = [ W{ 14 }( :, 1 ) W{ 14 }( :, 3 ) ] ./ sqrt(2);
                codebook{ 15, 2 } = [ W{ 15 }( :, 1 ) W{ 15 }( :, 3 ) ] ./ sqrt(2);
                codebook{ 16, 2 } = [ W{ 16 }( :, 1 ) W{ 16 }( :, 2 ) ] ./ sqrt(2);
                
                % codebook for 3 layers
                codebook{ 1, 3 } = [ W{ 1 }( :, 1 ) W{ 1 }( :, 2 ) W{ 1 }( :, 4 ) ] ./ sqrt(3);
                codebook{ 2, 3 } = [ W{ 2 }( :, 1 ) W{ 2 }( :, 2 ) W{ 2 }( :, 3 ) ] ./ sqrt(3);
                codebook{ 3, 3 } = [ W{ 3 }( :, 1 ) W{ 3 }( :, 2 ) W{ 3 }( :, 3 ) ] ./ sqrt(3);
                codebook{ 4, 3 } = [ W{ 4 }( :, 1 ) W{ 4 }( :, 2 ) W{ 4 }( :, 3 ) ] ./ sqrt(3);
                codebook{ 5, 3 } = [ W{ 5 }( :, 1 ) W{ 5 }( :, 2 ) W{ 5 }( :, 4 ) ] ./ sqrt(3);
                codebook{ 6, 3 } = [ W{ 6 }( :, 1 ) W{ 6 }( :, 2 ) W{ 6 }( :, 4 ) ] ./ sqrt(3);
                codebook{ 7, 3 } = [ W{ 7 }( :, 1 ) W{ 7 }( :, 3 ) W{ 7 }( :, 4 ) ] ./ sqrt(3);
                codebook{ 8, 3 } = [ W{ 8 }( :, 1 ) W{ 8 }( :, 3 ) W{ 8 }( :, 4 ) ] ./ sqrt(3);
                codebook{ 9, 3 } = [ W{ 9 }( :, 1 ) W{ 9 }( :, 2 ) W{ 9 }( :, 4 ) ] ./ sqrt(3);
                codebook{ 10, 3 } = [ W{ 10 }( :, 1 ) W{ 10 }( :, 3 ) W{ 10 }( :, 4 ) ] ./ sqrt(3);
                codebook{ 11, 3 } = [ W{ 11 }( :, 1 ) W{ 11 }( :, 2 ) W{ 11 }( :, 3 ) ] ./ sqrt(3);
                codebook{ 12, 3 } = [ W{ 12 }( :, 1 ) W{ 12 }( :, 3 ) W{ 12 }( :, 4 ) ] ./ sqrt(3);
                codebook{ 13, 3 } = [ W{ 13 }( :, 1 ) W{ 13 }( :, 2 ) W{ 13 }( :, 3 ) ] ./ sqrt(3);
                codebook{ 14, 3 } = [ W{ 14 }( :, 1 ) W{ 14 }( :, 2 ) W{ 14 }( :, 3 ) ] ./ sqrt(3);
                codebook{ 15, 3 } = [ W{ 15 }( :, 1 ) W{ 15 }( :, 2 ) W{ 15 }( :, 3 ) ] ./ sqrt(3);
                codebook{ 16, 3 } = [ W{ 16 }( :, 1 ) W{ 16 }( :, 2 ) W{ 16 }( :, 3 ) ] ./ sqrt(3);
                
                % codebook for 4 layers
                codebook{ 1, 4 } = [ W{ 1 }( :, 1 ) W{ 1 }( :, 2 ) W{ 1 }( :, 3 ) W{ 1 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 2, 4 } = [ W{ 2 }( :, 1 ) W{ 2 }( :, 2 ) W{ 2 }( :, 3 ) W{ 2 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 3, 4 } = [ W{ 3 }( :, 3 ) W{ 3 }( :, 2 ) W{ 3 }( :, 1 ) W{ 3 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 4, 4 } = [ W{ 4 }( :, 3 ) W{ 4 }( :, 2 ) W{ 4 }( :, 1 ) W{ 4 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 5, 4 } = [ W{ 5 }( :, 1 ) W{ 5 }( :, 2 ) W{ 5 }( :, 3 ) W{ 5 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 6, 4 } = [ W{ 6 }( :, 1 ) W{ 6 }( :, 2 ) W{ 6 }( :, 3 ) W{ 6 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 7, 4 } = [ W{ 7 }( :, 1 ) W{ 7 }( :, 3 ) W{ 7 }( :, 2 ) W{ 7 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 8, 4 } = [ W{ 8 }( :, 1 ) W{ 8 }( :, 3 ) W{ 8 }( :, 2 ) W{ 8 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 9, 4 } = [ W{ 9 }( :, 1 ) W{ 9 }( :, 2 ) W{ 9 }( :, 3 ) W{ 9 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 10, 4 } = [ W{ 10 }( :, 1 ) W{ 10 }( :, 2 ) W{ 10 }( :, 3 ) W{ 10 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 11, 4 } = [ W{ 11 }( :, 1 ) W{ 11 }( :, 3 ) W{ 11 }( :, 2 ) W{ 11 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 12, 4 } = [ W{ 12 }( :, 1 ) W{ 12 }( :, 3 ) W{ 12 }( :, 2 ) W{ 12 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 13, 4 } = [ W{ 13 }( :, 1 ) W{ 13 }( :, 2 ) W{ 13 }( :, 3 ) W{ 13 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 14, 4 } = [ W{ 14 }( :, 1 ) W{ 14 }( :, 3 ) W{ 14 }( :, 2 ) W{ 14 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 15, 4 } = [ W{ 15 }( :, 3 ) W{ 15 }( :, 2 ) W{ 15 }( :, 1 ) W{ 15 }( :, 4 ) ] ./ sqrt(4);
                codebook{ 16, 4 } = [ W{ 16 }( :, 1 ) W{ 16 }( :, 2 ) W{ 16 }( :, 3 ) W{ 16 }( :, 4 ) ] ./ sqrt(4);
                
                precodingMatrix = codebook{ codebookIndex, numberOfLayers };                
                
            otherwise
                error( 'Invalid number of transmit antennas.' );
        end
        
    otherwise
        error( 'Invalid MIMO scheme.' );
end

