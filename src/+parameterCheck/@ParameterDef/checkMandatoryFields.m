function parameters = checkMandatoryFields( this, parameters, father )
%PARAMETERCHECK.CHECKMANDATORYFIELDS verify if all mandatory fields are
%defined
%   Description at class header
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 01 Apr 2015 - (AB) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

% father should only be used by recursion, 
% e.g, for parameter FOO.BAR, 'FOO' is the father of 'BAR'
if ~exist( 'father', 'var' )
    father = [];
end

% depth is the number of father "generations"
% e.g, for parameter FOO.BAR.QYZ, depth = 2
if ~isempty( father )
    depth = length( strsplit( father, '.' ) );
else
    depth = 0;
end

currentFields = fieldnames( parameters );

% find defined parameters of same depth
for index = 1 : this.numberOfParameters
    if ~isempty( this.fatherField{ index } )
        fathers = strsplit( this.fatherField{ index }, '.' );
    else
        fathers = {};
    end
    
    if  depth == length( fathers ) && ...
        ( isempty(fathers) || strcmp( this.fatherField{index}, father ) )
        
        name = this.name{ index };
        
        if ~any( strcmp( currentFields, name ) )
            % if any mandatory parameter of same depth and the same father
            % is not defined, then an error has occurred
            if this.isMandatory( index )
                parameters = [];
                fprintf( 'mandatory parameter %s.%s not defined\n', ...
                         this.fatherField{ index }, name );
                return
            % if any optional parameter of same depth and the same father
            % is not defined, then define it as default                
            else
                parameters.(name) = this.default{ index };
            end
        end
    end
end


% verify all fields in parameter. If any of them is a struct call function
% recursively for this field
for field = 1 : length( currentFields )
    fieldName = currentFields{ field };
    
    if isstruct( parameters.(fieldName) )
        if isempty( father )
            newFather = fieldName;
        else
            newFather = [ father '.' fieldName ];
        end
        
        parameters.(fieldName) = ...
            this.checkMandatoryFields( parameters.(fieldName), newFather );
        
        if isempty( parameters.(fieldName) )
            parameters = [];
            return
        end
    end
    
    % if field is a cell array, than treat each cell element separately
    if iscell( parameters.( fieldName ) )
        for cellIndex = 1 : length( parameters.(fieldName ) )

            if isstruct( parameters.(fieldName){cellIndex} )
                if isempty( father )
                    newFather = fieldName;
                else
                    newFather = [ father '.' fieldName ];
                end
                
                parameters.(fieldName){cellIndex} = ...
                    this.checkMandatoryFields( parameters.(fieldName){cellIndex}, ...
                                               newFather );
                
                if isempty( parameters )
                    parameters = [];
                    return
                end
            end
            
        end
    end
                                            
end
        


end



