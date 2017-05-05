function [ equalizedSignal ] = equalizeNone( this, mimoSignal, ...
                                                   channel )
%SPATIALCODER.EQUALIZENONE method calls the non-MIMO equalizer scheme.
%   
%   Syntax: [ equalizedSignal ] = equalize( mimoSignal, ...
%                                               channel ) 
%   Input:
%       mimoSignal < Nsymb x NRx complex > - received signal.
%           Nsymb: number of symbols in the frame.
%           NRx: number of receive antennas.
%       channel < Nsymb x NRx x NTx complex > - channel gain at each data
%           symbol.
%           NTx: number of transmit antennas.
%   Output:
%       equalizedSignal < Nsymb x 1 complex > - decoded symbols.
%       	Nsymb : number of data symbols in the frame.
%   
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v2.0 15 Jun 2015 (FF) - created
%	
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%	
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

equalizedSignal = mimoSignal;

end

