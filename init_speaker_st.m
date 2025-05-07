% Name: init_speaker_st
% This script initializes the parameters for the electrical and the mechanical components. 
% Values specified in this script would contribute in the calculations of
% Thiele-Small parameters.

% Copyright © 2020-2025 The MathWorks, Inc.  

Re = 5.85;             % ohms
Le = 1.2e-4;        % henries 0.6e-3
Bl   = 5.4;         % N/A  Newtons/Amp => 3.869
mm = 0.013;          % kg => 0.013
cm  = 0.001503;       % 0.56 mm/N, 0.394e-3? 0.56e-3; 1.5e-3
rm  = 1.2;          % kg/s => 1.2


%% Dayton Audio DA270 8 10 
Re = 6.3;             % ohms
Le = 1.2e-4;        % henries 0.6e-3
Bl   = 10.1;         % N/A  Newtons/Amp => 3.869
mm = 0.0513;          % kg => 0.013
cm  = 0.00064;       % 0.56 mm/N, 0.394e-3? 0.56e-3; 1.5e-3
rm  = 2.996;          % kg/s => 1.2


state.elec.Re = Re;
state.elec.Le = Le;
state.elec.Bl = Bl;
state.mech.mm = mm;
state.mech.cm = cm;
state.mech.rm = rm;


%%
%load ee_solenoid_fem_data

xmax = 1e-2; % 1cm = 0.01 m
state.mech.xmax = xmax;

localScale = 1;        % scaling to match simulations

Bcond = 1;                          % Flag of linear and nonlinear Bl-product
Kcond = 1;                          % Flag of linear and nonlinear stiffness	
Lcond = 1;                          % Flag of linear and nonlinear inductance


%b0 = 20.148;                % BL enter as-is from Klippel
b0 = Bl *localScale;                     % (rab)
if Bcond == 1
    b1 = 0.07461*1e3*localScale;           % Enter number * e3 from Klippel
    b2 = -0.014238*1e6*localScale;         % Enter number * e6 from Klippel
    b3 = 0.0022593*1e9*localScale;         % Enter number * e9 from Klippel
    b4 = -0.00034589*1e12*localScale;      % etc...
    b5 = -1.23E-05*1e15*localScale;
    b6 = 1.34E-06*1e18*localScale;
    b7 = 1.36E-08*1e21*localScale;
    b8 = -1.78E-09*1e24*localScale;
else
    b1 = 0.0;
    b2 = 0.0;
    b3 = 0.0;
    b4 = 0.0;
    b5 = 0.0;
    b6 = 0.0;
    b7 = 0.0;
    b8 = 0.0;
end
%[Blxx] = [b8 b7 b6 b5 b4 b3 b2 b1 b0];
Blxx = [b0 b1 b2 b3 b4 b5 b6 b7];

% Stiffness (assumes Newtons / Meter) :	
% Vb = 2.558;                             % 8 CF = 0.2265 m3 roof pit, set to 1e9 for free air
% ro = 1.2;								% Air density kg/(m^3)
% c = 343;								% Sound velocity	(m/sec)
% Deff = .402;							% Loudspeaker efficient diameter (meters)  
% Seff = pi*(Deff/2.0)^2;				    % Loudspekaer efficient area (m^2)
% Kmb = ((ro*c^2)*(Seff^2))/Vb;           % stiffness of test box

%localScaleK = 1/1000e4;
localScaleK = 1;
%extraGainK = 1/1000;

% note, 1/cm = 1.786e3, localScaleK purposely scale k0 to get closer

%k0 = (6.13*1000 + Kmb) *localScaleK;       % Enter Klippel N/mm * 1e3 (Kmb adds the test box stiffness)
k0 = 1/cm;
if Kcond == 1
    k1 = 0.0085281*1e6*localScaleK;         % Enter Klippel value * 1e6
    k2 = 0.022182*1e9*localScaleK;          % Enter Klippel value * 1e9
    k3 = 0.00021212*1e12*localScaleK;       % Enter Klippel value * 1e12
    k4 = 2.56E-05*1e15*localScaleK;         % Enter Klippel value * 1e15
    k5 = 0.0;                   % etc...
    k6 = 0.0;
    k7 = 0.0;
    k8 = 0.0;
else
    k1 = 0.0;
    k2 = 0.0;
    k3 = 0.0;
    k4 = 0.0;
    k5 = 0.0;
    k6 = 0.0;
    k7 = 0.0;
    k8 = 0.0;
end
%[Kdxx] = [0 0 0 0 k4 k3 k2 k1 k0]; 
Kdxx = [k0 k1 k2 k3 k4];


%%

 % Voice coil inductance (Assumes Henries):						
		% L0 = 1.6736*1e-3;           % Enter Klippel value mH * 1e-3
        l0 = Le*1;                % (rab) millihenries! 
	if Lcond == 1
		l1 = 0.011653;              % Enter Klippel value as is
		l2 = 0.0032495*1e3;         % Enter Klippel value * 1e3
		l3 = -4.49E-05*1e6;         % Enter Klippel value * 1e6
		l4 = -6.06E-06*1e9;         % etc...
		l5 = 1.13E-07*1e12;
		l6 = 9.90E-09*1e15;
		l7 = -1.53E-10*1e18;
		l8 = -1.01E-11*1e21;
    else  
     	l1 = 0.0;
		l2 = 0.0;
		l3 = 0.0;
		l4 = 0.0;
		l5 = 0.0;
		l6 = 0.0;
		l7 = 0.0;
		l8 = 0.0;
    end
%[Ldxx] = [0 0 0 0 l4 l3 l2 l1 l0]; 
Ldxx = [l0 l1 l2 l3 l4];

