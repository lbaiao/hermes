classdef FrameMap
%FRAMEMAP class defines the references for channel/signals positions on 5G
%         frame.
%
%   Enumeration values
%       DL_CONTROL
%       UL_CONTROL
%       REF_SIGNAL
%       DATA
%       GUARD
%       EMPTY_SYMBOL
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

        EMPTY_SYMBOL
        DL_CONTROL % Downlink Control
        UL_CONTROL % Uplink Control
        REF_SIGNAL % Demodulation Reference
        DATA
        GUARD % Guard Interval


    end
    
end
