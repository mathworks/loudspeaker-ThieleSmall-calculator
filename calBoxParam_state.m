% calBoxParam_state
% This function calculates Cab, Rab, Mab, boxDepth 
% Input:  Va -- volume of air (in Liter) 
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. 

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function [Cab, Rab, Mab, boxDepth, vol, Va, Vm, Vab, fc, Qmb ] = calBoxParam_state(state)

% getting M_AB
%rd = r*sqrt(pressure_eff); % rough approx of effective radius
Mab = state.rho * state.box.beta * state.mech.or/ state.box.pressure_factor;                   % ref eq. 7.5

% getting R_AB
% Caa -- acoustic compliance of air inside box, 
% Va -- volume of air inside box
% Vm -- volume of lining inside box
% fc -- resonant freq inside box

Va = estVa_fromTS_Vratio(state, state.box.vratio, state.Qtc);  % assume M_MB is infinity
Vm = Va/ state.box.vratio;
Caa = calCaa_Va(state, Va);

%Rf = 412*3;
%mthick = 1; % match air, Rf*mthick/3 = rho*c
Ram = calRam_RfDSm( state.box.Rf, state.box.mthick, state.box.Sm);

fc =  state.fs * state.Qtc / state.Qts;       % ref eq. 7.28, pg. 325
Rab = calRab_RamVaVmCaaFc(state, Ram, Va, Vm, Caa, fc);

% calc box depth
Qmb = calQmb_fromTSRab(state, Rab);
Va = calVa_fromTS_Vratio(state, state.box.vratio, state.Qtc, Qmb);
vol = Va + Vm;                          % ref eq. 7.22
Vab = Va + state.gamma*Vm;                    % ref eq. 7.21
boxDepth = vol / state.box.Sm;

% getting C_AB
% Cam -- compliance of lining 
Cam = Vm / state.P0;                          % ref eq. 7.6, acoustic compliance of air in pores of lining
Cab = Caa + Cam;                        % ref eq. 7.20


