% calCaa_Va
% This function calculates Caa -- the acoustic compliance of air inside box
% Input:  Va -- volume of air (in Liter) 
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. eq. 7.4
%
% Copyright © 2020-2025 The MathWorks, Inc.  
%
function Caa = calCaa_Va(state, Va)

% gamma = 1.4;    % 
% P0 = 1e5;       % atmospheric pressure in Pa

% Va needs to be in m^3, (1 m^3 = 1000 L)
Caa = Va/(state.gamma*state.P0);
