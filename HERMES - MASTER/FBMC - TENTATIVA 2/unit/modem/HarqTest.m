%HARQTEST function tests the MODEM.HARQ Class
%
%   Syntax: HarqTest
%
%   Author: Rafhael Amorim (RA)
%   Work Address: INDT Brasilia
%   E-mail: rafhael.amorim@indt.org.br
%   History:
%        v2.0 14  July 2015 - (RA) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


%% Test 1: check class constructor for LTE
lteSimulationSettings;
lteParamTable = parameterCheck.loadLteParametersTable;
LTE.MCS = randi([0 26]);
LTE = parameterCheck.lteCheckParameters( LTE, lteParamTable);
linkDirection = [];
numberOfPackets = randi( [0,10] );
harqObject = modem.Harq( LTE.HARQ, numberOfPackets, linkDirection );

assert ( isa( harqObject, 'modem.Harq' ) );
%% Test 2: check class constructor for 5G
fiveGSimulationSettings;
fiveGParamTable = parameterCheck.loadFiveGParametersTable;
FIVEG = parameterCheck.fiveGCheckParameters( FIVEG, fiveGParamTable);
numberOfPackets = randi( [0,10] );
linkDirection = [];
harqObject = modem.Harq( FIVEG.HARQ, numberOfPackets, linkDirection );

assert ( isa( harqObject, 'modem.Harq' ) );