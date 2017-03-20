%MIMOTEST script tests the Mimo class
% This function test the creation of a Mimo object and its methods
%
%   Syntax: MimoTest
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 27 Mar 2015 (FF) - created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check Class Constructor
lteSimulationSettings;
txAnt = 1;

mimo = modem.SpatialCoder( LTE );
mimo.setNumberOfAntennas( txAnt, [] );

assert( isa( mimo, 'modem.SpatialCoder' ) );

%% Test 2: check Alamouti 2x2 precode method
lteSimulationSettings;
LTE.MIMO_SCHEME = enum.modem.MimoScheme.TRANSMIT_DIVERSITY;

txAnt = 2;

nSym = 2;

mimo = modem.SpatialCoder( LTE );
mimo.setNumberOfAntennas( txAnt, [] );

modSymbols = complex(ones(nSym,1),ones(nSym,1));

mimoSymbols = mimo.precode( modSymbols );

expectedPrecoded = [ 1+1i 1+1i;...
                     -1+1i 1-1i ] ./ sqrt(2);
                 
assert( isequal( mimoSymbols, expectedPrecoded ) );

%% Test 3: check Alamouti 2x2 decode method
lteSimulationSettings;
LTE.MIMO_SCHEME = enum.modem.MimoScheme.TRANSMIT_DIVERSITY;
txAnt = 2;
rxAnt = 2;

nSym = 1440;

% mimo tx object
mimo = modem.SpatialCoder( LTE );
mimo.setNumberOfAntennas( txAnt, [] );

% modulated symbols
modSymbols = complex(ones(nSym,1),ones(nSym,1));

% mimo precoding
mimoSymbols = mimo.precode( modSymbols );

% channel in frequency
% all symbols have the same channel response
ch = complex( randn( 1, rxAnt, txAnt ), ...
              randn( 1, rxAnt, txAnt ) );
channel = zeros( nSym, rxAnt, txAnt );
% propagate
rxSignal = zeros( rxAnt, nSym );
for sym = 1 : nSym
    channel( sym, :, : ) = ch( 1, :, : );
	rxSignal( :, sym ) = squeeze( channel( sym, :, : ) ) * mimoSymbols( sym, : ).';
end

% mimo rx object
mimo.setNumberOfAntennas( [], rxAnt );

% mimo decoding
rxSymbols = mimo.equalize( rxSignal.', channel );

% error computation
err = mean( abs( modSymbols - rxSymbols ) );

assert( isequal( err < 1e-14, 1 ) );

%% Test 4: check Spatial Multiplexing 2x2 decode method
% Test Open Loop MIMO scheme
lteSimulationSettings;
LTE.MIMO_SCHEME = enum.modem.MimoScheme.OPEN_LOOP;
txAnt = 2;
rxAnt = 2;

nSym = 1440 * txAnt;

% mimo tx object
mimo = modem.SpatialCoder( LTE );
mimo.setNumberOfAntennas( txAnt, [] );

% modulated symbols
modSymbols = complex( ones( nSym * txAnt, 1 ), ones( nSym * txAnt , 1 ) );

% mimo precoding
mimoSymbols = mimo.precode( modSymbols );

% channel in frequency
% all symbols have the same channel response
ch = complex( randn( 1, rxAnt, txAnt ), ...
              randn( 1, rxAnt, txAnt ) );
channel = zeros( nSym, rxAnt, txAnt );
% propagate
rxSignal = zeros( rxAnt, nSym );
for sym = 1 : nSym
    channel( sym, :, : ) = ch( 1, :, : );
	rxSignal( :, sym ) = squeeze( channel( sym, :, : ) ) * mimoSymbols( sym, : ).';
end

% mimo rx object
mimo.setNumberOfAntennas( [], rxAnt );

% mimo decoding
rxSymbols = mimo.equalize( rxSignal.', channel );

% error computation
err = mean( abs( modSymbols - rxSymbols ) );

assert( isequal( err < 1e-14, 1 ) );
