% calFrontM_rVolF
% This function calculates front_M -- the inductance at the front side of
% the loudspeaker
% Input:  r -- the diameter of the diaphram 
%         Vol -- volume of the box
%         front_eval_freq -- volume of lining in the box
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. pg 333 , pg 315, fig 4.35 table 4.4, fig 4.39 table 4.5

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function front_M = calFrontM_rVolF(state, r, vol, front_eval_freq)

largeBoxVol = 0.6^3;        %ref pg 313

%r = state.mech.or;
c= state.c;
rho = state.rho;

consF = c/(r*2*pi);

    wavlen = c/front_eval_freq;
    k = 2*pi/wavlen;
    ka = k * r;    
    if vol > largeBoxVol
        % vary large box, approx inf baffle        
        if ka < 1
           front_M = 8*rho/(3*pi^2)/r; 
  
        else
           front_M = 8*rho/(3*pi^2)/r * (consF / front_eval_freq )^2; % approx fig 4.39
        end
    else
        % small to med box                    
        if ka < 1
           front_M = (2*rho/pi^2) / r; 
      
        else
           front_M =  (2*rho/pi^2)/r * (consF / front_eval_freq )^2; % approx fig 4.39
        end
    end
