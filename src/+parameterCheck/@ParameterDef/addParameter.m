function addParameter( varargin )
% PARAMETERCHECK.ADDPARAMETER adds a parameter to the parameter list 
%   Description at class header
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 27 Apr 2015 - (AB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


this = varargin{ 1 };
index = this.numberOfParameters + 1;

% first argument is the parameter name
fullName = varargin{2};

% parameter may be a field of a larger struct, find eventual fathers
fields = strsplit( strtrim( fullName ), '.' );
paramName = fields{ length( fields ) };


if length( fields ) > 1
    fatherName = strjoin( fields(1:length(fields)-1), '.' );
else
    fatherName = [];
end

%verify if parameter wasn't already defined
nameExists = find( strcmp( this.name, paramName )  );
if ~isempty( nameExists )
    fatherExists = this.fatherField{ nameExists };
    if any( strcmp( fatherExists, fatherName ) )
        error([ 'Parameter ' fullName ' cannot be redefined '])
    end
end



this.name{ index } = paramName;
this.fatherField{ index } = fatherName;


% second argument is the parameter class
this.className{ index } = varargin{3};

if ~exist( this.className{ index }, 'class')
    % verify if it's a valid class
    error(['class ' this.className{ index } ' does not exist'])
end

% initalize default properties
this.isVector( index ) = false;
this.isMandatory( index ) = false;
this.isCellArray( index ) = false;
this.default{ index } = [];
this.ignoreSubfields( index ) = false;
this.condition{ index } = [];

% optional arguments
arg = 4;
while arg <= length( varargin )
    
    switch class( varargin{ arg } )
        case ( 'enum.parameterCheck.Property' )
            % it is a boolean property
            switch varargin{ arg }
                case enum.parameterCheck.Property.IS_VECTOR
                    this.isVector( index ) = true;
                case enum.parameterCheck.Property.IS_MANDATORY
                    this.isMandatory( index ) = true;
                case enum.parameterCheck.Property.IS_CELL_ARRAY
                    this.isCellArray( index ) = true;
                case enum.parameterCheck.Property.IGNORE_SUBFIELDS
                    this.ignoreSubfields( index ) = true;                    
            end
        case ( 'char' )
            switch varargin{ arg }
                case 'default'
                    % it is a default value, read following argument
                    arg = arg + 1;
                    this.default{ index } = varargin{ arg };
                otherwise
                    % it should be a condition
                    if isempty( this.condition{ index } )
                        this.condition{ index } = ['(' varargin{ arg } ')'];
                    else
                        this.condition{ index } = [ this.condition{ index } ...
                                                '&& (' varargin{ arg } ')' ];
                    end
            end
        otherwise
            error( 'argument of invalid class')
    end
    
    arg = arg + 1;
end

this.numberOfParameters = index;
end



