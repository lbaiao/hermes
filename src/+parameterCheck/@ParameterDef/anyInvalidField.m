function invalid = anyInvalidField( this, parameters, father, head )
%PARAMETERCHECK.ANYINVALIDFIELD verifies validity of all parameter fields
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

% father and head should only be used by recursion, 
% e.g, for parameter FOO.BAR, 'FOO' is the father of 'BAR'
if ~exist( 'father', 'var')
    father = [];
    head = parameters;
end
invalid = false;



% verify each field in this struct
fields = fieldnames( parameters );
for index = 1:length( fields )
    
    % find out if parameter was previously defined
    paramIndex = find( strcmp( this.name, fields{ index } ) );
    
    % if param was defined more than once
    if ( length( paramIndex ) > 1 )
        % find out which parameter has the same father
        fathers = this.fatherField( paramIndex );
        sameFather = find( strcmp( fathers, father ), 1 ) ;
        if ~isempty( sameFather )
            paramIndex = paramIndex( sameFather );
        else
            paramIndex = [];
        end
        
    end

    % if parameter name was not defined, then field is invalid
    if isempty( paramIndex )
        invalid = true;
        fprintf('invalid field %s.%s\n', father, fields{ index } );
        return
    % if father is not the same as specified, then field is invalid
    elseif ~isempty( father )
        invalid = ~strcmp( this.fatherField{ paramIndex }, father );
    end
    
    if invalid
        fprintf('invalid field %s.%s\n', father, fields{ index } );
        return
    end
     
    % determine full field name
    if isempty( father )
        fullName = fields{ index };
    else
        fullName = [ father '.' fields{ index } ];
    end
    
    % get field value
    param = parameters.( fields{ index } );
    
    % as some parameters may be cell arrays, deal always with cell arrays
    cellParam = {};   
    if iscell( param )
        % if cell arrays wasn't previously declared, then field is invalid
        if ~this.isCellArray( paramIndex )
            fprintf( 'parameter %s cannot be a cell array\n', fullName );
            invalid = 1;
            return
        end
        cellParam = param;
    else
        % if parameter is not a cell array as declared, then field is
        % invalid
        if this.isCellArray( paramIndex )
            fprintf( 'parameter %s must be a cell array\n', fullName );
            invalid = 1;
            return
        end        
        cellParam{1} = param;
    end
    
    % verify if all itens in the cell array are valid
    for cellIndex = 1 : length( cellParam )
        
        if isstruct( cellParam{ cellIndex } )
            % if field wasn't declared as a struct, then it's invalid
            if ~strcmp( this.className{ paramIndex }, 'struct' )
                invalid = 1;
                fprintf( 'parameter %s must be a struct\n', fullName );
                return;
            end
            
            if ~this.ignoreSubfields ( paramIndex )
                % if subfields shouldn't be ignored, then call function
                % recursively to verify all its subfields
                if isempty( father )
                    newFather = fields{ index };
                else
                    newFather = [ father '.' fields{ index } ];
                end

                invalid = this.anyInvalidField( cellParam{ cellIndex }, ...
                                                newFather, head );
            end
        else
            % verify if it's an invalid vector
            if length(  cellParam{ cellIndex } ) > 1 && ...
               ~this.isVector( paramIndex )
                invalid = 1;
                fprintf( 'parameter %s cannot be a vector\n', fullName );
                return                
            end                        
            
            % verify if it is the correct type
            if ~isa( cellParam{ cellIndex }, this.className{ paramIndex } )
                % attempt conversion
                try
                    eval( [ 'converted = ' this.className{ paramIndex } ...
                          '([' num2str( cellParam{ cellIndex } ) ']);'] )
                    if ~isequal( cellParam{ cellIndex }, converted )
                       
                        invalid = 1;
                    end
                catch
                    invalid = 1;
 
                end
                
                if invalid
                    fprintf( 'parameter %s must be of class %s\n', ...
                             fullName, this.className{ paramIndex } );
                    return
                end
            end
            
            % verify if satisfies other conditions
            condition = this.condition{ paramIndex };
            if ~isempty( condition )
                condition = strrep( condition, '%this', ...
                                                 'cellParam{cellIndex}' );
                condition = strrep( condition, '%', 'head.' );
                
                invalid = ~eval( condition );
                
                if invalid
                    fprintf( 'parameter %s does not satisfy restrictions \n', ...
                             fullName );
                    return
                end
            end
            
        end
        
        
        
        if invalid
            return
        end
    end
        
    
end






