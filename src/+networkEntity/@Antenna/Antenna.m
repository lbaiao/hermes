classdef Antenna < handle
%ANTENNA class defines the antenna array for the nodes.
%   This class defines the common properties and methods for each antenna 
%   type. Specific properties and methods are defined inside each
%   sub-class.
%
%   Read-Only Properties:
%           positionInXYZ - < N x 3 double > (m) defines antenna position
%               on X, Y, Z dimension for each N antenna element.
%           maxGain_dBi - < 1 x 1 double > (dBi) defines antenna gain.
%           azimuthAngle_rad   - < 1 x 1 double > (radian) defines the
%               azimuth angle.
%           elevationAngle_rad - < 1 x 1 double > (radian) defines the
%               elevation angle.
%           polarization -  <1 x 1 enum>  defines antenna polarization from
%               src/enum/antenna/AntennaPolarization.m
%
%   Methods:
%   constructor
%       Syntax: this = networkEntity.Antenna ( positionInXYZ, ...
%                                              azimuthAngle_rad, ...
%                                              elevationAngle_rad, ...
%                                              polarization, ...
%                                              maxGain_dBi )
%       Input:
%           positionInXYZ - < N x 3 double > (m) defines antenna position
%               on X, Y, Z dimension for each N antenna element.
%           maxGain_dBi - < 1 x 1 double > (dBi) defines antenna gain.
%           azimuthAngle_rad   - < 1 x 1 double > (radian) defines the
%               azimuth angle.
%           elevationAngle_rad - < 1 x 1 double > (radian) defines the
%               elevation angle.
%           polarization -  <1 x 1 enum>  defines antenna polarization from
%               src/enum/antenna/AntennaPolarization.m.
% 
%   calculateGain
%       Syntax 1: [ gain ] = calculateGain ( maxGain_dBi, ...
%                                            azimuthAngle_rad, ...
%                                            elevationAngle_rad )
%       Syntax 2: [ gain ] = calculateGain (  )
%           Calculate the antenna gain.
%       Input:
%           maxGain_dBi - < 1 x 1 double > (dBi) defines antenna gain.
%           azimuthAngle_rad   - < 1 x 1 double > (radian) defines the
%               azimuth angle.
%           elevationAngle_rad - < 1 x 1 double > (radian) defines the
%               elevation angle.
%       Output:
%       	gain < double > : antenna gain in dBi.
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
%   stipulated in the agreement/contract under which the program has 
%   been supplied.

    properties ( GetAccess = 'public', SetAccess = 'protected' )

        positionInXYZ;

        azimuthAngle_rad;

        elevationAngle_rad;

        polarization;

        maxGain_dBi;

    end

    methods

        % Class Constructor
        function this = Antenna ( positionInXYZ, ...
                azimuthAngle_rad, ...
                elevationAngle_rad, ...
                polarization, ...
                maxGain_dBi )

            this.positionInXYZ = positionInXYZ;

            this.azimuthAngle_rad = azimuthAngle_rad;

            this.elevationAngle_rad = elevationAngle_rad;

            this.polarization = polarization;

            this.maxGain_dBi = maxGain_dBi;

        end

        gain = calculateGain( this , maxGain_dBi, azimuthAngle_rad, ...
                              elevationAngle_rad );

    end

end
