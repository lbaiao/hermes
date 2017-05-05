function setScenarioNodes(this, nodesInfo )
% SCENARIO.SETSCENARIONODES creates nodes.
%       Further description is given in the class header.
%
%   Author: Rafhael Medeiros de Amorim (RA)
%   Work Address: INDT Brasília
%   E-mail: < rafhael.amorim@indt.org.br >
%   History:
%       v1.0 26 Mar 2015 (RA) - Created
%   Detailed explanation goes here

numOfNodes = length( nodesInfo );
% Set Node Parameters
for nodeCount = 1: numOfNodes
    %Node Position:
    position = nodesInfo{ nodeCount }.POSITION;
    %Node Velocity
    velocity = nodesInfo{ nodeCount }.VELOCITY;
    %Initialize list of Modems for this Node:
    %Construct the Node:
    this.nodes{nodeCount} = networkEntity.Node( position, velocity);
end

end

