% calFrontR_rVolF
% This function calculates front_R -- the resistance at the front side of
% the loudspeaker
% Input:  r -- the diameter of the diaphram 
%         Vol -- volume of the box
%         front_eval_freq -- volume of lining in the box
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. pg 333 , pg 315, fig 4.35 table 4.4, fig 4.39 table 4.5

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function front_R = calFrontR_rVolF(state, r, vol, front_eval_freq)

largeBoxVol = 0.6^3;        %ref pg 313

%r = state.mech.or;
c= state.c;
rho = state.rho;
S = pi * r*r;
%consFrontR = c/(r*2*pi);


    ff = front_eval_freq;
    
    wavlen = c/ff;
    k = 2*pi/wavlen;
    ka = k * r;    
    if vol > largeBoxVol
        % vary large box, approx inf baffle        
        if ka < 1
           RR = rho*(2*pi)^2/(2*pi*c) * ff^2;  
  
        else
           RR = rho*c / S;
        end
    else
        % small to med box                    
        if ka < 1
           RR = rho*(2*pi)^2/(4*pi*c) * ff^2;  %?
      
        else
           RR = rho*c / S;
        end
    end
    front_R = RR; %[front_R; RR];

