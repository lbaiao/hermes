function addNewFrameStats( this, snrIndex, numberOfBitErrors, ...
                           numberOfBits, numberOfBlockErrors, ...
                           numberOfBlocks, throughput )
% STATISTICS.ADDNEWFRAMESTATS add new frame statistics to a drop
%   Detailed information in class header
%
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       V1.0 08 Apr 2015 - (ANB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
	
this.snrWasSimulated( snrIndex ) = true;

this.numberOfBlocks( snrIndex ) = this.numberOfBlocks( snrIndex ) + ...
                                   numberOfBlocks;
this.numberOfBlockErrors( snrIndex ) = this.numberOfBlockErrors( snrIndex ) + ...
                                        numberOfBlockErrors;                               
this.numberOfBits( snrIndex ) = this.numberOfBits( snrIndex ) + ...
                                   numberOfBits;
this.numberOfBitErrors( snrIndex ) = this.numberOfBitErrors( snrIndex ) + ...
                                        numberOfBitErrors;                                     
this.numberOfEffectiveBits( snrIndex ) = ...
    this.numberOfEffectiveBits( snrIndex ) + throughput;

end
