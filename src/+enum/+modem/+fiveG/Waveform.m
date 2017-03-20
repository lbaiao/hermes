classdef Waveform
%WAVEFORM class defines an enum list for the 5G waveform.
%
%   Read-Only Public Properties%   Enumeration values
%       OFDM
%       UFMC - Universal Filterbank Multicarrier
%       ZT_DS_OFDM - Zero-Tail DFT-Spread OFDM
%
%   Author: André Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 17 Apr 2015 (ANB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration
        OFDM 
        UFMC % Universal Filterbank Multicarrier 
        ZT_DS_OFDM % Zero-Tail DFT-Spread OFDM
        FBMC

    end
end
