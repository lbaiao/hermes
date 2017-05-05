function [ equalizedSignal ] = equalizeTxDiversity( this, mimoSignal, ...
                                                          channel )
%SPATIALCODER.EQUALIZETXDIVERSITY decodes space-time block coded streams.
%   According to the number of antennas, a different scheme of transmit
%   diversity may be used. For 2 transmit antennas, Alamouti scheme [1]
%   is used. For more antennas, other schemes will be used.
% 
% [1] Alamouti, S., "A simple transmit diversity technique for wireless 
% communications," Selected Areas in Communications, IEEE Journal on , 
% vol.16, no.8, pp.1451,1458, Oct 1998
%
%   Syntax: [ equalizedSignal ] = equalizeTxDiversity( mimoSymbols, ...
%                                                      channel ) 
%   Input:
%       mimoSignal < Nsymb x NRx complex > - received signal.
%           Nsymb: the number of data symbols in the frame.
%           NRx: number of receive antennas.
%       channel < Nsymb x NRx x NTx complex > - the channel gain at each
%           data symbol.
%           NTx: number of transmit antennas.
%   Output:
%       equalizedSignal < Nsymb x 1 complex > - received data symbols.
%           Nsymb: the number of equalized symbols.
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 16 Apr 2015 (FF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied. 

numberOfElements = size( mimoSignal, 1 );

% initiate output
equalizedSignal = zeros( numberOfElements, 1 );

switch this.numberOfTxAntennas
    case 2
    % Alamouti decoding [1]
        for sym = 1 : 2 : numberOfElements % data symbol iterator

            % channel realization
            % assume invariant channel for two symbols
            H = squeeze( channel( sym, :, : ) );

            % orthogonal matrix
            Ha = [ H; fliplr(conj(H)) * [ 1 0 ; 0 -1 ] ];

            % received signal
            Y = [ mimoSignal( sym, : ) conj( mimoSignal( sym+1, : ) ) ].';

            % decode operation
            Z = pinv( Ha ) * Y;
            Z = Z .* sqrt(2);

            % output decoded symbols
            equalizedSignal( sym ) = Z(1);
            equalizedSignal( sym+1 ) = Z(2);

        end
    otherwise
        error( 'Invalid number of transmit antennas.' );
end




end

