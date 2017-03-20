classdef LteSource < source.Source
%LTESOURCE Class implements a data packet generator for LTE Parameters.
%   This class implements a random bit generator source for defined size
%   data packets. It is a subclass from Source.
%   This version does not support HARQ or any kind of error-control
%   parameters.
%
%   Methods:
%   Constructor
%       Syntax: this = modem.LteSource( rndStream, LTE, harq )
%           Sets the maximal possible number of packets for determinate LTE
%           Parameters.
%       Inputs:
%           rndStream < 1 x 1 RandStream > :        RandStream object
%           LTE < 1 x 1 struct > :                  Struct with LTE
%                                                   Parameters
%           harq < 1 x 1 modem.Harq > :             HARQ Controller   
%   generatePackets
%       Syntax: [ packets ] = generatePackets( numberOfSymbols, ...
%                                              modulationOrder, ...
%                                              codeRate )
%           Creates packets of random bits
%       Input:
%           numberOfSymbols < 1 x 1 int > : Number of symbols
%           modulationOrder < 1 x 1 int > : Modulation order
%           codeRate < 1 x 1 double >     : Code rate
%       Output:
%           packets < numberOfPackets x 1 cell > : Cell array of generated
%                                                  packets of binary bits
%
%   Author: Artur Rodrigues (AR), Rafhael Medeiros de Amorim (RA),
%           Fadhil Firyaguna (FF)
%   Work Address: INDT Brasilia
%   E-mail: < artur.rodrigues, rafhael.amorim >@indt.org.br,
%           fadhil.firyaguna@indt.org
%   History:
%       v1.0 23 Mar 2015 - created
%       v2.0 21 Jul 2015 - HARQ Compatibility (RA)
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    properties ( GetAccess = 'public', SetAccess = 'protected' )
        transportBlockSize
        maxNumberOfPackets
    end
    
    
    methods ( Access = 'public' )
        
        % constructor
        function this = LteSource( rndStream, LTE, harq )
            % Get Transport Block Size Index:
            mcs = LTE.MCS;
            enable256qam = LTE.ENABLE256QAM;
            transportBlockSizeIndex = ...
                    lookupTables.modem.lte.getTbsIndex( mcs, enable256qam);
            % Get Number of PRBs
            numOfPrbsPerPacket = LTE.NUMBER_PRBS_PER_TRANSPORT_BLOCK ;
            % Get Transport Block Size:
            this.transportBlockSize = ...
                lookupTables.modem.lte.getTransportBlockSize( ...
                                    transportBlockSizeIndex , numOfPrbsPerPacket );
            this.rnd = rndStream;
            
            this.targetPacketSize_bits = this.transportBlockSize;
            
            % Calculate the Max. Number of Packets to be generated:
            this.maxNumberOfPackets = floor( LTE.N_PRB / numOfPrbsPerPacket );
            % Set HARQ Controller:
            if ~exist('harq','var' )
                this.harq = [];
                this.buffer = [];
            else
                this.harq = harq;
                this.buffer = ...
                    cell( this.harq.numberOfUes , this.harq.numberOfHarqProcess );
            end
        end % end constructor
        

    end
    
end