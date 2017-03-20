classdef Modem < handle
%MODEM class implements a modem to be used for Node class
%   This class contains objects from Encoder, Mapper, Frame Assembler,
%   Modulator, Radio Frequency (rf) and Inner Receiver in order to
%   transmit and receive signals.
%
%   Properties:
%       source - < 1 x 1 Source > it is an object from Source class.
%       antenna - < 1 x 1 networkEntity.Antenna > it is an object of Antenna 
%             class.
%       modemStatus - < 1 x 1 ModemStatus > defines whether the modem is
%            transmitting or receiving. Values are defined by enum
%            class called ModemStatus.
%       scrambler - < 1 x 1 modem.Scrambler > it is an object of Scrambler
%       class
%       encoder - < 1 x 1 modem.Encoder > it is an object of Encoder class.
%       mapper - < 1 x 1 modem.Mapper > it is an object of Mapper class.
%       spatialCoder - < 1 x 1 modem.SpatialCoder > it is an object of
%           SpatialCoder class.
%       innerTransceiver - < 1 x 1 modem.Modulator/modem.InnerReceiver > 
%           represents the part of the modem closest to the RF conversion.
%           In the transmitter it consists of a Modulator object, in the
%           receiver it consists of an InnerReceiver object, which,
%           besides modulating, also performs channel estimation and
%           synchronization.
%       frameAssembler - < 1 x 1 modem.FrameAssembler> it is an object of
%           FrameAssembler class.
%       rf - < 1 x 1 Rf > it is an object of Rf class, modelling the RF
%           imperfections.
%       rxSampler - < 1 x 1 modem.RxSampler > Object from RxSampler Class. 
%           It is responsible to perform sampling rate matching and Center
%           Frequency Matching for rx Modems. For Tx Modems this attribute
%           is empty.
%       thermalNoise < 1 x 1 channel.Noise > Object from Noise Class set 
%       for Rx Modems. For tx Modems this attribute is empty.
%       link < struct > empty if modem is not connected to other modem, 
%           otherwise modem is connected to 'link.modem' in node
%           'link.node'. Contains:
%               link.modem < 1 x 1 Modem > Modem class object.
%               link.node < 1 x 1 networkEntity.Node > Node class object.
%       node < 1 x 1 Node> Object from Node Class. Assigns the node this
%       modem belongs to.
%       harq <1 x 1 modem.Harq > Object from Harq Class. Responsible to
%           control HARQ Processes.
%   Methods:
%   Constructor
%   	Syntax 1: this = modem.Modem ( )
%       Syntax 2: this = modem.Modem( modemParameters, technologyPar, ...
%                                     rnd, rxFlag )
%       Input:
%       	modemParameters < struct >: 
%               TECHNOLOGY < 1x1 enum.Technology >
%           	ANTENNA_TYPE < 1x1 enum.antenna.AntennaType >
%           	NUMBER_OF_ANTENNAS < 1 x 1 int >
%           	ANTENNA_POSITION < NUMBER_OF_ANTENNAS x 3 double >
%               	Antennas Position in XYZ
%           	CARRIER_FREQUENCY < 1 x 1 double > (Hz)
%           technologyPar < struct >: Exclusive Technology Parameters     
%                   according to the selected technology type.
%       	rnd: < 1 x 2 randomStreams objects > Different objects used for
%               *Source Attribute
%               *Frame Assembler Attribute
%       	rxFlag < 1x1 logical >: TRUE for RxModem,
%                                   FALSE for TxModem.
% 
%	createModem
%       Syntax1: createModem( modemParameters, technologyPar, ... 
%                             randomStreams , rxFlag  )
%       	Create modem object with attributes filled.
%       Input:
%       	modemParameters < struct >: 
%               TECHNOLOGY < 1 x 1 enum.Technology >
%           	ANTENNA_TYPE < 1 x 1 enum.antenna.AntennaType >
%           	NUMBER_OF_ANTENNAS < 1 x 1 int >
%           	ANTENNA_POSITION < NUMBER_OF_ANTENNAS x 3 double >
%               	Antennas Position in XYZ
%           	CARRIER_FREQUENCY < 1 x 1 double > (Hz)
%           technologyPar < struct >: Exclusive Technology Parameters     
%                   according to the selected technology type.
%       	randomStreams: < 1 x 2 randomStreams objects > Different objects used for
%               *Source Attribute
%               *Frame Assembler Attribute
%       	rxFlag < 1x1 logical >: TRUE for RxModem,
%                                   FALSE for TxModem.
%
%       Syntax2: createModem( modemParameters, otherModem, 
%                             randomStreams, rxFlag  )
%       	Create modem using same components are another modem
%       Input:
%       	modemParameters: as above
%           otherModem < Modem >: another Modem object, this modem will use
%               the same instances of the modem components.
%           randomStreams: as above
%       	rxFlag: as above
%       
%   setLink
%       Syntax: setLink( otherModem )
%           Create a logical link between this modem and the modem
%           'otherModem'. Currently only one link is possible.
%       Input:
%           otherModem < 1 x 1 Int > Modem Index.
%
%   transmitFrame
%       Syntax: [ frame ] = transmitFrame( )
%           Creates a transmission frame for this particular modem,
%           according to the parameters of its components.
%       Output:
%           frame < NTx x NSamp > - is the generated signal, NTx the
%           number of antennas and NSamp the number of time samples in
%           a frame.
%
%   receiveFrame
%       Syntax: [ bits ] = receiveFrame( rxSignal, channel )
%           Detects the bits from the input signal rxSignal, according
%           to the modem parameters set at the constructor.
%       Input:
%           rxSignal < NRx x Nsamp complex > - is the baseband received
%               signal, with NRx the number of receive antennas and Nsamp
%               the number of time samples.
%           channel < struct > the known impulse response.
%               channel.impulseResponse < Ncs x NRx x NTx x L+1 complex > 
%                   is the known channel impulse response, to be used in
%                   case ideal channel estimation is considered. Ncs is the
%                   number of channel NRx the number of receive antennas,
%                   NTx the number of transmit antennas and L thechannel
%                   delay in time samples.
%               channel.samplingInstants < 1 x Ncs double > (s) is a vector
%                   containing the instants at which the channel impulse
%                   responses where obtained.
%       Output:
%           bits < 1 x N binary > bits detected.
%   setNode
%       Syntax: setNode( this, node  )
%           Assign the Node this modem belongs to.
%       Input: node < 1x1 networkEntity.node >
%
%  setPair
%       Syntax: setPair( this, source, scrambler, channelCode, mapper, 
%               frameAssembler )
%           Assign the Modem Attributes consistent with link pair.
%       Input: source < 1x1 networkEntity.node >
%              scrambler < 1x1 modem.Scrambler >
%              channelCode < 1x1 modem.channelCode >
%              mapper < 1x1 modem.Mapper >
%              frameAssembler< 1x1 modem.frameAssembler >
%
%   Author: Lilian Freitas (LCF),
%           Andre Noll Barreto (AB),
%           Rafhael Medeiros de Amorim (RMA)
%   Work Address: INDT Manaus/Brasília
%   E-mail: lilian.freitas@indt.org.br, andre.noll@indt.org,
%   rafhael.amorim@indt.org.br
%   History:
%       v1.0 03 Mar 2015 (LCF,AB,RMA) - created
%   
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
    properties ( GetAccess = 'public', SetAccess = 'protected' )
        
        source; 
        
        antenna;
        
        scrambler;
        
        channelCode;
        
        mapper;
        
        spatialCoder;
        
        innerTransceiver;
        
        frameAssembler;
        
        rf;
        
        rxSampler;
        
        thermalNoise;
        
        link;
        
        node;
        
        harq;
    end
    
    methods
        
        % Class constructor
        function this = Modem( varargin )
            
            if nargin == 0 % Construct modem with 'empty' values, if called with no arguments
                this.source = [];
                
                this.antenna = [];
                
                this.scrambler = [];
                
                this.channelCode = [];
                
                this.mapper = [];
                
                this.spatialCoder = [];
                
                this.innerTransceiver = [];
                
                this.frameAssembler = [];
                
                this.rf = [];
                
                this.rxSampler = [];
                
                this.thermalNoise = [];
                
                this.harq = [];
            else
                % Otherwise construct modem with arguments provided
                this.createModem( varargin  )

            end

            this.link.modem = [];
        end
        
        createModem( varargin )

        setLink( this, modem )
        
        setNode( this, node )
              
        frame = transmitFrame( this )
        
        
    end
    
    
end
