function paramTable = loadLteParametersTable( )
%LOADLTEPARAMETERSTABLE creates the Table of LTE User Defined Parameters.
%  This function is responsible for creating the LTE Table of Parameters
%  that will be checked in the beggining of HERMES Simulations. 
%
%   Syntax: loadLteParametersTable
%
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%      v2.0 21 May 2015 - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%%
% define desired structure and whether fields are mandatory
paramTable = parameterCheck.ParameterDef();

paramTable.addParameter( 'DUPLEX_MODE', 'enum.modem.lte.DuplexMode', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'BANDWIDTH_MHz', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         'any( %this == [ 1.4 , 5, 10 , 15 , 20] )' );
                     
paramTable.addParameter( 'CYCLIC_PREFIX', ...
                         'enum.modem.lte.CyclicPrefix', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'CARRIER_SPACING_kHz', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         'any( %this == [ 7.5 , 15 ] )' );
                     
paramTable.addParameter( 'ENABLE256QAM', 'logical', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'MIMO_SCHEME', 'enum.modem.MimoScheme', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'NUMBER_PRBS_PER_TRANSPORT_BLOCK', ...
                        'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );

paramTable.addParameter( 'ENCODER', 'struct', ...
                        enum.parameterCheck.Property.IS_MANDATORY);
                    
paramTable.addParameter( 'ENCODER.TYPE', 'enum.modem.CodeType', ...
                         enum.parameterCheck.Property.IS_MANDATORY )
                     
paramTable.addParameter( 'ENCODER.TURBO', 'struct', ...
                         'default','false' );
                                          
paramTable.addParameter( 'ENCODER.TURBO.ITERATIONS', 'uint32', ...
                        'default', '5');
                      
paramTable.addParameter( 'SUBFRAMES_DIRECTION', 'enum.modem.lte.SubframesDirection', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'PDCCH_LENGTH ', 'uint32', ...
                         'default', '2' );
                     
paramTable.addParameter( 'MCS', 'uint32',  ...
                          enum.parameterCheck.Property.IS_MANDATORY, ...
                          '%this >= 0 && %this <= 27');            
                     
paramTable.addParameter( 'HARQ', 'struct',  ...
                          enum.parameterCheck.Property.IS_MANDATORY);
                      
paramTable.addParameter( 'HARQ.ENABLED', 'logical',  ...
                          'default', 'true');
                      
paramTable.addParameter( 'HARQ.MAX_RETX_TIMER', 'uint32',  ...
                          'default', '1');
                      
paramTable.addParameter( 'HARQ.MAX_NUMBER_OF_RETX', 'uint32',  ...
                          'default', '4');                         
end


