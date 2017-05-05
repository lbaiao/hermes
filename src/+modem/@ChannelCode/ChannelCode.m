classdef ChannelCode < handle
%CHANNELCODE class represents the basic coding of a bit stream.
%   The methods of this superclass define a dummy channel coding by simply
%   outputting its input. This is a superclass, real coding techniques are 
%   implemented in subclasses.
%
%   Read-Only Public Properties:
%       codeRate < 1 x 1 double > : Proportion of the data-stream that 
%           is useful (non-redundant)
%       codeType < enum > : Type of code defined in +enum/+modem/CodeType.m
%       codeBlockSize < 1 x M double>: The code block size (bits) for each
%       of the M Code Blocks.
%   Methods:
%   Constructor
%       Syntax: this = code.ChannelCode()
%           This constructor instances a simple dummy channel coding.
%
%   encode
%       Syntax: [ encodedBits ] = encode( txPackets )
%           Returns an encoded bit stream.
%       Input:
%           txPackets < 1 x M > : Array with M bits
%
%       Output:
%           encodedBits < 1 x K bits > : Encoded bit stream output
%
%   decode
%       Syntax: dataBits = decode( llrInput )
%           Returns the decoded received packets
%       Input:
%           llrInput < 1 x K double > : LLR (log-likelihood ratio) stream
%                                   K : Number of code bits
%       Output:
%           dataBits < 1 x K * codeRate binary> : decoded data bits
%           
%
%   Author: Fadhil Firyaguna (FF)
%   Work Address: INDT Brasília
%   E-mail: fadhil.firyaguna@indt.org
%   History:
%       v1.0 23 Mar 2015 (FF) - created
%       
%   Copyright (c) 2015 INDT - Institute of Technology Development.
%
%   The program may be used and/or copied only with the written
%   permission of INDT, or in accordance with the terms and conditions
%   stipulated in the agreement/contract under which the program has been
%   supplied.


    properties ( GetAccess = 'public', SetAccess = 'protected' )
        codeRate;
        codeType;
        codeBlockSize;
    end
    
    properties ( Access = 'protected' )
    end
    
    methods ( Access = 'public' )

        % constructor
        function this = ChannelCode()
            this.codeRate = 1;
            this.codeType = enum.modem.CodeType.NONE;
            this.codeBlockSize = [];
        end
        % end constructor
    
        % codec methods
        [ encodedBits ] = encode( this, txPackets );
        [ rxPackets ] = decode( this, llrInput );
    
end

end
