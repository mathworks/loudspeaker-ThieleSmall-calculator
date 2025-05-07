% calBoxParam_state
% This function calculates Cab, Rab, Mab, boxDepth_Rmd, vol_Rmd, Va_Rmd
% Input:  box dimenstions, TS params 
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. 

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function [Cab, Rab, Mab, vol_Rmd, Va_Rmd, boxDepth_Rmd, Vm_Rmd, Qmb] = calBoxRLC_BoxParam(state)

% getting M_AB
%rd = r*sqrt(pressure_eff); % rough approx of effective radius
Mab = state.rho * state.box.beta * state.mech.or/ state.box.pressure_factor;                   % ref eq. 7.5

% getting R_AB
% Caa -- acoustic compliance of air inside box, 
% Va -- volume of air inside box
% Vm -- volume of lining inside box
% fc -- resonant freq inside box

% Va = estVa_fromTS_Vratio(state, state.box.vratio, state.Qtc);  % assume M_MB is infinity
% Vm = Va/ state.box.vratio;
Caa = calCaa_Va(state, state.box.Va);

%Rf = 412*3;
%mthick = 1; % match air, Rf*mthick/3 = rho*c
Ram = calRam_RfDSm( state.box.Rf, state.box.mthick, state.box.Sm);

%fc =  state.fs * state.Qtc / state.Qts;       % ref eq. 7.28, pg. 325
Rab = calRab_RamVaVmCaaFc(state, Ram, state.box.Va, state.box.Vm, Caa, state.fc);

% calc box depth
Qmb = calQmb_fromTSRab(state, Rab);


Va_Rmd = calVa_fromTS_Vratio(state, state.box.vratio, state.Qtc, Qmb);
vol_Rmd = Va_Rmd + state.box.Vm;                          % ref eq. 7.22
%Vab_Rmd = Va_Rmd + state.gamma*Vm;                    % ref eq. 7.21
boxDepth_Rmd = vol_Rmd / state.box.Sm;
Vm_Rmd = vol_Rmd - Va_Rmd;

% getting C_AB
% Cam -- compliance of lining 
Cam = state.box.Vm / state.P0;                          % ref eq. 7.6, acoustic compliance of air in pores of lining
Cab = Caa + Cam;                        % ref eq. 7.20


