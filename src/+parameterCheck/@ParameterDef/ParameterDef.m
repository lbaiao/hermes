classdef ParameterDef < handle
% PARAMETERDEF class defines the parameter syntax
%   This class specifies the desired parameter syntax in Hermes. 
%   Firstly, one should create an instance of ParameterDef class, and then
%   parameters can be added to this instance with the desired properties by
%   calling method addParameter.
%
%   Read-Only Public Properties:
%       numberOfParameters < int > - number of currently defined parameters
%
%   Methods
%
%   constructor
%       Syntax: this = parameterCheck.ParameterDef ( )
%
%   addParameter
%       adds a given parameter to the list of allowed parameter.
%       Syntax: this.addParameter( name, className, properties )
%       Inputs:
%           name < string > - parameter name, including whole path, e.g.,
%               GRANDFATHER.FATHER.SON defines parameter 'SON', which must
%               be a field of 'GRANDFATHER.FATHER', which must also be
%               defined
%           className< string > - type of parameter, e.g., 'double', 
%               'uint32', 'struct', etc. It must be a valid Matlab class.
%           properties - it can consist of a variable number of values, of
%               class enum.parameterCheck.Property.
%               Allowed values are:
%                   IS_VECTOR - parameter can be a 1D vector. By default
%                       parameters must consist of a single element.
%                   IS_CELL_ARRAY - paremeter may be a cell array
%                   IS_MANDATORY - parameter is mandatory
%                   IGNORE_SUBFIELDS - any subfields are ignored in the
%                       parameter analysis
%              We can also define default values for the parameter (only if
%              not mandatory). In this case, property is 'default', and the
%              following property is the default value.
%              For example,
%                   this.addParameter( foo.bar, 'double',
%                                      enum.parameterCheck.IS_MANDATORY )
%                       defines a mandatory parameter 'bar' of type double,
%                       which as subfield of 'foo'.
%                   this.addParameter( foo.cux, 'int32', 
%                                      enum.parameterCheck.IS_VECTOR,
%                                      'default', [ 1 2 3 ] )
%                       defines an optional integer parameter, which, if
%                       not defined, will be initialized as [1 2 3]
%               We can also define restrictions for the parameter values,
%               using the identifier %this for the current parameter. The
%               restriction can be any valid matlab logical expression.
%               For example
%                   this.addParameter( foo.bar, 'double', '%this > 0',  
%                                      '%this < 1' )
%                       defines a parameter that must be >0 and <1.
%               The parameter can be compared with other parameters, which 
%               are identified by a %. For example
%                   this.addParameter( foo.bar, 'double',
%                                      '%this >= %foo.quz' )
%                       defines a parameter foo.bar that must be larger
%                       than foo.quz
%                   
%                   
%   anyInvalidField
%       verifies if a parameter struct contain any invalid field. An
%       invalid field is one not previously defined, one of a different
%       class from the one specified or one that does not satisfies the
%       restrictions.
%   Syntax: invalid = this.anyInvalidField( parameters ) 
%   Inputs:
%       parameters< struct > - struct containing the simulator parameters
%   Outputs:
%       invalid< boolean > - true if any field is invalid. A message error
%           is given at the standard output.
%
%   checkMandatoryFields
%       verifies if any mandatory parameter was not defined, and
%       initializes undetermined parameters with the default values.
%   Syntax:  parameters = this.checkMandatoryFields( parameters )
%   Inputs:
%       parameters< struct > - struct containing the simulator parameters
%   Outputs:
%       parameters< struct > - struct containing the simulator parameters.
%           It should be equal to the input 'parameters' plus the default
%           parameters. If a mandatory parameter is not defined, an error
%           message is given in the standard output and an empty value is
%           returned.
%
%   Author: Andre Noll Barreto (AB)
%   Work Address: INDT Brasília
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 27 Apr 2015 (AB) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.
    
properties ( GetAccess = 'public', SetAccess = 'protected')
    numberOfParameters = 0;
end

properties ( Access = 'protected')
    name = {}; % < string > parameter name
    className = {}; % < string > type ( must be a valid matlab class )
    fatherField = {}; % <string> father parameter
    default = {}; % defaul value
    isMandatory = false; % <logical> whether parameter is mandatory
    isVector = false; % <logical> whether parameter can be a vector
    isCellArray = false; % <logical> whether parameters is a cell array
    ignoreSubfields = false; % <logical> if true, then subfields are not checked
    condition = {}; % <string> other conditions
end


methods (Access = public)

    %% constructor
    function this = ParameterDef( )
    end

    addParameter( varargin )
    
    invalid = anyInvalidField( this, parameters, father, head )
    % 'father' and 'head' should only be employed for internal recursion
    % call, not needed for class interface
    
    parameters = checkMandatoryFields( this, parameters, father )
    % 'father' should only be employed for internal recursion call, not
    % needed for class interface
   
end

end

