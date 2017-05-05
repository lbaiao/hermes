function updateTimers( this, frameDirection )
%HARQ.UPDATETIMERS Updates all HARQ Timers
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

% Update Timers:
this.ackTimer = this.ackTimer - 1;
this.retxTimer = this.retxTimer - 1;

% If this is a frame in reverse direction send all acks/nacks
if frameDirection ~= this.linkDirection
    feedbackSent = ( this.ackTimer <= 0 );
    this.retxTimer ( feedbackSent ) = this.maxRetxTimer;
    this.ackTimer ( feedbackSent ) = this.infinity;
    return;
end

% Check if any reTxTimer has expired:
expiredTimers = ( this.retxTimer <= 0 );
% Update the RV
this.redundancyVersions( expiredTimers ) = mod( this.redundancyVersions( expiredTimers ) + 1 , ...
                                               this.maxNumRv );
% Place this process in the queue
this.harqRetxQueue( expiredTimers ) = 1;

end



