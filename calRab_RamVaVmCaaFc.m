% calRab_RamVaVmCaaFc
% This function calculates Rab -- the resistance of the loudspeaker
% enclosure box based on the values Ram, Va, Vm, Caa, fc
% Input:  Ram -- resistance of the lining in the box
%         Va -- volume of air in the box
%         Vm -- volume of lining in the box
%         Caa -- capacitance of the air in the box
%         fc -- the resonant frequency of the enclosed loudspeaker
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. Eq. 7.7

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function Rab = calRab_RamVaVmCaaFc(state, Ram, Va, Vm, Caa, fc)

    %state.gamma = 1.4;    % for air for adiabatic compressions
    w = 2*pi* fc;
    
    Rab = Ram / ( 1 + Va/(state.gamma*Vm))^2 + w^2*Ram^2*Caa^2;       % ref eq 7.7
