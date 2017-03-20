classdef PacketFormat
%PACKETFORMAT defines a ENUM list for WiFi packet format
%
%   Read-Only Public Properties
%       NON_HT - Legacy 802.11a (not supported)
%       HT_MF  - High Throughput 802.11n Mixed field (not supported)
%       HT_GF  - High Throughput 802.11n green field (not supported)
%       VHT    - Very High Throughput 802.11ac packet format
%  
%   Only VHT is supported for the current version
%
%   Author: Bruno Faria (BF)
%   Work Address: INDT Brasília
%   E-mail: bruno.faria@indt.org.br
%   History:
%       v2.0 19 Jun 2015 (BF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration
        
        NON_HT
        HT_MF
        HT_GF
        VHT
        
    end
    
end

