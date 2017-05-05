classdef OmnidirectionalAntenna < networkEntity.Antenna
%OMNIDIRECTIONALANTENNA defines an array of omnidirectional antennas.
%   This class inherits the main properties from "Antenna" class and
%   defines specific properties and methods for omnidirectional antenna
%   array.
%
%   Properties:
%      radiationPatternElevation - < nAngles x 2 double > (radian x dBi)
%           defines antenna pattern. For each elevation angle there is an 
%           antenna gain.
% 
%   Methods:
%   Constructor
%   	Syntax: this = networkEntity.OmnidirectionalAntenna ( ...
%                                             positionInXYZ, ...
%                                             azimuthAngle_rad, ...
%                                             elevationAngle_rad, ...
%                                             polarization, ...
%                                             maxGain_dBi, ...
%                                             radiationPatternElevation )
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
%           radiationPatternElevation - <nAngles x 2 double> (radian x dBi)
%               defines antenna pattern. For each elevation angle there is
%               an antenna gain.
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

    properties ( GetAccess = 'public', SetAccess = 'protected' )

        radiationPatternElevation;

    end

    methods

        % Class constructor
        function this = OmnidirectionalAntenna ( positionInXYZ, ...
                azimuthAngle_rad, ...
                elevationAngle_rad, ...
                polarization, ...
                maxGain_dBi, ...
                radiationPatternElevation )

            % Call superclass constructor
            this = this@networkEntity.Antenna(positionInXYZ, ...
                azimuthAngle_rad, ...
                elevationAngle_rad, ...
                polarization, ...
                maxGain_dBi);

            % Assign property value
            this.radiationPatternElevation = radiationPatternElevation;

        end

    end

end
