% calVab_vol
% This function calculates  Vab -- the effective volume
% Input:  Va, Vm
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. 

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function Vab = calVab_vol(state)
Vab = state.box.Va + state.gamma*state.box.Vm;                    % ref eq. 7.21
