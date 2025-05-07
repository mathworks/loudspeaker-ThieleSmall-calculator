% estVa_fromTS_Vratio
% This function estimates Va -- the air volume inside the enclosure box.
% The estimation assumes Q_mb is infinity.
% input: vratio -- vratio = Va / Vm, ratio of air volume over lining volume 
%        Qtc -- Q value of enclosure
%        Qts -- Q value of loudspeaker driver
%        Vas -- air volumme equivalence of the loudspeaker driver
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. Eq. 7.61

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function Va = estVa_fromTS_Vratio(state, vratio, Qtc)

Va = state.Vas / ((1+ state.gamma / vratio)*(Qtc^2 / state.Qts^2 - 1));

