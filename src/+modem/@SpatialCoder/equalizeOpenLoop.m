function [ equalizedSignal ] = equalizeOpenLoop( this, mimoSignal, ...
                                                       channel )
%SPATIALCODER.EQUALIZEOPENLOOP decodes multiple streams transmited by multiplexing.
%   For large-delay cyclic delay diversity (CDD), decoding for spatial
%   multiplexing is defined by this method, according to [1]. The values of
%   the precoding matrix PM shall be selected among the precoder elements
%   in the codebook.
%   
% [1] 3GPP TS 36.211 v10.7.0 Release 10
%
%   Syntax: [ equalizedSignal ] = equalizeOpenLoop( mimoSignal, ...
%                                                   channel ) 
%   Input:
%       mimoSignal < Nsymb x NRx complex > - received signal.
%           Nsymb: number of symbols in the frame.
%           NRx: number of receive antennas.
%       channel < Nsymb x NRx x NTx complex > - channel gain at each data
%           symbol.
%           Nsymb: number of symbols in the frame.
%           NRx: number of receive antennas.
%           NTx: number of transmit antennas.
%   Output:
%       equalizedSignal < Nsymb x 1 complex > - decoded symbols.
%       	Nsymb : number of data symbols in the frame.
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 12 May 2015 (FF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied. 

% transpose for matrix operations
Y = mimoSignal.';
numberOfElements = size( mimoSignal, 1 );
numberOfLayers = this.numberOfTxAntennas;

% initiate output
numberOfStreams = this.numberOfRxAntennas;
equalizedSignal = zeros( numberOfStreams, numberOfElements );

% matrix U from table 6.3.4.2.2-1 in [1]
U = lookupTables.modem.lte.getLargeDelayCddMatrixU( numberOfLayers );
        

% According to [1] Sec. 6.3.4.2.2, p.59, the codebook index is given by:
sym = 1 : numberOfElements;
switch numberOfLayers
    case 2
        codebookIndex = zeros( size( sym ) );
    case 4
        codebookIndex = mod( floor( sym / numberOfLayers ), 4 ) + 12;
end

% precoding operation
for sym = 1 : numberOfElements
    
    % Precoding matrix as defined in [1] Sec. 6.3.4.3, p. 61
    precodingMatrix = lookupTables.modem.lte.getPrecodingMatrix( this.mimoScheme, ...
                                                    this.numberOfTxAntennas, ...
                                                    codebookIndex( sym ), ...
                                                    numberOfLayers );

    % diagonal matrix supporting cyclic delay diversity
    D = lookupTables.modem.lte.getLargeDelayCddMatrixD( numberOfLayers, sym );
    
    H = squeeze( channel( sym, :, : ) );

    Z = pinv( H * precodingMatrix * D * U ) * Y( :, sym );
    equalizedSignal( :, sym ) = Z;
end

% transpose for standard output format
equalizedSignal = reshape( equalizedSignal, numberOfElements * numberOfStreams, 1 );


end

