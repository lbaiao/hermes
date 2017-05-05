function harqScheduling( this, numberOfPackets )
%HARQ.HARQSCHEDULING schedules the HARQ Process to be transmitted
%   Further Description in Class Header
%
%   Author: Rafhael Amorim
%   Work Address: INDT Brasília
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%   	v2.0 15 Jul 2015 (RA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% If HARQ is not enabled, do nothing:
if ( this.enabled == false )
    return
end

% Start the Allocation Count
allocatedPackets = 0;

% Reset the schedule
this.harqScheduler.ue = zeros( 1, numberOfPackets );
this.harqScheduler.process = zeros( 1, numberOfPackets );

% Find the HARQ Processes in the Queue:
[ user , harqProcess ] = find( this.harqRetxQueue == 1 );

queueSize = length(  user );
if queueSize <=  numberOfPackets
    % All Processes in the Queue are transmitted:
    this.harqScheduler.ue( 1 : queueSize ) = user;
    this.harqScheduler.process( 1 : queueSize ) = harqProcess;
    
    if queueSize < numberOfPackets 
        this.harqScheduler.ue( queueSize + 1 : end ) = [];
        this.harqScheduler.process( queueSize + 1 : end ) = [];
        warning('Inefficient Allocation. The number of HARQ Processes available was not enough to fill the buffer' );
    end
    % Start ACK Timer:
    this.ackTimer ( this.harqScheduler.ue , this.harqScheduler.process ) = ...
                                    this.maxAckTimer;
    this.retxTimer ( this.harqScheduler.ue , this.harqScheduler.process ) = ...
                                    this.infinity;
    % Remove Processes from the Queue:
    this.harqRetxQueue( user, harqProcess ) = 0;
    return;
end

% If there are more packets in the queue than space in the frame: 

remainderSpots = numberOfPackets; % Count the spots available for allocation
currentSpot = 1;
searchIndexes = user + (harqProcess - 1) * size( this.retxTimer, 1 );
timersVector = sort( this.retxTimer( searchIndexes ), 'ascend' ); % Prioritize first timers to expire
priorityLevel = 0;
while ( allocatedPackets < numberOfPackets )
    % Find process with this level of Priority
    priorityLevel =  priorityLevel + 1;
    timerPriority = timersVector ( priorityLevel );
    posInQueue = find( this.retxTimer( searchIndexes ) == timerPriority, ...
                                   remainderSpots, 'first' );
    % Check how many packets with this priority are allocated:                           
    packetsAllocated = length( posInQueue );
    % Allocate the Packets
    this.harqScheduler.ue( currentSpot : packetsAllocated + currentSpot - 1 ) = ... 
                                                       user( posInQueue );
    this.harqScheduler.process( currentSpot : packetsAllocated + currentSpot - 1 ) = ... 
                                                       harqProcess( posInQueue ); 
    % Eliminate the spots available for allocation:                                               
    remainderSpots = remainderSpots - length( posInQueue );
    % Update auxiliary variables:
    allocatedPackets = allocatedPackets + length( posInQueue );
    currentSpot = currentSpot + packetsAllocated;
    % Start Timers:
    this.ackTimer( searchIndexes( posInQueue ) ) = this.maxAckTimer;
    this.retxTimer( searchIndexes( posInQueue ) ) = this.infinity;
    % Remove Processes from the Queue:
    this.harqRetxQueue( searchIndexes( posInQueue ) ) = 0;
end

end



