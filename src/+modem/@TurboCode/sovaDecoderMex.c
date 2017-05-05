/*
%   sovaDecoderMex implements the viterbi decoder in a MEX file.
% 
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v2.0 29 Apr 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
*/
#include "mex.h"
#include <stdio.h>
#include <stdlib.h>

#define INF 9E+9 /* Auxiliar Variable in Path Metric Initialization. */

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    /* ------------------------ INPUT Declaration ----------------------------------- */
    
    /* First Input Argument: */
    double *outputMetric = mxGetPr( prhs [ 1 ] );		/* Calculated Output Metrics for each state transition */
    int trellisDepth = mxGetN( prhs [ 1 ] );				/* Trellis Depth */
    int numOfOutputSymbols = mxGetM( prhs [ 1 ] );		/* Number of Possible Ouptut Symbols
                                                    ( 2^L, where L is the number of Output Bits in the trellis) */
    /* Second Input Argument: */
	double *extrinsicInformation = mxGetPr(prhs [ 2 ] ); /* Extrinsic Info for Sova Decoder. */
	/* Third Input Argument: */
    double *trellisNextState = mxGetPr( prhs [ 3 ] );	/* Matrix with Transition to Next States */
                                                        /* ( N x M: N is the Number of States, M is the number of Symbols) */
    int numOfStates = mxGetM(prhs [ 3 ] );				/* Number of Shift Registers Memory States (2^S: S is the number of Shift Registers) */
    int numOfInputSymbols = mxGetN( prhs[ 3 ] );		/* Number of Possible Input Symbols (2^P: P is the number of Input Bits) */
    /* Fourth Input Argument */
    double *trellisNextOutput = mxGetPr( prhs [ 4 ] );	/* Matrix with Trellis Output Values. N x M */

    
    /* ---------------------- Output Declaration ------------------------------------- */
    
    /* First Output Argument - Decoded Bits Vector:    */ 
    plhs [ 0 ] = mxCreateDoubleMatrix( 1, trellisDepth, mxREAL );
	double *decodedInput = mxGetPr(plhs[0]);
    
    /* ---------------------- Path Metric Calculation --------------------------------- */
	double *outputMetricAux;		 /* Auxiliar Variable Used Transitions Metric for each Output in the Trellis */
	outputMetricAux = (double*)malloc(numOfOutputSymbols * sizeof(double));

    double *pathMetric;		 /* Storage for Trellis Paths' Metric  */
    pathMetric = (double*)malloc( numOfStates * ( trellisDepth + 1 ) * sizeof(double) );
    
    double *survivorState;		 /* Storage for Previous Survivor States for each Path */
    survivorState = (double*)malloc( numOfStates * ( trellisDepth + 1 ) * sizeof(double) );  
    
    double *survivorInput;		 /* Storage of Inputs from Previous Survivor States leading to current States */
    survivorInput = (double*)malloc( numOfStates * ( trellisDepth + 1 ) * sizeof(double));

	double *competitorState;		 /* Storage for Previous Competitor States for each Path */
	competitorState = (double*)malloc(numOfStates * (trellisDepth + 1) * sizeof(double));

	double *competitorInput;		 /* Storage of Inputs from Previous Competitor States leading to current States */
	competitorInput = (double*)malloc(numOfStates * (trellisDepth + 1) * sizeof(double));
    
	double *delta;		 /* Storage of Delta between Competitor and Survivor Metrics */
	delta = (double*)malloc(numOfStates * (trellisDepth + 1) * sizeof(double));
	    
    int counter, stateCount, inputCount, timeIndexCounter;  /* Auxiliar Variables used for Loop Incrementation */
    int currentStep, nextStep; /* Auxiliar Variables: identifiers for algorithm steps. ( Maximum Number of Steps = Trellis Depth ). */
    int nextOutput, nextState; /* Auxiliar Variables, used to identify each transition on the trellis */
    double transitionMetric; /* Metric of the Current State Transition being evaluated */
    
    
    /* Initialization of Path Metrics and Survivor States for 1st Step of Decoder Algorithm: */
    for ( counter = 0; counter < (trellisDepth + 1) * numOfStates; counter++ ){
        pathMetric [ counter ] = INF;
        survivorState [ counter ] = 0;
		survivorInput [ counter ] = 0;
		delta [ counter ] = 0;
		survivorInput [ counter ] = 0;
		competitorInput [ counter ] = 0;
    }
    /* Initial State set to 0: */
    pathMetric [ 0 ] = 0;
    

   
    
    /* Start trellis Calculation: */
    for ( currentStep = 0; currentStep < trellisDepth; currentStep++ ){
        nextStep = currentStep + 1;
        /* Store the Metric for every possible output. */
        for ( counter = 0; counter < numOfOutputSymbols; counter++ ){
            outputMetricAux [ counter ] = outputMetric[ currentStep * numOfOutputSymbols + counter];
        }
        
        for ( inputCount = 0; inputCount < numOfInputSymbols; inputCount++ ){
            /* For every possible input... */
            for ( stateCount = 0; stateCount < numOfStates; stateCount++ ){
                /* ... for every state in the trellis: */
                nextOutput = trellisNextOutput[ stateCount + ( inputCount * numOfStates ) ]; /* Check Output Produced */
                nextState = trellisNextState[ stateCount + ( inputCount * numOfStates ) ]; /* Check State in  shift registers */
                /* Calculate the Metric associated to this transition: */
                transitionMetric = outputMetricAux[ nextOutput ] + pathMetric[ stateCount + ( currentStep * numOfStates ) ]; 
				transitionMetric = transitionMetric + extrinsicInformation[ currentStep + inputCount * trellisDepth ];
                /* Check if the Metric for this transition is lower than the survivor metric */
                /* leading to the next state: */
                if ( transitionMetric < pathMetric[ nextState + ( nextStep * numOfStates ) ] ){
                    /* If so, the previous survivor is downgraded  to competitor status... */
					delta[nextState + (nextStep * numOfStates)] = transitionMetric - pathMetric[ nextState + ( nextStep * numOfStates )];
					competitorState [ nextState + ( nextStep * numOfStates ) ] = survivorState[ nextState + ( nextStep * numOfStates ) ];
					competitorInput [ nextState + ( nextStep * numOfStates ) ] = survivorInput[ nextState + ( nextStep * numOfStates ) ];
					/* ... and the current trellis path is now the survivor: */
                    pathMetric [ nextState + ( nextStep * numOfStates ) ] = transitionMetric; /* Path Metric Update */
                    survivorState [ nextState + ( nextStep * numOfStates ) ] = stateCount; /* Previous Survivor State Update */
                    survivorInput [ nextState + ( nextStep * numOfStates ) ] = inputCount; /* Survivor Input Update */

				} /* Check if the current transitions is better than the stored competitor */
				else if (transitionMetric - pathMetric[nextState + (nextStep * numOfStates)] >=
					delta[nextState + (nextStep * numOfStates)]) {
					/* Update the competitor */
					delta[ nextState + ( nextStep * numOfStates ) ] = pathMetric[nextState + (nextStep * numOfStates) ] - transitionMetric; 
					competitorState[ nextState + ( nextStep * numOfStates ) ] = stateCount; /* Previous Survivor State Update */
					competitorInput[ nextState + ( nextStep * numOfStates ) ] = inputCount; /* Survivor Input Update */
				}
            }
        }
    }
       
    /* ---------------------- Traceback and Sova Update Algorithms --------------------------------- */
	double tempDelta = 0;		 /* Storage min delta to Soft Output Updates (SOVA). */
	double *reliability;		 /* Storage of Delta between Competitor and Survivor Metrics */
	reliability = (double*)malloc( ( trellisDepth ) * sizeof(double));
	for (counter = 0; counter < trellisDepth; counter++){
		reliability [ counter ] = -INF;

	}

    int index = trellisDepth * numOfStates; /* Index of Last Step of the Trellis */
	int competingIndex = 0;
    double winningMetric = pathMetric [ index ]; /* Auxiliar Variable to check the last Survivor State */
    double winningState, competingState, winningStateTemp; /* Store the survivor State from the last step of the trellis */
    winningState = 0;  
	winningStateTemp = 0;
	competingState = 0;
	double survInput, compInput;
	survInput = 0;
	compInput = 0;

    /* Check which state is the survivor for the last trellis step: */
    for ( counter = 0; counter < numOfStates; counter++ ){
        if ( pathMetric[ counter + index] < winningMetric ){
            winningMetric = pathMetric[ counter + index ]; /* Winning Metric Update */
            winningState = counter; /* Winning State Update */
        }
    }
    
    /* Start the traceback algorithm : */
    for (counter = trellisDepth; counter > 0; counter--){
        index = counter * numOfStates + winningState; 
		
		survInput =			survivorInput [ index ];		/* SOVA Survivor bit output */
		compInput =			competitorInput [ index ];		/* SOVA Competitor bit output */
		winningStateTemp =  survivorState [ index ];		/* SOVA Survivor State */
		competingState =	competitorState [ index ];		/* SOVA Competitor State */
		tempDelta =			delta [ index ];				/* SOVA Store the delta. */
		
		decodedInput[ counter - 1 ] = survInput; /* Store the decoded Input */
        
        /* Reliability for the current Decoded Trellis Input: */
		if (tempDelta > reliability[counter - 1]) {
            /* If the decoded reliability is lower ( in absolute value) 
             * than the update reliability no action is taken */
					reliability[counter - 1] = tempDelta;
				}
        /* Apply The Sova where stepping Back In the trellis:	*/
		for (timeIndexCounter = 1; timeIndexCounter <= counter; timeIndexCounter++){

			/* Update Reliability when survivor input and competing input differ: */
			if (survInput != compInput){
				if (tempDelta > reliability[counter - timeIndexCounter]) {
					reliability[counter - timeIndexCounter] = tempDelta;
				}
			} 
			/* Reliability Updated. */
            /* No need to Continue if winning State and Competing State are the same. */
			if ( winningStateTemp == competingState ) { break; } 
			if ( timeIndexCounter == counter ){ break; }
			
            /* Update Temporary Indexes in the SOVA Update Process: */
			index = (counter - timeIndexCounter) * numOfStates + winningStateTemp;
			competingIndex = (counter - timeIndexCounter) * numOfStates + competingState;

			survInput =		 survivorInput[ index ];		/* SOVA Survivor bit output */
			compInput =		 survivorInput[ competingIndex ];		/* SOVA Competitor bit output */
			winningStateTemp =	 survivorState[ index ];		/* SOVA Survivor State */
			competingState = survivorState[ competingIndex ];		/* SOVA Competitor State */


		}
        /* Step Back in the trellis: */
		index = counter * numOfStates + winningState;
        winningState = survivorState[ index ]; /* Go one step back in the trellis */
		
    }

	/* Produce the Output LLR: */
	for (counter = 0; counter < trellisDepth; counter++){
		decodedInput[counter] = (decodedInput[counter] * 2 - 1) * reliability[counter] / 2 * -1;
	}

    free( outputMetricAux );
    free( pathMetric );
	free( survivorState );
	free( survivorInput );
	free( competitorState );
	free( competitorInput );
	free( delta );
	free( reliability );
}