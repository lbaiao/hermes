classdef Statistics < handle
% STATISTICS class implements results storage and statistics computation.
%
%   Read-Only Public Properties:
%       snrVector < 1 x lengthSnr double > : Vector of SNR values.
%       confidenceLevel< double > : desired confidence level for
%           calculation of the error margin (0 < confidence Level < 1 )
%       berMean < 1 x lengthSnr double > : mean level of the measured bit
%           error rates (BER) for each SNR
%       blerMean < 1 x lengthSnr double > : mean level of the measured
%           block error rates (BlER) for each SNR
%       berErrorMargin < 1 x lengthSnr double > : error margin of the
%           measured BER for each SNR with the desired confidence. This is
%           the relative error margin.
%       blerErrorMargin < 1 x lengthSnr double > : error margin of the
%           measured BlER for each SNR with the desired confidence. This is
%           the relative error margin.
%
%   Public Methods:
%	Constructor
%		Syntax: this = simulatorCore.Statistics( SETTINGS )
%		Inputs:
%			SETTINGS < struct > : Simulation settings
% 
%   updateDrop
%       Syntax: updateDrop( dropDuration )
%           Update the drop number and drop statistics
%   
%   addNewFrameStats
%       Syntax: addNewFrameStats( snrIndex, numberOfBitErrors, ...
%                                 numberOfBits, numberOfBlockErrors, ... 
%                                 numberOfBlocks, throughput )
%           Add statistics from a new a frame
%       Inputs:
%           snrIndex < uint > index of the SNR value
%           numberOfBitErrors< uint >
%           numberOfBits< uint > - there was 'numberOfBitErrors' in
%              'numberOfBits' transmitted bits
%           numberOfBlockErrors< uint >
%           numberOfBlocks< uint > - there was 'numberOfBlockErrors' 
%              in 'numberOfBlocks' transmitted Blocks
%           throughput< uint > - number of effectively transmitted bits,
%               i.e., those in error-free packets
%
%   getMainStatistics
%       Syntax: mainStatistics getMainStatistics( )
%           Return main public statistics
%       Output
%           mainStatistics< struct > - struct containing the main public
%               properties. it has the following fields, corresponding to
%               the class properties:
%                   mainStatistics.snrVector
%                                 .confidenceLevel
%                                 .berMean
%                                 .blerMean
%                                 .berErrorMargin
%                                 .blerErrorMargin
%                                 .throughput
%       
%
%   Author: Fadhil Firyaguna (FF), Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <fadhil.firyaguna, andre.noll>@indt.org
%   History:
%       v1.0 26 Mar 2015 - created (FF, ANB)
%       v2.0 14 May 2015 - added throughput (ANB)
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

properties ( GetAccess = 'public', SetAccess = 'protected' )
	
    snrVector;

    confidenceLevel;
    
    berMean;
    blerMean;
    
    berErrorMargin;
	blerErrorMargin;
    
end

properties ( GetAccess = 'protected', SetAccess = 'protected' )
	
	maxNumberOfDrops;
	snrVectorSize;
	currentDrop;

    snrWasSimulated; % true if particular SNR was simulated in current drop

    berPerSnrAndDrop;
	blerPerSnrAndDrop;    

    numberOfBlocks;
    numberOfBlockErrors;
    numberOfBits;
    numberOfBitErrors;
    
    numberOfEffectiveBits;
    simulatedTime;
	
end
	
methods
	%constructor
	function this = Statistics ( SETTINGS )
		
		this.maxNumberOfDrops = SETTINGS.DROPS.MAX_NUMBER_OF_DROPS;
		this.snrVectorSize = length( SETTINGS.SNR.VECTOR_dB );
		this.currentDrop = 1;
        
        this.snrWasSimulated = false( 1, this.snrVectorSize );
		
        this.snrVector = SETTINGS.SNR.VECTOR_dB;
		this.berPerSnrAndDrop  = nan( this.maxNumberOfDrops, this.snrVectorSize );
		this.blerPerSnrAndDrop  = nan( this.maxNumberOfDrops, this.snrVectorSize );
        this.confidenceLevel = SETTINGS.DROPS.CONFIDENCE_LEVEL;
        
        this.berMean = zeros( 1, this.snrVectorSize);
        this.blerMean = zeros( 1, this.snrVectorSize);
        
        this.berErrorMargin = zeros( 1, this.snrVectorSize);
        this.blerErrorMargin = zeros( 1, this.snrVectorSize);
        
        this.numberOfBlocks = zeros( 1, this.snrVectorSize );
		this.numberOfBlockErrors = zeros( 1, this.snrVectorSize );
        this.numberOfBits = zeros( 1, this.snrVectorSize );
        this.numberOfBitErrors = zeros( 1, this.snrVectorSize );
        
        this.numberOfEffectiveBits = zeros( 1, this.snrVectorSize );
        this.simulatedTime = zeros( 1, this.snrVectorSize );
    end
    
    % updateDrop
	updateDrop( this, updateDrop )

    % addNewFrameStats
    addNewFrameStats( this, snrIndex, ...
                            numberOfBitErrors, numberOfBits, ...
                            numberOfBlockErrors, numberOfBlocks, ...
                            throughput );
                        
    % mainStatistics
    mainStatistics = getMainStatistics( this );
                                                
end

methods (Access = 'protected')
    [ sampleMean, errorMargin ] = calculateErrorMargin( this, sampleValues )
end

end