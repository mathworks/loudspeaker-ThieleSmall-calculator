% calQtc_fromTSVab
% This function calculates Cab, Rab, Mab, boxDepth vol, Va, Vm, Vab, fc, Qmb
% Input:  TS params, box back area, acoustic material 
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. eq. 7.59

% Copyright © 2020-2025 The MathWorks, Inc.  
function Qtc = calQtc_fromTSVabQmb(state, Vab, Qmb)

Qtc = state.Qts * (1/state.Qes + 1/state.Qms)/(1/state.Qes + 1/state.Qms + 1/Qmb)*sqrt(1 + state.Vas/Vab);
