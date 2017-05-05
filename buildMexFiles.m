function buildMexFiles(  )
% BUILDMEXFILES builds all MEX (Matlab Executable) files.
%   This script runs all .c functions in HERMES and compiles it. 
%   There is no need in run BUILDMEXFILES for every HERMES Simulation. 
%   Once the MEX Files are built, HERMES Simulations flow without need of
%   BUILDMEXFILES.
   % include here the list of all ".c" files
   
%   Author: Lilian Freitas (LCF), 
%   Work Address: INDT Manaus/Brasilia
%   E-mail: <lilian.freitas>@indt.org.br,
%   History:
%       v2.0 25 Apr 2015 (LCF) - created
    hermesDir = pwd;
    sourceDir = [ pwd, filesep, 'src'];
    modemDir = [ sourceDir, filesep, '+modem' ];
    % ========== Convolutional Code ================
    mexConvDir = [ modemDir, filesep, '@ConvolutionalCode' ];
        % Compile Decoder
    mex('-outdir', mexConvDir, [ mexConvDir, filesep, 'viterbiDecoderMex.c' ]);
    mex('-outdir', mexConvDir, [ mexConvDir, filesep, 'convEncoderMex.c' ]); 
    % ========== Turbo Code ===================
    mexTurboDir = [ modemDir, filesep, '@TurboCode' ];
        %  Compile Decoder
    mex('-outdir', mexTurboDir, [ mexTurboDir, filesep, 'sovaDecoderMex.c' ]);

end
