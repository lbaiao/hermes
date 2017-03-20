function addHermesPaths( parameterPath )
%ADDHERMESPATHS adds the simulation folders to Matlab path.
%   addHermesPaths( parameterPath )
%       adds all the paths containing source files and the parameter files,
%       which is defined in 'parameterPath'  
%
%   Author: Erika Portela Lopes de Almeida, André Noll Barreto
%   Work Address: INDT Brasília
%   E-mail: erika.almeida@indt.org.br, andre.noll@indt.org
%   History:
%       5 Feb 2015 - created
%       27 Mar 2015 - parameter path added
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% add simulator main path
hermesPath = pwd;
addpath( genpath( hermesPath ) );
addpath( parameterPath );