classdef InterFrameInterference
%INTERFRAMEINTERFERENCE defines interference model between adjacent frames
%
%   Read-Only Public Properties:
%     NONE - no interference between adjacent blocks considered
%     TAIL_BITING - interference at beginning of a frame is due to the last
%                   samples of the same frame
%     ACTUAL - last samples of each frame are stored and added to
%              beginning of following frame
%
%   Author: Andre Noll Barreto (ANB)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org.br
%   History:
%       v2.0 25 Jun 2015 (EA) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    enumeration

       NONE, ...
       TAIL_BITING, ...
       ACTUAL

    end
end
