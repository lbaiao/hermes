/*
%   convEncoderMex encodes the input stream using a Conv. Encoder.
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

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    /* ------------------------ INPUT Declaration ----------------------------------- */
    
    /*  First Input Argument: Bit Array */
    double *inputArray = mxGetPr( prhs [ 1 ] );		/* InputStream */
    int arraySize = mxGetN( prhs [ 1 ] );				/* Trellis Depth */
    /* Second Input Argument: Trellis Next States */
    double *trellisNextState = mxGetPr( prhs [ 2 ] );	/* Matrix with Transition to Next States */
    int numOfStates = mxGetM(prhs [ 2 ] );	
    /* Third Input Argument: Trellis Next Output */
    double *trellisNextOutput = mxGetPr( prhs [ 3 ] );	/* Matrix with Trellis Output Values. N x M
    
    /* ---------------------- Output Declaration -------------------------------------
   First Output Argument - Decoded Bits Vector:  
    */
    plhs [ 0 ] = mxCreateDoubleMatrix( 1, arraySize, mxREAL );
	double *encodedArray = mxGetPr(plhs[0]);
    
    /* ----------------------- Encoder ----------------------------------------------- */
    int currentState = 0;
    int currentOutput;
    int stepCount;
    int inputSymbol;
    
    for ( stepCount = 0;  stepCount < arraySize;  stepCount++ ){ 
         /* Input Symbol: */
        inputSymbol =  inputArray[  stepCount ];
        /* Next Output: */
        encodedArray[ stepCount ] = trellisNextOutput[ currentState + numOfStates * inputSymbol ];
        /* Next Trellis State: */
        currentState = trellisNextState[ currentState + numOfStates * inputSymbol ];
    }
 
}