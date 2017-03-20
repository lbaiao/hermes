function decodedBits = decode( this, llrEstimation )
%WIFIENCODER.DECODE Decodes LLR estimations convolutional encoder
%   Detailed description can be found in class header.
%
%   Author: Bruno Faria (BF)
%   Work Address: INDT Brasília
%   E-mail: bruno.faria@indt.org.br
%   History:
%       v2.0 02 Jul 2015 (BF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

depuncturedArray = this.puncturer.depuncturing( llrEstimation );
decodedBits = this.convEncoder.decode( depuncturedArray );
    
end
