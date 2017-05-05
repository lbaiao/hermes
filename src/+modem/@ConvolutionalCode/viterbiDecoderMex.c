/*
%   viterbiDecoderMex implements the viterbi decoder in a MEX file.
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
    
    /*  First Input Argument: */
    double *outputMetric = mxGetPr( prhs [ 1 ] );		/* Calculated Output Metrics for each state transition */
    int trellisDepth = mxGetN( prhs [ 1 ] );				/* Trellis Depth */
    int numOfOutputSymbols = mxGetM( prhs [ 1 ] );		/* Number of Possible Ouptut Symbols */
    /* ( 2^L, where L is the number of Output Bits in the trellis) */
    /* Second Input Argument: */
    double *trellisNextState = mxGetPr( prhs [ 2 ] );	/* Matrix with Transition to Next States */
    /* ( N x M: N is the Number of States, M is the number of Symbols) */
    int numOfStates = mxGetM(prhs [ 2 ] );				/* Number of Shift Registers Memory States (2^S: S is the number of Shift Registers) */
    int numOfInputSymbols = mxGetN( prhs[ 2 ] );		/* Number of Possible Input Symbols (2^P: P is the number of Input Bits) */
    /* Third Input Argument */
    double *trellisNextOutput = mxGetPr( prhs [ 3 ] );	/* Matrix with Trellis Output Values. N x M
    
    /* ---------------------- Output Declaration -------------------------------------
    
    First Output Argument - Decoded Bits Vector:  
    */
    plhs [ 0 ] = mxCreateDoubleMatrix( 1, trellisDepth, mxREAL );
	double *decodedInput = mxGetPr(plhs[0]);
    
    /* ---------------------- Path Metric Calculation --------------------------------- */
    double *pathMetric;		 /* Storage for Trellis Paths' Metric  */
    pathMetric = (double*)malloc( numOfStates * ( trellisDepth + 1 ) * sizeof(double) );
    
    double *survivorState;		 /* Storage for Previous Survivor States for each Path */
    survivorState = (double*)malloc( numOfStates * ( trellisDepth + 1 ) * sizeof(double) );  
    
    double *outputMetricAux;		 /* Auxiliar Variable Used for Calculate the Metric for each
                                    Transition in the Trellis */
    outputMetricAux = (double*)malloc(numOfOutputSymbols * sizeof(double));
    
    double *survivorInput;		 /* Storage of Inputs from Previous Survivor States leading to current States */
    survivorInput = (double*)malloc( numOfStates * ( trellisDepth + 1 ) * sizeof(double));
        
    int counter, stateCount, inputCount;  /* Auxiliar Variables used for Loop Incrementation */
    int currentStep, nextStep; /* Auxiliar Variables: identifiers for algorithm steps. 
                                 ( Maximum Number of Steps = Trellis Depth ). */
    int nextOutput, nextState; /* Auxiliar Variables, used to identify each transition on the trellis */
    double transitionMetric; /* Metric of the Current State Transition being evaluated */
    
    
    /* Initialization of Path Metrics and Survivor States for 1st Step of Decoder Algorithm: */
    for ( counter = 0; counter < (trellisDepth + 1) * numOfStates; counter++ ){
        pathMetric [ counter ] = INF;
        survivorState [ counter ] = INF;
    }
    /* Initial State set to 0: */
    pathMetric [ 0 ] = 0;
    

   
    
    /* Start trellis Calculation: */
    for ( currentStep = 0; currentStep < trellisDepth; currentStep++ ){
        nextStep = currentStep + 1;
        /* Store the Metric for every possible output.*/
        for ( counter = 0; counter < numOfOutputSymbols; counter++ ){
            outputMetricAux [ counter ] = outputMetric[ currentStep * numOfOutputSymbols + counter];
        }
        
        for ( inputCount = 0; inputCount < numOfInputSymbols; inputCount++ ){
            /* For every possible input... */
            for ( stateCount = 0; stateCount < numOfStates; stateCount++ ){
                /* ... for every state in the trellis: */
                nextOutput = trellisNextOutput[ stateCount + ( inputCount * numOfStates ) ]; /* Check the Output Produced */
                nextState = trellisNextState[ stateCount + ( inputCount * numOfStates ) ]; /* Check the next State in the shift registers*/
                /* Calculate the Metric associated to this transition: */
                transitionMetric = outputMetricAux[ nextOutput ] + pathMetric[ stateCount + ( currentStep * numOfStates ) ]; 
                
                /* Check if the Metric for this transition is lower than the survivor metric */
                /* leading to the next state: */
                if ( transitionMetric < pathMetric[ nextState + ( nextStep * numOfStates ) ] ){
                    /* If not, update the survivor path: */
                    pathMetric [ nextState + ( nextStep * numOfStates ) ] = transitionMetric; /* Path Metric Update */
                    survivorState [ nextState + ( nextStep * numOfStates ) ] = stateCount; /* Previous Survivor State Update */
                    survivorInput [ nextState + ( nextStep * numOfStates ) ] = inputCount; /* Survivor Input Update */
                }
            }
        }
    }
       
    /* ---------------------- Traceback Algorithm --------------------------------- */
    int index = trellisDepth * numOfStates; /* Index of Last Step of the Trellis */
    double winningMetric = pathMetric [ index ]; /* Auxiliar Variable to check the last Survivor State */
    double winningState; /* Store the survivor State from the last step of the trellis */
    winningState = 0; 
    
    /* Check which state is the survivor for the last trellis step: */
    for ( counter = 0; counter < numOfStates; counter++ ){
        if ( pathMetric[ counter + index] < winningMetric ){
            winningMetric = pathMetric[ counter + index ]; /* Winning Metric Update */
            winningState = counter; /* Winning State Update */
        }
    }
    
    /* Step Back in the path: */
    for (counter = trellisDepth; counter > 0; counter--){
        index = counter * numOfStates + winningState; 
        decodedInput[ counter - 1 ] = survivorInput[ index ]; /* Store the decoded Input */
        winningState = survivorState[ index ]; /* Go one step back in the trellis */
    }
    free( outputMetricAux );
    free( survivorInput );
    free( pathMetric );
    free( survivorState );
}