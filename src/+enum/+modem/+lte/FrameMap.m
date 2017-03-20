classdef FrameMap
%FRAMEMAP class defines the references for channel/signals positions on LTE frame.
%  For further description on signals and channels refer to 3GPP STANDARD
%  TS 36.211-v12.4.0
%
%   Read-Only Public Properties
%     PBCH - Physical Broadcast Channel
%     PDCCH - Physical Downlink Control Channel
%     PDSCH - Physical Downlink Shared Channel
%     SYNC_SIGNALS - Synchronization Signals
%     REF_SIGNALS - Reference Signals
%     EMPTY_SYMBOL - Null/forbidden Symbols (where the modem is assigned to the other link direction, for example)
%
%   Author: Rafhael Medeiros de Amorim (RMA)
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v1.0 04 Mar 2015 (RMA)- created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration

        PBCH
        PDCCH
        PDSCH
        SYNC_SIGNAL
        REF_SIGNAL
        EMPTY_SYMBOL

    end
end
