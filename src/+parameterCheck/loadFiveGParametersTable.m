function paramTable = loadFiveGParametersTable( )
%LOADFIVEGPARAMETERSTABLE creates the Table of 5G User Defined Parameters.
%  This function is responsible for creating the 5G Table of Parameters
%  that will be checked in the beggining of HERMES Simulations. 
%
%   Syntax: loadFiveGParametersTable
%
%   Author: Rafhael Medeiros de Amorim
%   Work Address: INDT Brasilia
%   E-mail: andre.noll@indt.org
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

paramTable.addParameter( 'SUBCARRIER_SPACING', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'FFT_SIZE', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'USEFUL_SUBCARRIERS', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                        '%this <= %FFT_SIZE');
                    
paramTable.addParameter( 'WAVEFORM', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                    
paramTable.addParameter( 'WAVEFORM.TYPE', 'enum.modem.fiveG.Waveform', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
 
paramTable.addParameter( 'WAVEFORM.OFDM', 'struct' );

paramTable.addParameter( 'WAVEFORM.OFDM.CYCLIC_PREFIX', 'uint32', ...
                          enum.parameterCheck.Property.IS_MANDATORY );

paramTable.addParameter( 'WAVEFORM.ZT_DS_OFDM', 'struct' );    
                      
paramTable.addParameter( 'WAVEFORM.ZT_DS_OFDM.TAIL', 'uint32', ...
                          enum.parameterCheck.Property.IS_MANDATORY );                      

paramTable.addParameter( 'WAVEFORM.ZT_DS_OFDM.HEAD', 'uint32', ...
                          enum.parameterCheck.Property.IS_MANDATORY );
                      
paramTable.addParameter( 'WAVEFORM.FBMC', 'struct' );

paramTable.addParameter( 'WAVEFORM.FBMC.OVERLAPPING_FACTOR', 'uint32', ...
                          enum.parameterCheck.Property.IS_MANDATORY );
                                           
paramTable.addParameter( 'WAVEFORM.FBMC.FILTER_TAIL', 'uint32', ...
                          enum.parameterCheck.Property.IS_MANDATORY );
                      
paramTable.addParameter( 'WAVEFORM.FOFDM', 'struct' );
                      
paramTable.addParameter( 'MIMO_SCHEME', 'enum.modem.MimoScheme', ...
                         'default', 'enum.modem.MimoScheme.NONE' );  
                     
paramTable.addParameter( 'RFIMPAIRMENTS', 'struct' );

paramTable.addParameter( 'RFIMPAIRMENTS.HPA', 'struct');

paramTable.addParameter( 'RFIMPAIRMENTS.HPA.ENABLE', 'uint32', ...
                          enum.parameterCheck.Property.IS_MANDATORY );

paramTable.addParameter( 'RFIMPAIRMENTS.HPA.P', 'uint32');

paramTable.addParameter( 'RFIMPAIRMENTS.HPA.V', 'uint32');

paramTable.addParameter( 'RFIMPAIRMENTS.HPA.IBO', 'uint32');

paramTable.addParameter( 'RFIMPAIRMENTS.MEM_HPA', 'struct');

paramTable.addParameter( 'RFIMPAIRMENTS.MEM_HPA.ENABLE', 'uint32', ...
                          enum.parameterCheck.Property.IS_MANDATORY );

paramTable.addParameter( 'RFIMPAIRMENTS.MEM_HPA.DELAY', 'uint32');

paramTable.addParameter( 'RFIMPAIRMENTS.IQ', 'struct');

paramTable.addParameter( 'RFIMPAIRMENTS.IQ.ENABLE', 'uint32', ... 
                          enum.parameterCheck.Property.IS_MANDATORY );

paramTable.addParameter( 'RFIMPAIRMENTS.IQ.AMP', 'double');

paramTable.addParameter( 'RFIMPAIRMENTS.IQ.PHASE', 'double');

paramTable.addParameter( 'RFIMPAIRMENTS.PHASE_NOISE', 'struct');

paramTable.addParameter( 'RFIMPAIRMENTS.PHASE_NOISE.ENABLE', 'uint32');

paramTable.addParameter( 'RFIMPAIRMENTS.PHASE_NOISE.VARIANCE', 'double');
                     
paramTable.addParameter( 'FRAME_TYPE', 'enum.modem.fiveG.FrameType', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'FRAME', 'enum.modem.fiveG.FrameMap', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         enum.parameterCheck.Property.IS_VECTOR );

paramTable.addParameter( 'NUMBER_OF_SYMBOLS', 'uint32', ...
                        enum.parameterCheck.Property.IS_MANDATORY, ...
                        enum.parameterCheck.Property.IS_VECTOR );
                    
paramTable.addParameter( 'GUARD_PERIOD', 'double', ...
                         enum.parameterCheck.Property.IS_MANDATORY );

paramTable.addParameter( 'USEFUL_BLOCKS', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY );
                     
paramTable.addParameter( 'TRANSPORT_BLOCK_SIZE_BITS', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY  );  
                     
paramTable.addParameter( 'MCS', 'uint32', ...
                         enum.parameterCheck.Property.IS_MANDATORY, ...
                         '%this <= 16' );  
                     
paramTable.addParameter( 'CODE', 'struct', ...
                         enum.parameterCheck.Property.IS_MANDATORY  );   
                     
paramTable.addParameter( 'CODE.TYPE', 'enum.modem.CodeType', ...
                         enum.parameterCheck.Property.IS_MANDATORY  ); 
                     
paramTable.addParameter( 'CODE.TURBO', 'struct' );  
                     
paramTable.addParameter( 'CODE.TURBO.ITERATIONS', 'uint32', ...
                         'default', 3 ,'%this > 0' );
                     
paramTable.addParameter( 'HARQ', 'struct',  ...
                          enum.parameterCheck.Property.IS_MANDATORY);
                      
paramTable.addParameter( 'HARQ.ENABLED', 'logical',  ...
                          'default', 'true');
                      
paramTable.addParameter( 'HARQ.MAX_RETX_TIMER', 'uint32',  ...
                          'default', '1');
                      
paramTable.addParameter( 'HARQ.MAX_NUMBER_OF_RETX', 'uint32',  ...
                          'default', '4');
                      
paramTable.addParameter( 'HARQ.NUMBER_OF_HARQ_PROCESS', 'uint32',  ...
                          'default', '15');
                      
paramTable.addParameter( 'HARQ.MAX_ACK_TIMER', 'uint32',  ...
                          'default', '5');      

paramTable.addParameter( 'HARQ.MAX_NUM_OF_RV', 'uint32',  ...
                          'default', '4'); 
                      
paramTable.addParameter( 'DL_LOAD_RATIO', 'double',  ...
                          enum.parameterCheck.Property.IS_MANDATORY, ...
                          '%this <= 1 && %this >= 0');                       
end


