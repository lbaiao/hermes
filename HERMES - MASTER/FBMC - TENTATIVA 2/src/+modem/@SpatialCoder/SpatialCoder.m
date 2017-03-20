classdef SpatialCoder < handle
%SpatialCoder class defines MIMO implementations.
%   This class handles MIMO attributes and parameters, and its methods are
%   responsible for preparing modulated symbols to multiple transmit
%   streams, and for decoding the multiple receive streams into data
%   symbols.
% 
%   Read-Only Public Properties:
%   	mimoScheme < enum.modem.lte.mimoScheme > - MIMO transmission scheme
%           enumerator type.
%       spatialCodeRate < 1 x 1 double > - spatial code tranmission scheme
%           capacity.
%   
%   Methods:
%   Constructor
%       Syntax: this = modem.SpatialCoder( technology )
%       Input:
%           technology < struct > - technology parameter settings.
%               technology.MIMO_SCHEME < enum > -  MIMO transmission scheme
%               enumerator type.
%
%   setNumberOfAntennas
%   	Syntax: setNumberOfAntennas( numberOfTxAntennas, numberOfRxAntennas )
%           Set the number of Tx and Rx Antennas of the modem.
%       Input:
%           numberOfTxAntennas < 1 x 1 int > - Number of transmit antennas.
%           numberOfRxAntennas < 1 x 1 int > - Number of receive antennas.
% 
%   precode
%       Syntax: [ precodedSymbols ] = precode( modulationSymbols )
%           Prepare transmit data symbols to MIMO transmission.
%       Input:
%           modulationSymbols < Nsym x 1 complex > - modulated codewords.
%               Nsym: number of codeword symbols.
%       Output:
%           precodedSymbols < Nsym x Ntx complex > - precoded codewords.
%               Nsym: number of symbols transmitted in each antenna.
%               Ntx: number of transmit antennas.
% 
%   equalize
%       Syntax: [ equalizedSignal ] = equalize( mimoSignal, ...
%                                               channel ) 
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
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasilia
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 23 Apr 2015 (FF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    

properties( GetAccess = 'public', SetAccess = 'protected' )
    
    mimoScheme;
    spatialCodeRate;
    
end

properties( GetAccess = 'protected', SetAccess = 'protected' )
    
    numberOfTxAntennas;
    numberOfRxAntennas;
    userPrecodingMatrix;
    doPrecode;
    doEqualize;
    
end

methods( Access = 'public' )
% constructor
    function this = SpatialCoder( technology )
        this.mimoScheme = technology.MIMO_SCHEME;
        
        switch this.mimoScheme
            case enum.modem.MimoScheme.NONE
                this.spatialCodeRate = 1;
                this.doPrecode = @this.precodeNone;
                this.doEqualize = @this.equalizeNone;
                
            case enum.modem.MimoScheme.TRANSMIT_DIVERSITY
                this.spatialCodeRate = 1;
                this.doPrecode = @this.precodeTxDiversity;
                this.doEqualize = @this.equalizeTxDiversity;
                
            case enum.modem.MimoScheme.OPEN_LOOP
                this.spatialCodeRate = [];
                this.doPrecode = @this.precodeOpenLoop;
                this.doEqualize = @this.equalizeOpenLoop;
                
            case enum.modem.MimoScheme.GENERIC
                this.spatialCodeRate = [];
                this.doPrecode = @this.precodeGeneric;
                this.doEqualize = @this.equalizeGeneric;
                
            otherwise
                this.spatialCodeRate = [];
                error( 'Invalid MIMO scheme.');
                
        end
        
        this.numberOfTxAntennas = [];
        this.numberOfRxAntennas = [];
        
        this.userPrecodingMatrix = [];
        
    end
    
% setNumberOfAntennas
    setNumberOfAntennas( this, numberOfTxAntennas, numberOfRxAntennas );
    
% precode
    [ precodedSymbols ] = precode( this, modulationSymbols );
    
% decode
    [ equalizedSignal ] = equalize( this, mimoSignal, ...
                                          channel );
                                    
    
end

methods( Access = 'protected' )   
% dummy
    [ precodedSymbols ] = precodeNone( this, modulationSymbols );
    [ equalizedSignal ] = equalizeNone( this, mimoSignal, ...
                                              channel );   
    
% transmit diversity
    [ precodedSymbols ] = precodeTxDiversity( this, modulationSymbols );
    [ equalizedSignal ] = equalizeTxDiversity( this, mimoSignal, ...
                                                     channel );  
    
% spatial multiplexing open-loop
    [ precodedSymbols ] = precodeOpenLoop( this, modulationSymbols );
    [ equalizedSignal ] = equalizeOpenLoop( this, mimoSignal, ...
                                                  channel );
       
% generic scheme with user-defined precoding matrix
    [ precodedSymbols ] = precodeGeneric( this, modulationSymbols );
    [ equalizedSignal ] = equalizeGeneric( this, mimoSignal, ...
                                                 channel ); 

end
    
end

