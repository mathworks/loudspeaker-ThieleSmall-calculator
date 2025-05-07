% calVa_fromTS_Vratio
% This function calculates Va -- the air volume inside the enclosure box
% input: vratio -- vratio = Va / Vm, ratio of air volume over lining volume 
%        Qtc -- Q value of enclosure
%        Qmb -- Q value of mechical section
%        Qts -- Q value of loudspeaker driver
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. Eq. 7.60, Ex. 7.2

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function Va = calVa_fromTS_Vratio(state, vratio, Qtc, Qmb)

Va = state.Vas / ((1+ state.gamma / vratio)*(Qtc^2 * (1/state.Qts + 1/Qmb)^2 - 1));        % ref eq 7.60
