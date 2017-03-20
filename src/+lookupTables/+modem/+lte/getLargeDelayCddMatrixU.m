function [ matrixU ] = getLargeDelayCddMatrixU( numberOfLayers )
%GETLARGEDELAYCDDMATRIXU returns matrix U for open-loop.
%  Matrices implementation according to Table 6.3.4.2.2-1 in [1] for open-
%  loop spatial multiplexing with large-delay cyclic delay diversity.
%  [1] 3GPP TS 36.211 v10.7.0 rel.10, pag. 60
%   
%  Syntax: U = getLargeDelayCddMatrixU( numberOfLayers );
%       Matrix U for spatial multiplexing with large-delay CDD.
%   Input:
%       numberOfLayers < 1 x 1 int > - number of streams { 2 , 4 }.
%   Output:
%       matrixU < M x N complex > - matrix U for large-delay CDD.
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

switch numberOfLayers
    case 2
        matrixU = [ 1   1               ; ...
                    1   exp(-1i*2*pi/2) ] ./ sqrt(2);
                
    case 4
        matrixU = [ 1   1               1                1                ; ...
                    1   exp(-1i*2*pi/4) exp(-1i*4*pi/4)  exp(-1i*6*pi/4)  ; ...
                    1   exp(-1i*4*pi/4) exp(-1i*8*pi/4)	 exp(-1i*12*pi/4) ; ...
                    1   exp(-1i*6*pi/4) exp(-1i*12*pi/4) exp(-1i*18*pi/4) ] ./ sqrt(4);
                
    otherwise
        error( 'Invalid number of layers.' );
end

end

