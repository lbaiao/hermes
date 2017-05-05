%ANTENNATEST function tests the classes related to antenna
%   This function test the creation of IsotropicAntenna and
%   OmnidirectionalAntenna class
%
%   Syntax: AntennaTest
%
%   Author: Lilian Freitas (LCF)
%   Work Address: INDT Manaus
%   E-mail: lilian.freitas@indt.org.br
%   History:
%       v1.0 10 Apr 2015 - (LCF) created
%
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.

%% Test 1: check Antenna class constructor
positionInXYZ = rand( 1, 3);
azimuthAngle_rad = rand;
elevationAngle_rad = rand;
polarization = enum.antenna.AntennaPolarization.VERTICAL ;
maxGain_dBi = 0;
instanceNode = networkEntity.Antenna(positionInXYZ, ...
    azimuthAngle_rad, ...
    elevationAngle_rad, ...
    polarization, ...
    maxGain_dBi);
assert( isa ( instanceNode, 'networkEntity.Antenna' ) );


%% Test 2: check Isotropic Antenna class constructor: syntax 1
positionInXYZ = rand( 1, 3);
azimuthAngle_rad = pi/4;
elevationAngle_rad = pi/5;
polarization = enum.antenna.AntennaPolarization.VERTICAL;
maxGain_dBi = 0;
instanceNode = networkEntity.IsotropicAntenna(positionInXYZ, ...
    azimuthAngle_rad, ...
    elevationAngle_rad, ...
    polarization, ...
    maxGain_dBi);
assert( isa ( instanceNode, 'networkEntity.IsotropicAntenna' ) );

%% Test 3: check Isotropic Antenna class constructor: syntax 2
positionInXYZ = rand( 1, 3);
instanceNode = networkEntity.IsotropicAntenna(positionInXYZ);
assert( isa ( instanceNode, 'networkEntity.IsotropicAntenna' ) );

%% Test 4: check Omnidirectional Antenna class constructor
positionInXYZ = rand( 1, 3);
azimuthAngle_rad = pi/4;
elevationAngle_rad = pi/5;
polarization = enum.antenna.AntennaPolarization.HORIZONTAL;
maxGain_dBi = 0;
radiationPatternElevation = [ 10 1 ; 30 0.9 ; 40 0.8];
instanceNode = networkEntity.OmnidirectionalAntenna ( positionInXYZ, ...
    azimuthAngle_rad, ...
    elevationAngle_rad, ...
    polarization, ...
    maxGain_dBi, ...
    radiationPatternElevation);
assert( isa ( instanceNode, 'networkEntity.OmnidirectionalAntenna' ) );

%% Test 5: check the isotropic antenna method: calculateGain: syntax 1
positionInXYZ = rand( 1, 3);
azimuthAngle_rad = pi/4;
elevationAngle_rad = pi/5;
polarization = enum.antenna.AntennaPolarization.VERTICAL;
maxGain_dBi = 0;

% create an instance of isotropic antenna
instanceNode = networkEntity.IsotropicAntenna(positionInXYZ, ...
    azimuthAngle_rad, ...
    elevationAngle_rad, ...
    polarization, ...
    maxGain_dBi);

% calculate gain using syntax 1
 gain1 = instanceNode.calculateGain(maxGain_dBi, azimuthAngle_rad, ...
    elevationAngle_rad );

 assert( isequal ( gain1, 1 ) );

%% Test 6: check the isotropic antenna method: calculateGain: syntax 2
positionInXYZ = rand( 1, 3);
azimuthAngle_rad = pi/4;
elevationAngle_rad = pi/5;
polarization = enum.antenna.AntennaPolarization.HORIZONTAL;
maxGain_dBi = 0;

% create an instance of isotropic antenna
instanceNode = networkEntity.IsotropicAntenna(positionInXYZ, ...
    azimuthAngle_rad, ...
    elevationAngle_rad, ...
    polarization, ...
    maxGain_dBi);

% calculate gain using syntax 2
 gain2 = instanceNode.calculateGain( );

 assert( isequal ( gain2, 1 ) );

