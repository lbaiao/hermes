classdef Source < handle
%SOURCE Class defines a Class for data packet generators.
%
%   Read-Only Public Properties:
%
%       numberOfPackets - < 1 x 1 int > - number of generated packets
%       packetSize_bits - < numberOfPacktes x 1 > - sizes (bits) of
%                                                     generated packets
%       targetPacketSize_bits < int > - Intended packet size for each
%           transmission. In case there are packets of different size.
%       txPackets < N x 1  cell-array > - Contains the created Tx Packets
%           after each call of generatePackets Method.
%           N: Number of packets. 
%       buffer < P x M cell-array > - Buffer where the Tx Packets Are
%           stored, in case HARQ Retx are executed. 
%           P = Number of HARQ UEs considered in Hermes Simulation. Each UE
%           has different and independent HARQ Processes.
%           M = Number of HARQ Processes. 
%       
%   Methods:
%   Constructor
%       Syntax: this = modem.Source( rndStream, packetSize_bits, harq )
%           Sets the packet size.
%       Inputs:
%           rndStream < 1 x 1 RandStream > - random number generator
%           packetSize < uint > (bits) - target packet size
%           harq < 1 x 1 modem.Harq > -  HARQ Controller  
%
%   generatePackets
%       Syntax: [ packets ] = generatePackets( numberOfSymbols, ...
%                                              modulationOrder, ...
%                                              codeRate )
%           Creates packets of random bits
%       Input:
%           numberOfSymbols < 1 x 1 int > - Number of symbols
%           modulationOrder < 1 x 1 int > - Modulation order
%           codeRate < 1 x 1 double >     - Code rate
%       Output:
%           packets < numberOfPackets x 1 cell > : Cell array of generated
%                                                  packets of binary bits
%
%   calculateErrors
%       Syntax: [ numBitErrors, 
%                 numPacketErrors,
%                 throughput ] = calculateErrors( rxPackets )
%           Calculate number of bit errors and number of packet errors
%       Input:
%           rxPackets < numberOfPackets x 1 cell > - Cell array of
%               received packets of binary bits
%       Output:
%           numBitErrors < 1 x 1 int > - number of bit errors
%           numPacketErrors < 1 x 1 int > - number of packet errors
%           throughput < int > - number of bits in error-free packets
%               to be averaged by the transmission duration.
%
%   getNumberOfBits
%       Syntax: [ numberOfBits ] = getNumberOfBits( )
%           Calculates number of bits in all packets.
%       Output:
%           numberOfBits < 1 x 1 int > - number of transmitted bits
% 
%   Author: Artur Rodrigues (AR), Rafhael Amorim (RA)
%   Work Adress: INDT Brasilia
%   E-mail: artur.rodrigues@indt.org.br, andre.noll@indt.org, Rafhael
%   Amorim
%   History:
%       v1.0 12 Mar 2015 - (AR) created
%       v2.0 21 Jul 2015 - (RA) HARQ Compatibility
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    properties ( GetAccess = 'public', SetAccess = 'protected' )
        numberOfPackets = [];
        targetPacketSize_bits = 1;
        packetSize_bits = [];
        txPackets = [];
        buffer = [];
    end

    properties ( Access = 'protected' )
        rnd;
        harq;
    end

    methods
        
        % constructor
        function this = Source( rndStream, packetSize, harq )
            if exist('packetSize', 'var' )
                this.targetPacketSize_bits = packetSize;
            end
            
            if exist('rndStream', 'var')
                this.rnd = rndStream;
            else
                this.rnd = RandStream.getGlobalStream();
            end
            
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
        
        packets = generatePackets( this, numberOfSymbols, ...
                                         modulationOrder, codeRate );
		
        [ numBitErrors, ...
          numPacketErrors, ...
          throughput] = calculateErrors( this, rxPackets );
                                                         
        numberOfBits = getNumberOfBits( this );
    end

end