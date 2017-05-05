%PARAMETERDEFTEST function tests the ParameterDef class
%   This script test the creation and methods of the ParameterDef class
%
%   Syntax: ParameterDefTest()
%
%   Author: Andre Noll Barreto (AB)
%   Work Adress: INDT Brasilia
%   E-mail: andre.noll@indt.org
%   History:
%       v1.0 28 Apr 2015 - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check Class constructor and AddParameters
% Test constructor of SourceLte Class and 

paramCheck = parameterCheck.ParameterDef();
paramCheck.addParameter( 'MANGO', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.APPLE', 'double', 'default', 1.0 );
paramCheck.addParameter( 'BANANA.LEMON', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );                     
paramCheck.addParameter( 'BANANA.ORANGE.APRICOT', 'uint32', ...
                         enum.parameterCheck.Property.IS_VECTOR, ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE.LYCHEE', 'char', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         enum.parameterCheck.Property.IS_VECTOR );   
paramCheck.addParameter( 'GRAVIOLA', 'struct', ...
                         enum.parameterCheck.Property.IS_CELL_ARRAY );
paramCheck.addParameter( 'GRAVIOLA.PEACH', 'logical', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'GRAVIOLA.PEAR', 'char', 'default', 'x' );
paramCheck.addParameter( 'GRAPE', 'struct', ...
                         enum.parameterCheck.Property.IGNORE_SUBFIELDS );


assert( paramCheck.numberOfParameters == 11);

%% Test 2: verify anyInvalidField method for correct parameters struct
clear PARAMETERS

PARAMETERS.MANGO = 2;
PARAMETERS.BANANA.APPLE = 1;
PARAMETERS.BANANA.LEMON = 3.5;
PARAMETERS.BANANA.ORANGE.APRICOT = [ 1 2 3];
PARAMETERS.BANANA.ORANGE.LYCHEE = 'foo';
PARAMETERS.GRAVIOLA{1}.PEACH = true;
PARAMETERS.GRAVIOLA{2}.PEACH = false;
PARAMETERS.GRAVIOLA{2}.PEAR = 'x';
PARAMETERS.GRAPE.ACEROLA = 1;

paramCheck = parameterCheck.ParameterDef();
paramCheck.addParameter( 'MANGO', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.APPLE', 'double', 'default', 1.0 );
paramCheck.addParameter( 'BANANA.LEMON', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );                     
paramCheck.addParameter( 'BANANA.ORANGE.APRICOT', 'uint32', ...
                         enum.parameterCheck.Property.IS_VECTOR, ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE.LYCHEE', 'char', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         enum.parameterCheck.Property.IS_VECTOR );   
paramCheck.addParameter( 'GRAVIOLA', 'struct', ...
                         enum.parameterCheck.Property.IS_CELL_ARRAY );
paramCheck.addParameter( 'GRAVIOLA.PEACH', 'logical', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'GRAVIOLA.PEAR', 'char', 'default', 'x' );
paramCheck.addParameter( 'GRAPE', 'struct', ...
                         enum.parameterCheck.Property.IGNORE_SUBFIELDS );

assert (~paramCheck.anyInvalidField( PARAMETERS ) )                     

%% Test 3: verify anyInvalidField method for correct parameters struct
% Test if invalid fields are correctly identified
clear PARAMETERS

PARAMETERS.MANGO = 2;
PARAMETERS.BANANA.APPLE = 1;
PARAMETERS.BANANA.LEMON = 3.5;
PARAMETERS.BANANA.ORANGE.APRICOT = [ 1 2 3];
PARAMETERS.BANANA.ORANGE.LYCHEE = 'foo';
PARAMETERS.GRAVIOLA{1}.PEACH = true;
PARAMETERS.GRAVIOLA{2}.PEACH = false;
PARAMETERS.GRAVIOLA{2}.PEAR = 'x';
PARAMETERS.GRAPE.ACEROLA = 1;

paramCheck = parameterCheck.ParameterDef();
paramCheck.addParameter( 'MANGO', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.APPLE', 'double', 'default', 1.0 );
paramCheck.addParameter( 'BANANA.LEMON', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );                     
paramCheck.addParameter( 'BANANA.ORANGE.APRICOT', 'uint32', ...
                         enum.parameterCheck.Property.IS_VECTOR, ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE.LYCHEE', 'char', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         enum.parameterCheck.Property.IS_VECTOR );   
paramCheck.addParameter( 'GRAVIOLA', 'struct', ...
                         enum.parameterCheck.Property.IS_CELL_ARRAY );
paramCheck.addParameter( 'GRAVIOLA.PEACH', 'logical', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'GRAVIOLA.PEAR', 'char', 'default', 'x' );
paramCheck.addParameter( 'GRAPE', 'struct', ...
                         enum.parameterCheck.Property.IGNORE_SUBFIELDS );

errorIdentified = true;

% verify invalid field name
PARAMETERS.BANANA.MONKEY = 3;
errorIdentified = errorIdentified && ...
                  paramCheck.anyInvalidField( PARAMETERS );
PARAMETERS.BANANA = rmfield( PARAMETERS.BANANA, 'MONKEY' );              

% verify invalid father field name
PARAMETERS.BANANA.PEACH = true;
errorIdentified = errorIdentified && ...
                  paramCheck.anyInvalidField( PARAMETERS );
PARAMETERS.BANANA = rmfield( PARAMETERS.BANANA, 'PEACH' );              
              
% verify wrong type
PARAMETERS.BANANA.LEMON = 'f';
errorIdentified = errorIdentified && ...
                  paramCheck.anyInvalidField( PARAMETERS );
PARAMETERS.BANANA.LEMON = 3.5;              

% verify wrong vector
PARAMETERS.BANANA.APPLE = [1 2 3];
errorIdentified = errorIdentified && ...
                  paramCheck.anyInvalidField( PARAMETERS );
PARAMETERS.BANANA.APPLE = 1;       

% verify wrong cell array
PARAMETERS.BANANA.APPLE = {};
PARAMETERS.BANANA.APPLE{1} = 1;
errorIdentified = errorIdentified && ...
                  paramCheck.anyInvalidField( PARAMETERS );
PARAMETERS.BANANA.APPLE = 1;

PARAMETERS.GRAVIOLA = 2;
errorIdentified = errorIdentified && ...
                  paramCheck.anyInvalidField( PARAMETERS );
PARAMETERS.GRAVIOLA = {};              
PARAMETERS.GRAVIOLA{1}.PEACH = true;
PARAMETERS.GRAVIOLA{2}.PEACH = false;
PARAMETERS.GRAVIOLA{2}.PEAR = 'bar';

assert ( errorIdentified )                     


%% Test 4: verify checkMandatoryFields method for correct parameters struct
% Test if a correct struct passes test
clear PARAMETERS

PARAMETERS.MANGO = 2;
PARAMETERS.BANANA.APPLE = 1;
PARAMETERS.BANANA.LEMON = 3.5;
PARAMETERS.BANANA.ORANGE.APRICOT = [ 1 2 3];
PARAMETERS.BANANA.ORANGE.LYCHEE = 'foo';
PARAMETERS.GRAVIOLA{1}.PEACH = true;
PARAMETERS.GRAVIOLA{2}.PEACH = false;
PARAMETERS.GRAVIOLA{2}.PEAR = 'x';
PARAMETERS.GRAPE.ACEROLA = 1;

paramCheck = parameterCheck.ParameterDef();
paramCheck.addParameter( 'MANGO', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.APPLE', 'double', 'default', 1.0 );
paramCheck.addParameter( 'BANANA.LEMON', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );                     
paramCheck.addParameter( 'BANANA.ORANGE.APRICOT', 'uint32', ...
                         enum.parameterCheck.Property.IS_VECTOR, ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE.LYCHEE', 'char', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         enum.parameterCheck.Property.IS_VECTOR );   
paramCheck.addParameter( 'GRAVIOLA', 'struct', ...
                         enum.parameterCheck.Property.IS_CELL_ARRAY );
paramCheck.addParameter( 'GRAVIOLA.PEACH', 'logical', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'GRAVIOLA.PEAR', 'char', 'default', 'x' );
paramCheck.addParameter( 'GRAPE', 'struct', ...
                         enum.parameterCheck.Property.IGNORE_SUBFIELDS );
                     
assert( ~isempty ( paramCheck.checkMandatoryFields( PARAMETERS ) ) )                     


%% Test 5: verify checkMandatoryFields method with incomplete parameters
% Test if default value is set
clear PARAMETERS

PARAMETERS.MANGO = 2;
PARAMETERS.BANANA.APPLE = 1;
PARAMETERS.BANANA.LEMON = 3.5;
PARAMETERS.BANANA.ORANGE.APRICOT = [ 1 2 3];
PARAMETERS.BANANA.ORANGE.LYCHEE = 'foo';
PARAMETERS.GRAVIOLA{1}.PEACH = true;
PARAMETERS.GRAVIOLA{2}.PEACH = false;
PARAMETERS.GRAVIOLA{2}.PEAR = 'x';
PARAMETERS.GRAPE.ACEROLA = 1;

paramCheck = parameterCheck.ParameterDef();
paramCheck.addParameter( 'MANGO', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.APPLE', 'double', 'default', 1.0 );
paramCheck.addParameter( 'BANANA.LEMON', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );                     
paramCheck.addParameter( 'BANANA.ORANGE.APRICOT', 'uint32', ...
                         enum.parameterCheck.Property.IS_VECTOR, ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE.LYCHEE', 'char', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         enum.parameterCheck.Property.IS_VECTOR );   
paramCheck.addParameter( 'GRAVIOLA', 'struct', ...
                         enum.parameterCheck.Property.IS_CELL_ARRAY );
paramCheck.addParameter( 'GRAVIOLA.PEACH', 'logical', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'GRAVIOLA.PEAR', 'char', 'default', 'x' );
paramCheck.addParameter( 'GRAPE', 'struct', ...
                         enum.parameterCheck.Property.IGNORE_SUBFIELDS );

PARAMETERS = paramCheck.checkMandatoryFields( PARAMETERS );                     
assert( PARAMETERS.GRAVIOLA{1}.PEAR == 'x' )                     

%% Test 5: verify checkMandatoryFields method with missing parameters
% Test if missing mandatory field is identified
clear PARAMETERS

PARAMETERS.MANGO = 2;
PARAMETERS.BANANA.APPLE = 1;
PARAMETERS.BANANA.LEMON = 3.5;
PARAMETERS.BANANA.ORANGE.APRICOT = [ 1 2 3];
PARAMETERS.BANANA.ORANGE.LYCHEE = 'foo';
PARAMETERS.GRAVIOLA{1}.PEACH = true;
PARAMETERS.GRAVIOLA{2}.PEACH = false;
PARAMETERS.GRAVIOLA{2}.PEAR = 'x';
PARAMETERS.GRAPE.ACEROLA = 1;

paramCheck = parameterCheck.ParameterDef();
paramCheck.addParameter( 'MANGO', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.APPLE', 'double', 'default', 1.0 );
paramCheck.addParameter( 'BANANA.LEMON', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );                     
paramCheck.addParameter( 'BANANA.ORANGE.APRICOT', 'uint32', ...
                         enum.parameterCheck.Property.IS_VECTOR, ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'BANANA.ORANGE.LYCHEE', 'char', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         enum.parameterCheck.Property.IS_VECTOR );   
paramCheck.addParameter( 'GRAVIOLA', 'struct', ...
                         enum.parameterCheck.Property.IS_CELL_ARRAY );
paramCheck.addParameter( 'GRAVIOLA.PEACH', 'logical', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
paramCheck.addParameter( 'GRAVIOLA.PEAR', 'char', 'default', 'x' );
paramCheck.addParameter( 'GRAPE', 'struct', ...
                         enum.parameterCheck.Property.IGNORE_SUBFIELDS );

PARAMETERS.BANANA.ORANGE = rmfield( PARAMETERS.BANANA.ORANGE, 'LYCHEE' )
PARAMETERS = paramCheck.checkMandatoryFields( PARAMETERS );                     
assert( isempty( PARAMETERS ) );
