function statistics = hermesMain( SETTINGS, rnd )
%HERMESMAIN function implements the main simulator drops loop
%   syntax 1: statistics = hermesMain( SETTINGS, rnd )
%
%   Inputs:
%       SETTINGS: struct that contains all simulation parameters
%       rnd: cell of randomStreams objects
%
%   Outputs:
%       statistics: object that contains all simulation statistics
%
%   Author: Erika Portela Lopes de Almeida (EA), Fadhil Firyaguna (FF), 
%           Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: <erika.almeida>@indt.org.br, 
%           <fadhil.firyaguna, andre.noll>@indt.org
%   History:
%       v1.0 11 Feb 2015 - created (EA/FF)
%		v2.0 28 Apr 2015 - added parameter check (AB)
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


% verify if parameters are valid
parameterCheck.generalCheckParameters( SETTINGS );

% creates scenario object
scenario = scenario.Scenario( SETTINGS, rnd );

% creates the statistic object
statistics = simulatorCore.Statistics( SETTINGS );

% initializes the DropLoop object
simulationLoop = simulatorCore.DropLoop( SETTINGS );

% runs simulation loop
simulationLoop.runLoop( statistics, scenario );

end

