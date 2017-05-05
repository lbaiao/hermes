classdef WifiScrambler < modem.Scrambler
    % WIFISCRAMBLER class implements the 802.11ac Scrambler object.
    % Scrambler object is responsible for scrambling and descrambling the
    % transmission signal.
    %
    %   Read-Only Public Properties:
    %		shiftRegister < 1 x B bits > Vector that contains the values of linear
    %       feedback shift register. The length of this property vector must be
    %       equal the order of scrambler Polynomial. For 802.11ac  B = 7.
    %
    %		initialRegisterState < 1 x 1 integer  > initial value of linear
    %       feedback shift register. Must be in the range 1 to 127. Zero is
    %       an invalid value.
    %
    %   Methods
    %
    %   constructor
    %       Assembles a scrambler object. Initializes the initial values of the
    %       linear feedback shift register.
    %
    %       Syntax
    %           this = WifiScrambler( initialSeed )
    %       Inputs
    %           initialSeed < 1 x 1 integer >: initial state according
    %           to the value defined in Service Field. Is the initial values of
    %           linear feedback shift register
    %
    %   updateRegisterInitialValue
    %       Updates the initialization value of the linear feedback shift register.
    %       Syntax
    %           this.updateRegisterInitialValue( newSeedNumber )
    %       Input
    %           newSeedNumber < 1 x 1 integer >: seed number according
    %           to the value defined in Service Field.
    %
    %   scramble
    %       This function scrambles input sequence as per defined in IEEE 802.11ac
    %       section 18.3.5.5.
    %
    %       Syntax
    %           transmittedSequence = this.scramble( this, inputSequence )
    %
    %       Input
    %           inputSequence < B x 1 bits >: contains a sequence of B bits
    %
    %
    %       Output
    %           transmittedSequence  < B x 1 bits >: contains a sequence of B
    %           scrambled bits
    %
    %    descramble
    %           This function descrambles the input sequence, using the same
    %           gold sequence used in the scrambling process.
    %
    %
    %           Syntax
    %               receivedSequence = this.descramble( inputSequence )
    %
    %           Input
    %               inputSequence < B x 1 bits >: contains a sequence of B
    %           scrambled bits
    %
    %           Output
    %               receivedSequence < B x 1 bits >: contains a sequence of B
    %           descrambled bits
    %
    %   Author: Sergio Abreu (SA)
    %   Work Adress: INDT Manaus
    %   E-mail: sergio.abreu@indt.org.br
    %   History:
    %       v2.0 23 June 2015 (SA) - created
    %
    %   Copyright (c) 2015 INDT - Institute of Technology Development.
    %
    %   The program may be used and/or copied only with the written
    %   permission of INDT, or in accordance with the terms and conditions
    %   stipulated in the agreement/contract under which the program has been
    %   supplied.
    
    properties ( GetAccess = 'public', SetAccess = 'protected' )
        shiftRegister,
        initialRegisterState
    end
    
    methods ( Access = public )
        
        % constructor
        function this = WifiScrambler( initialSeed )
            
            % check for error in initilization state
            if (initialSeed == 0)
                error('Initial seed can not be zero' );
            end
            
            % initialization of shift register
            this.initialRegisterState = initialSeed;
            this.shiftRegister = de2bi(initialSeed,7,'left-msb');
            
        end
        
        % methods definition
        % scramble
        transmittedSequence = scramble( this, inputSequence );
        % descramble
        receivedSequence = descramble( this, inputSequence );
        % update the Register Value
        updateRegisterInitialValue( this,  newSeed );
        
    end
    
end