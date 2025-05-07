% calFc_fsQtcQts
% This function calculates  fc -- the enclosed resonance frequency
% Input:  fs, Qtc, Qts
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. 

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function fc = calFc_fsQtcQts(state)
fc =  state.fs * state.Qtc / state.Qts;       % ref eq. 7.28, pg. 325

