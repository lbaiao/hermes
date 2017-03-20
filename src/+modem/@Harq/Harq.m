classdef Harq < handle
% HARQ class implements objects responsible to implement HARQ Functionality
%
%   Harq methods try to simulate an abstraction to a higher layer ( MAC ),
%   organizing the scheduling and the processes of the HARQ mechanism.
%
%   Read-Only Public Properties:
%       numberOfHarqProcesses < int > Number of HARQ Processes defined per
%           UE.
%       numberOfUes < int > Number of UEs defined in simulation. Each UE
%       may have H different Harq Processes, where H = numberOfHarqProcesses.
%       maxNumberOfRetx < int > Number of times a packet may be
%           retransmitted before the HARQ Process is re-started and receiver
%           buffer is emptied.
%       ackTimer < MxL int > Contains the minimum time the receiver takes to
%           process the information and send the ACK/NACK back. Measured in
%           allocation units ( frame, subframe, symbol, etc. ). It is
%           decremented in 1 unit for every time transmitFrame method is
%           called.
%           M: numberOfUes
%           L: numberOfHarqProcess
%       retxTimer < MxL int > Contains the retransmission timer, which
%           measures the minimum period between the received ACK/NACK and
%           the allocation of the resources for retransmission.
%       harqScheduler < struct > Contains the pairs < UE, HARQ Process >
%           for the next scheduling period. It abstracts the MAC Layer in
%           Hermes.
%       ackNackFlag < MxL boolean > contains the context of the last
%           ack/nack message for each HARQ Process.
%           True: ACK
%           False: NACK
%       redundancyVersions < MxL int > Contain the current RV for each HARQ
%           process.
%       harqRetxQueue < MxL boolean > Contains the HARQ Processes in the
%           queue for being retransmitted.
%           True: Waiting for Retransmission.
%           False: Not Ready for Retransmission.
%       enabled < logical >  True for Enabled HARQ, False otherwise.
%       linkDirection < enum.FrameDirection > Contain the frame Direction
%   Methods
%   constructor:
%       Syntax: this = Harq( HARQ , numberOfUes )
%       Inputs:
%               Harq < struct > Containing the Harq Parameters needed for
%           HARQ creation such as:
%                   .NUMBER_OF_HARQ_PROCESSES < int > Max. Nuber of Processes
%                   .MAX_NUMBER_OF_RETX < int > Max. Number of
%                       Retransmissions allowed per Harq Process
%                   .MAX_ACK_TIMER < int > Maximum Ack Timer.
%                   .MAX_RETX_TIMER < int > Maximum Retransmission Timer.
%                   .ENABLED < logical > Enable/Disable HARQ.
%                   .MAX_NUM_OF_RV < int > Number of RVs available.
%               numberOfUes < int >  Number of UEs defined in simulation. 
%                   Actually it contains the number of packets the allocation 
%                   unit ( frame, subframe, symbol ) is divided in a 
%                   simulation loop.
%
%   updateTimers  
%       It updates HARQ Timers. If the frame is in the 'reverse' direction, 
%           all expired Nacks are considered to be sent.
%       Syntax: updateTimers( frameDirection )
%       Input: frameDirection < enum.FrameDirection > - DOWNLINK or UPLINK.
%   
%   harqScheduling
%       It performs the HARQ Scheduling. The next packets in the HARQ Queue
%           are transmitted, and RVs updated. The number of HARQ Processes
%           scheduled is defined by the input parameter numberOfPackets
%       Syntax: updateTimers( numberOfPackets )
%       Input: numberOfPackets < int > - Number of Packets to be allocated
%           in the next transmission period.
%
%   resetHarq
%       It is used to reset the HARQ timers and transmission queue after 
%       the end of every Drop Loop in Hermes.
%       Syntax: resetHarq( )
%
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasília
%   E-mail: <rafhael.amorim>@indt.org.br
%   History:
%       v2.0 6 May 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

properties ( GetAccess = 'public', SetAccess = 'protected')
    numberOfHarqProcess
    numberOfUes
    maxNumberOfRetx
    ackTimer
    retxTimer
    harqScheduler
    ackNackFlag
    redundancyVersions
    harqRetxQueue
    enabled
    linkDirection
end

properties ( GetAccess = 'protected', SetAccess = 'protected')
    maxAckTimer     % Store the starting value for the ackTimer

    maxRetxTimer    % Store the starting value for the retxTimer

    maxNumRv       % Store the max. number of RVs available.   
    
end

properties ( Constant = true,  GetAccess = 'protected', SetAccess = 'protected')
    infinity = 50000; % A very big number to "switch off" timers.  
end
%%
methods ( Access = public )

    %% constructor
    function this = Harq( HARQ , numberOfUes, linkDirection )
        % Maximum Number of HARQ Process and UEs
        this.numberOfHarqProcess = HARQ.NUMBER_OF_HARQ_PROCESS;
        this.numberOfUes = numberOfUes;
        % Max Number of Retransmissions
        this.maxNumberOfRetx = HARQ.MAX_NUMBER_OF_RETX;
        % Ack Timer:
        this.maxAckTimer = HARQ.MAX_ACK_TIMER;
        this.ackTimer = ones( this.numberOfUes, this.numberOfHarqProcess ) * ...
                                            this.infinity; % Switched Off
        % Retx Timer:
        this.maxRetxTimer = HARQ.MAX_RETX_TIMER;
        this.retxTimer = ones( this.numberOfUes, this.numberOfHarqProcess ) * ...
                                            this.infinity; % Switched Off
        % HARQ Scheduler
        this.harqScheduler.ue = zeros( 1 , this.numberOfUes );
        this.harqScheduler.process = zeros( 1 , this.numberOfUes );
        % ACK/NACK Flag
        this.ackNackFlag = zeros( this.numberOfUes, this.numberOfHarqProcess );
        % Redundancy Versions:
        this.redundancyVersions = zeros( this.numberOfUes, this.numberOfHarqProcess );
        this.maxNumRv = HARQ.MAX_NUM_OF_RV;
        % HARQ Retx Queue
        this.harqRetxQueue = ones( this.numberOfUes, this.numberOfHarqProcess );
        % Enable/Disable
        this.enabled = HARQ.ENABLED;
        %Link Direction:
        this.linkDirection = linkDirection;
    end
    
    updateTimers( this, frameDirection )
    harqScheduling( this, numberOfPackets )
    resetHarq( this )
end
end