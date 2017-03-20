classdef Node < handle
%NODE class represents any node in simulation (network node or user node).
%   This class defines objects that will serve as data
%   containers for node properties during simulation.
%
%   Properties:
%       positionInXYZ - < 1 x 3 double> node position [X Y Z].
%       velocity - < 1 x 2 double > (m/s) defines node velocity in X and
%           Y axes.
%
%   Methods:
%   Constructor
%       Syntax 1: this = networkEntity.Node( positionInXYZ, ...
%                                            velocity, ...
%                                            sources, ...
%                                            modems )
%       Syntax 2: this = networkEntity.Node( positionInXYZ, velocity )
%       Input:
%           positionInXYZ - < 1 x 3 double> node position [X Y Z]
%           velocity - < 1 x 2 double > (m/s) defines node velocity in X 
%               and Y axes.
%
%
%   Author: Lilian Freitas (LCF), Erika Almeida (EA), Rafhael Amorim
%   Work Address: INDT
%   E-mail: <lilian.freitas, erika.almeida, rafhael.amorim>@indt.org.br
%
%   History:
%       v1.0 0 12 Jan 2015 (LCF) - created
%       v2.0   24 Apr 2015 (RA) - Modem Attribute and 'associateModems'
%       method deleted.
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

    properties ( GetAccess = 'public', SetAccess = 'protected' )

        positionInXYZ;

        velocity;

    end

    methods

        % Class constructor
        function this = Node( positionInXYZ, ...
                              velocity )

            this.positionInXYZ = positionInXYZ;

            this.velocity = velocity;

        end

    end

end
