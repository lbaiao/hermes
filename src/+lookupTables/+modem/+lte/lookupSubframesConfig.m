%LOOKUPSUBFRAMESCONFIG loads a LookUp Table for Subframe Configurations for LTE
% It implements the special subframe configuration values and subrame
% uplink and downlink assignments according to definitions found on
% STANDARD 3GPP TS 36.211-v12.4.0:
%           Table 4.2-2 - Page 12
%
%   Author: Rafhael Medeiros de Amorim (RMA)
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v1.0 04 March 2015 (RMA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Subframe Direction Assignment Lookup Table:

% D: Downlink Subframe
% S: Special Subframe
% U: Uplink Subframe

switch LTE.SUBFRAMES_DIRECTION
    case enum.modem.lte.SubframesDirection.CONFIG_0
        SUBFRAMES_DIRECTION = [ 'D' 'S' 'U' 'U' 'U' 'D' 'S' 'U' 'U' 'U' ];

    case enum.modem.lte.SubframesDirection.CONFIG_1
        SUBFRAMES_DIRECTION = [ 'D' 'S' 'U' 'U' 'D' 'D' 'S' 'U' 'U' 'D' ];

    case enum.modem.lte.SubframesDirection.CONFIG_2
        SUBFRAMES_DIRECTION = [ 'D' 'S' 'U' 'D' 'D' 'D' 'S' 'U' 'D' 'D' ];

    case enum.modem.lte.SubframesDirection.CONFIG_3
        SUBFRAMES_DIRECTION = [ 'D' 'S' 'U' 'U' 'U' 'D' 'D' 'D' 'D' 'D' ];

    case enum.modem.lte.SubframesDirection.CONFIG_4
        SUBFRAMES_DIRECTION = [ 'D' 'S' 'U' 'U' 'D' 'D' 'D' 'D' 'D' 'D' ];

    case enum.modem.lte.SubframesDirection.CONFIG_5
        SUBFRAMES_DIRECTION = [ 'D' 'S' 'U' 'D' 'D' 'D' 'D' 'D' 'D' 'D' ];

    case enum.modem.lte.SubframesDirection.CONFIG_6
        SUBFRAMES_DIRECTION = [ 'D' 'S' 'U' 'U' 'U' 'D' 'S' 'U' 'U' 'D' ];

    otherwise
        error( 'Subframe Direction Configuration selected is not valid' );
end
