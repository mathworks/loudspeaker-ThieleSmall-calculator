% calQmb_fromTSRab
% This function calculates Qmb -- the Q value of the box with filling
% input: Rab -- the resistance of the enclosure box 
%        fs -- resonant frequency of the loudspeaker driver
%        Vas -- air volumme equivalence of the loudspeaker driver 
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. Eq. 7.58

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function Qmb = calQmb_fromTSRab(state, Rab)

    Qmb = state.rho * state.c^2 / (Rab * 2*pi*state.fs * state.Vas);
    