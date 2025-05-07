% updateTSparam
% This function would calculate the Thiele-Small parameters 
% input: state.elec    -- this structure holds the electrical parameters
%        state.mech    -- this structure holds the mechanical parameters
% output:  state.Qms, state.Qes, state.fs, state.Sd, state.Vas, state.Qts, state.decayRate 
%
% reference:  Leo L. Beranek, Tim J. Mellow, "Acoustics: Sound Fields and
% Transducers", 2012. Eq. 6.12, 6.11, 6.8, 6.26, 6.10, 6.115

% Copyright © 2020-2025 The MathWorks, Inc.  
%
function state = updateTSparam(state)

            %state.ReohmsEditField.Value = state.elec.Re;
            
            state.Qms = sqrt(state.mech.mm / state.mech.cm)/state.mech.rm;      % ref eq 6.12           
            state.Qes = state.elec.Re/(state.elec.Bl*state.elec.Bl)*sqrt(state.mech.mm/state.mech.cm);  % ref eq. 6.11                       
            state.fs = 1/(2*pi*sqrt(state.mech.mm*state.mech.cm));              % ref eq. 6.8
            
            
            if state.mech.ir > 0.001
               state.Sd = pi/3*(state.mech.or*state.mech.or+state.mech.or*state.mech.ir+state.mech.ir*state.mech.ir);
            else
               state.Sd = pi*state.mech.or*state.mech.or; % *state.area_scale;
            end

            state.Vas = state.mech.cm * state.Sd*state.Sd* state.rho*state.c^2; % ref eq. 6.26
            
            state.Qts = 1/(1/state.Qes+1/state.Qms);                            % ref eq 6.10
            
            % update param in Other 
            state.decayRate = 2*pi*state.fs / (2 * state.Qts);                  % ref eq. 6.115
