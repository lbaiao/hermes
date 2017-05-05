Heterogeneous Radio Mobile Simulator (HERMES)

Copyright (c) 2015 INDT - Institute of Technology Development.

The program may be used and/or copied only with the written
permission of INDT, or in accordance with the terms and conditions
stipulated in the agreement/contract under which the program has been
supplied.


This is HERMES V2.0:
* A Semi-static Link Level Simulator based on Time-driven mechanism.
* written in object-oriented MATLAB (tested in version 2014b)
* HERMES is a Multi-RAT Simulator and can support several transmit modems
  at the same time.


Developers:
- Andre Barreto <andre.noll@indt.org>
- Rafhael Amorim <rafhael.amorim@indt.org.br>
- Erika Almeida <erika.almeida@indt.org.br>
- Fadhil Firyaguna <fadhil.firyaguna@indt.org>
- Artur Rodrigues
- Lilian Freitas

---------------------------------------------------------
List of Features Included added in HERMES V2.0:
- multipath channel model
    - arbitrary power delay profile
    - COST-259

- LTE improvements
    - Turbo code
    - scrambling 
- 5G
   - draft flexible TDD frame structure
   - same encoder and scrambler as LTE
   - OFDM
   - ZT-DS-OFDM
       - ZF and MMSE equalizers

- missing features
   - MIMO
   - channel estimation
   - HARQ	

---------------------------------------------------------
List of Features Included in HERMES V1.0:
- Multipath Channel: Unitary Impulse Response Channel.
- AWGN Channel
- Transmission Technology: LTE OFDMA
    - TDD Frame
    - PDSCH Modulation: QPSK / 16QAM / 64QAM / 256QAM.
    - Cyclic Prefix: NORMAL / EXTENDED
    - SISO.
    - PDCCH Length: 1 / 2 / 3 OFDM Symbols.
