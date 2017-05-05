classdef SubframesDirection
%SUBFRAMEDIRECTIONCONFIG class defines the references for Uplink/Downlink
%  direction assignments for subframes on LTE TDD Frame.
%  For further description on those configurations use STANDARD
%  TS 36.211-v12.4.0, Table 4.2-2, Page 12.
%  The value assigned by each configuration can be read from:
%  lookuptable.modem.lte.lookupSubframesConfig
%
%   Read-Only Public Properties
%        CONFIG_1
%        CONFIG_2
%        CONFIG_3
%        CONFIG_4
%        CONFIG_5
%        CONFIG_6
%
%   Author: Rafhael Medeiros de Amorim (RMA)
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v1.0 04 Mar 2015 (RMA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration

        CONFIG_0
        CONFIG_1
        CONFIG_2
        CONFIG_3
        CONFIG_4
        CONFIG_5
        CONFIG_6

    end
end
