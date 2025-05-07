% EstXmax_fromTSEgVab
% This function estimates xmax -- the maximum displacement of the loudspeaker driver.
% The estimation is based on the gain of the system at the resonant frequency.
% input: Eg -- the input voltage from the amplifier 
%        Vab -- the equivalent volume of the enclosure with lining
%        fs -- the resonant frequency of the loudspeaker driver
%        Bl -- the steady air-gap magnetic field or flex density in Tesla
%        Qes -- Q value of the electrical section of the driver
%        Vas -- equivalent air volume for the loudspeaker driver
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. Eq. 7.64

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function exmax = EstXmax_fromTSEgVab(state, Eg, Vab)

    exmax = Eg / ( state.fs * 2 * pi * state.elec.Bl * state.Qes * (1+ state.Vas/ Vab));
    