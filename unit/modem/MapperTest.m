%MAPPERTEST function tests the Mapper class
%   This function tests the Mapper class considering the modulations: BPSK,
%   QPSK, 16-QAM, 64-QAM and 256-QAM.
%
%   Syntax: MapperTest
%
%   Author: Lilian Freitas (LCF),
%   Work Address: INDT Manaus
%   E-mail: <lilian.freitas>@indt.org.br>
%   History:
%       v2.0 20 May 2015 - (LCF) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check Mapper constructor
possibleModOrder = [2, 4, 16, 64, 256];
modulationOrder = possibleModOrder( randi( [1,5] ) );

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
bitsPerSymbol = log2( modulationOrder);
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
assert( isa ( instanceMapper, 'modem.Mapper' ) );

%% Test 2: check map method for BPSK
modulationOrder = 2;
bitsPerSymbol = log2( modulationOrder);
bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1)';

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );

modulatedSignal = instanceMapper.map( txBits );
alphabet = instanceMapper.symbolAlphabet{bitsPerSymbol};
error = real(modulatedSignal - alphabet).^2 + ...
    imag(modulatedSignal - alphabet).^2;
assert(sum(error) < 1e-10);

%% Test 3: check map method for QPSK
modulationOrder = 4;
bitsPerSymbol = log2( modulationOrder);
bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1)';

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );

modulatedSignal = instanceMapper.map( txBits );
alphabet = instanceMapper.symbolAlphabet{bitsPerSymbol};
error = real(modulatedSignal - alphabet).^2 + ...
    imag(modulatedSignal - alphabet).^2;
assert(sum(error) < 1e-10);

%% Test 4: check map method for 16QAM
modulationOrder = 16;
bitsPerSymbol = log2( modulationOrder);
bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1)';

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );

modulatedSignal = instanceMapper.map( txBits );
alphabet = instanceMapper.symbolAlphabet{bitsPerSymbol};
error = real(modulatedSignal - alphabet).^2 + ...
    imag(modulatedSignal - alphabet).^2;
assert(sum(error) < 1e-10);

%% Test 5: check map method for 64QAM
modulationOrder = 64;
bitsPerSymbol = log2( modulationOrder);

bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1)';

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );

modulatedSignal = instanceMapper.map( txBits );
alphabet = instanceMapper.symbolAlphabet{bitsPerSymbol};
error = real(modulatedSignal - alphabet).^2 + ...
    imag(modulatedSignal - alphabet).^2;
assert(sum(error) < 1e-10);

%% Test 6: check map method for 256QAM
modulationOrder = 256;
bitsPerSymbol = log2( modulationOrder);

bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1)';

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );

modulatedSignal = instanceMapper.map( txBits );
alphabet = instanceMapper.symbolAlphabet{bitsPerSymbol};
error = real(modulatedSignal - alphabet).^2 + ...
    imag(modulatedSignal - alphabet).^2;
assert(sum(error) < 1e-10);

%% Test 7: check calculateLlr method using IDEAL_AWGN for BPSK
modulationOrder = 2;
bitsPerSymbol = log2( modulationOrder);

bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));

%% Test 8: check calculateLlr method using IDEAL_AWGN for QPSK
modulationOrder = 4;
bitsPerSymbol = log2( modulationOrder);
bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal);
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));

%% Test 9: check calculateLlr method using IDEAL_AWGN for 16QAM
modulationOrder = 16;
bitsPerSymbol = log2( modulationOrder);
bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));

%% Test 10: check calculateLlr method using IDEAL_AWGN for 64QAM
modulationOrder = 64;
bitsPerSymbol = log2( modulationOrder);
bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));
%% Test 11: check calculateLlr method using IDEAL_AWGN for 256QAM
modulationOrder = 256;
bitsPerSymbol = log2( modulationOrder);
bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.IDEAL_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));

%% Test 12: check calculateLlr method using MAX_LOG_MAP for BPSK
modulationOrder = 2;
bitsPerSymbol = log2( modulationOrder);

bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.NEAREST_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder  );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));

%% Test 13: check calculateLlr method using NEAREST_AWGN for QPSK
modulationOrder = 4;
bitsPerSymbol = log2( modulationOrder);

bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.NEAREST_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));

%% Test 14: check calculateLlr method using NEAREST_AWGN for 16QAM
modulationOrder = 16;
bitsPerSymbol = log2( modulationOrder);

bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.NEAREST_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));

%% Test 15: check calculateLlr method using NEAREST_AWGN for 64QAM
modulationOrder = 64;
bitsPerSymbol = log2( modulationOrder);

bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.NEAREST_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));

%% Test 16: check calculateLlr method using NEAREST_AWGN for 256QAM
modulationOrder = 256;
bitsPerSymbol = log2( modulationOrder);
bits = ( 0: modulationOrder - 1 );
txBits = de2bi( bits, 'left-msb' );
txBits = vec2mat(txBits,1);

symbols = -modulationOrder/2: modulationOrder/2;
symbols = [symbols(1:modulationOrder/2) symbols(modulationOrder/2+2:end)] ;
randomConstellation{bitsPerSymbol} = symbols + 1i*symbols;
llrMethod = enum.modem.LlrMethod.NEAREST_AWGN;
instanceMapper = modem.Mapper(randomConstellation, modulationOrder );
instanceMapper.setLlrMethod( llrMethod );

modulatedSignal = instanceMapper.map( txBits );
demodulatedSignal = instanceMapper.calculateLlr( modulatedSignal );
rxBits = demodulatedSignal > 0;
assert(isequal( rxBits, txBits ));