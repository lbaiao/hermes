classdef ( Abstract ) FrameAssembler < handle
% FRAMEASSEMBLER class implements the Frame Assembler in the Tx/Rx Modem
%
%   Read-Only Public Properties:
%		bandwidth_MHz <double> - Frame Bandwidth [MHz]
%		numberOfTxAntennas < int > - Number of Antennas used in 
%                                    transmission
%		duration < double > - Frame Duration [s]
%       numberOfBlocks < unsigned > - number of symbols in the time domain
%           domain in a simulation frame ('duration' seconds)
%		availableDataSymbols < int > - Number of Data Symbols available to
%           be transmitted in the Frame
%       availableControlSymbols < int > - Number of Control Symbols 
%           available to be transmitted in the Frame
%       dataLoad < double > - ratio of data symbols in relation to the
%                             overall symbols
%       frameMap < F x T x N > - Frame Map with the content type (control, 
%                             reference, data) of every symbol in the Frame 
%                       F: # of Frame Frequency Samples (e.g. OFDM 
%                             Subcarriers)
%                       T: # of Frame Time Samples (e.g. OFDM Symbols)
%                       N: # of Tx Antennas used
%
%   Methods
%  fillFrame 
%      Assembles the frame with the data symbols to be transmitted.
%      *Frame filling is performed according to 'frameMap' attribute
%      of the frame object.
%      *Currently, only Data Symbols are being mapped into Tx Frame.
%      Control and reference signals are following an
%      arbitrary filling.
%
%      Syntax: [ txFrame ] = fillFrame( dataVector )
%
%      Inputs:
%          dataVector < N x Msymb complex > - Vector with symbols to be
%          transmitted in the frame
%                  N: Number of Tx Antennas
%                  Msymb: Number of Symbols to be transmitted
%
%      Output:
%           txFrame < F x T x M complex > - Assembled frame
%                  F: Subcarriers
%                  T: Symbols in time domain
%                  M: Number of Rx Antennas
%
%   readFrame 
%       Disassembles the frame and provides the DataSymbols vector
%       *Frame reading is performed according to 'frameMap' attribute
%       of the frame object.
%       *Currently, only Data Symbols are being read in the Rx Frame.
%       Control and reference signals reading is not supported
%
%       Syntax: [ dataVector, noiseVarianceOut ] = readFrame( rxFrame , ...
%                                                  noiseVariance )
%
%       Inputs:
%           rxFrame < F x T x N complex > - Received frame
%                   F: Subcarriers
%                   T: Symbols in time domain
%                   N: Number of Tx Antennas
%           noiseVariance < F x T x N complex > - Frame with the value
%               of noise variance.
%       Output:
%           dataVector < M x Msymb complex > - Data Vector with
%                   received Symbols
%                   M: Number of Receiver Antennas
%                   Msymb: Number of Received Data Symbols
%           noiseVarianceOut < M x Msymb complex > - Vector with noise
%           variance for each received Symbol.
%
%   resetFrame
%       resets FrameAssembler object to its initial configuration
%   
%   	Syntax: resetFrame(  )

%
%   setNumberOfAntennas
%       Set the number of Tx and Rx Antennas expected for the frame to
%       be transmitted.
%   
%   	Syntax: setNumberOfAntennas( numberOfAntennas )
%       Input:
%           numberOfAntennas < 1 x 1 int > - Number of expected
%           antennas.

%
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v1.0 24 Feb 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    properties ( GetAccess = 'public', SetAccess = 'protected')
        bandwidth_MHz
        numberOfAntennas
        duration
        frameMap
        dataLoad
        numberOfBlocks
    end
    
    properties ( GetAccess = 'protected', SetAccess = 'protected')
        availableDataSymbols
        availableControlSymbols
        
    end
    
    methods 
        txFrame = fillFrame( this, dataVector )
        [ dataVector, noiseVarianceOut ] = readFrame( this, rxFrame, ...
                                                   noiseVariance )
        setNumberOfAntennas( this, numberOfAntennas )
        function resetFrame( this )
        end
    end

    methods( Access = 'protected' )
        %map design for frame assembling
        frameMapDesign ( this )
        
        updateFrameCount( this )
    end
end

