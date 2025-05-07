% calQtc_FcFsQts
% This function calculates  fc -- the enclosed resonance frequency
% Input:  fc, fs, Qts
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. 

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function Qtc = calQtc_FcFsQts(state)
Qtc =  state.fc / state.fs * state.Qts;       % ref eq. 7.28, pg. 325

