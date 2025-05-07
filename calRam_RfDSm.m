% calRam_RfDSm
% This function calculates Ram -- the air flow resistance of acoustic materials inside box
% Input:    Rf -- flow resistance in rayls
%           mthick -- thickness of the material
%           Sm -- back area of the materials used
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. ref eq. 7.7, pg. 326

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function Ram = calRam_RfDSm(Rf, mthick, Sm)

   ff = Rf*mthick/3;  % optimum sound absorption at high freq is when ff= rho*c
   
   Ram = ff / Sm; 
