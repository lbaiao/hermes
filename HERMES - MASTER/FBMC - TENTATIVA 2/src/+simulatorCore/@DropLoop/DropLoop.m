classdef DropLoop < handle
%DROPLOOP class implements the main simulator drops loop
%   The simulator uses stopping criteria in order to stop simulation.
%   Current implemented stopping criteria are:
%   - Maximum number of drops
%   - Confidence interval
%   When the stopping criteria is set to be the maximum number of
%   drops, the simulation stops when this number is achieved.
%   When Confidence interval is selected, for each value of SNR, the
%   simulator will calculate the confidence interval of the selected
%   parameter. Therefore, for each drop, and for each value of SNR, the
%   simulator will update the confidence interval. When there are
%   enough drops to achieve the selected confidence interval, the
%   simulation stops for that specific value of SNR, and will continue
%   for all other values.
%
%   Confidence interval is defined as an estimated range of values
%   which is likely to include an unknown population parameter. In this
%   simulation, the population parameter we are interested in is the
%   BLER (or BER) mean. Therefore, when we set as a parameter the
%   confidence level to be 95%, we are saying that we are 95%
%   confident that the interval contains the true population mean. The
%   interval is calculated using a t-student distribution, with n
%   degrees of freedom, where n = number of drops - 1;
%
%   Besides the confidence interval, we also define an margin of error.
%   This relative error is added or subtracted from the sample mean which
%   determines the length of the interval.
%
% Read-Only Public Properties:
%    currentDrop < 1 x 1 int > - current simulation drop.
%    timeStamp  < 1 x 1 int > - define time stamp
%
%  Methods
%    Constructor
%       Syntax: this = simulatorCore.DropLoop( SETTINGS )
%
%       Inputs:
%           SETTINGS <STRUCT>: contains simulation settings
%
%   Public Methods
%       runLoop( statistics, scenario )
%           This method runs the simulation loop until a stopping
%           criteria is met.
%
%           Syntax: runLoop ( statistics, scenario );
%
%           Inputs:
%             statistics < object > - object from Statistics class
%		      scenario < object > - object from Scenario class
%
%   Author: Erika Portela Lopes de Almeida (EA)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org.br
%   History:
%       v1.0 05 Feb 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    properties ( GetAccess = 'public', SetAccess = 'protected' )

        currentDrop;
        timeStamp;
        

    end

    properties ( GetAccess = 'protected', SetAccess = 'protected' )

        stoppingCriteria;
        maximumNumberOfDrops;
        minimumNumberOfDrops;
        confidenceLevel;
        errorMargin;
        snrVector;
        snrType;
        dropDuration;
        metStoppingCriteriaPerSNR;
        showProgress;
        displayInterval;

    end

    methods

        % constructor
        function this = DropLoop( SETTINGS )

            this.stoppingCriteria = SETTINGS.DROPS.STOPPING_CRITERIA;

            this.currentDrop = 0;

            this.maximumNumberOfDrops = SETTINGS.DROPS.MAX_NUMBER_OF_DROPS;

            this.minimumNumberOfDrops = SETTINGS.DROPS.MIN_NUMBER_OF_DROPS;

            this.confidenceLevel = SETTINGS.DROPS.CONFIDENCE_LEVEL;

            this.errorMargin = SETTINGS.DROPS.ERROR_MARGIN;

            this.metStoppingCriteriaPerSNR = ...
                false( 1, length( SETTINGS.SNR.VECTOR_dB ) );

            this.snrVector = SETTINGS.SNR.VECTOR_dB;

            this.snrType = SETTINGS.SNR.TYPE;

            this.timeStamp = 0;

            this.dropDuration = SETTINGS.DROPS.DURATION;
            
            this.showProgress = SETTINGS.SHOW_PROGRESS;
            
            this.displayInterval = SETTINGS.DISPLAY_INTERVAL;
        end

        % method runLoop
        runLoop( this, statistics, scenario );

        % method checkAllStopCriteria
        out = checkAllStopCriteria(  this, blerStatistics );

        % method checkStoppingCriterion
        metStoppingCriterion = checkStoppingCriterion( this, sampleValues, index );
        
    end

end
