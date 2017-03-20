function updateDrop( this, dropDuration )
% STATISTICS.UPDATEDROP add new frame statistics to a drop.
%   Detailed information in class header.
%
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 08 Apr 2015 - ( ANB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


for snrIndex = 1 : this.snrVectorSize
    
    if( this.snrWasSimulated( snrIndex ) )
       
        this.berPerSnrAndDrop( this.currentDrop, snrIndex ) = ...
            this.numberOfBitErrors( snrIndex ) / ...
            this.numberOfBits( snrIndex );
        this.blerPerSnrAndDrop( this.currentDrop, snrIndex ) = ...
            this.numberOfBlockErrors( snrIndex ) / ...
            this.numberOfBlocks( snrIndex );
        
       
        [ this.berMean( snrIndex ), ...
          this.berErrorMargin( snrIndex ) ] = ...
            this.calculateErrorMargin( this.berPerSnrAndDrop(:, snrIndex) );  
        [ this.blerMean( snrIndex ), ...
          this.blerErrorMargin( snrIndex ) ] = ...
            this.calculateErrorMargin( this.blerPerSnrAndDrop(:, snrIndex) ); 
        
        this.simulatedTime( snrIndex ) = this.simulatedTime( snrIndex ) + ...
                                         dropDuration;
    end
    
    
end

this.currentDrop = this.currentDrop + 1;
this.snrWasSimulated = false( 1, this.snrVectorSize );

this.numberOfBlocks = zeros( 1, this.snrVectorSize );
this.numberOfBlockErrors = zeros( 1, this.snrVectorSize );
this.numberOfBits = zeros( 1, this.snrVectorSize );
this.numberOfBitErrors = zeros( 1, this.snrVectorSize );


end
