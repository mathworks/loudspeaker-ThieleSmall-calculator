% Name: init_speaker_st_nl_cloud
% This script initializes the parameters for all the parameters needed to simulate the loudspeaker. 

% Copyright © 2020-2025 The MathWorks, Inc.  

%function [state, Blxx, Ldxx, Kdxx, NFFT, bw, fs] = init_speaker_st_nl_cload()

%%
% Params needed for the transfer function measurements

bw = 10000;                 % used by transfer function block
fs = bw*2.56;               % used by the sampler inside the transfer func block

fs = 48000;                 %  used in calc_impedance
bw = fs/2.5;

NFFT = 2048;                 % used by transfer function block
xdata = (0:NFFT/2)/NFFT*fs;  % used by transfer function block to display 

frameSize = 480;            % this is used in calc_impedance, 10ms
hilbertDelay = 1000;        % this is used in calc_impedance, delay through hilbert filter

%%
% This script would initialize the electrical and the mechanical parameters

%[state, Blxx, Ldxx, Kdxx, NFFT, bw] = init_speaker_st();
init_speaker_st;    
%%
% speaker box params

vol_driver = 0;  % assume 0 for now.

rho = 1.2041;   % density of air, 1.2041 kg/m^3  at 20 Celcius, 1.1839 at 25 
c = 343.21;     % speed of sound 343.21 m/s at 20 Celcius, 346.13 at 25
gamma = 1.4;    % for air for adiabatic compressions
P0 = 1e5;       % atmospheric pressure in Pa
% Vab = 1; % volume in cubie meters
% omega = 2.0 *pi; % 4 pi for infinite space, 2 pi for half-space 
state.rho = rho;
state.c = c;
state.gamma = gamma;
state.P0 = P0;

cone_diameter = 128; % eg cone diameter 148mm r = 0.074

pressure_eff = 1;   % pressure efficacy, 75
r = cone_diameter/1000/2;     % eg cone diameter 148mm r = 0.074
S = pi * r*r * pressure_eff; % area of cone

state.mech.or = r;
state.mech.ir = 0;

pressure_factor = S;
state.box.pressure_factor = S;
state.box.pressure_eff = pressure_eff;

%%
% calculate the Thiele-Small values based on init_speaker_st and
% state.mech.or

state = updateTSparam(state);

%% rear speaker, box Inductance M_ad
%boxDepth = 0.3;
%boxFaceArea = (10*2.54/100)^2; % 8 inch square
%vol = boxDepth * boxFaceArea;   % volumne of speaker box
lx = 8*2.54/100; % 8 inch square
ly = 8*2.54/100;
Sm = lx * ly;  % box back dimension
boxFaceArea = Sm;

state.Qtc = 0.7;  % assume this value for now
state.box.vratio = 3; % Va / Vm

%liningPercentage = 0.2;     % 0.2 of vol is lining
% vol_lin = liningPercentage * vol;       % V_B, volume of lining
% vol_air = vol - vol_lin - vol_driver;  % V_A, volume of air in box

% getting beta curve, fig. 7.10
betax = [0.01 0.02 0.03 0.07 0.08 0.09 0.1  0.2  0.3  0.4  0.7  0.8  0.9  1];
betay = [0.76 0.73 0.70 0.64 0.62 0.60 0.59 0.5  0.44 0.39 0.3  0.29 0.29 0.3];
betacurve = polyfit(betax, betay, 6);
beta = polyval(betacurve, S/boxFaceArea);
state.box.beta = beta;

state.box.Rf = 412*3;
state.box.mthick = 1; % match air, Rf*mthick/3 = rho*c
state.box.Sm = Sm;
[Cab, Rab, Mab, boxDepth, vol, Va, Vm, Vab, fc, Qmb ] = calBoxParam_state(state);

Qtc = calQtc_fromTSVabQmb(state, Vab, Qmb);
fc =  state.fs * Qtc / state.Qts;
state.Qtc = Qtc;
            
%state.box.rd = rd;
state.box.vol = vol;
state.box.Va = Va;
state.box.Vm = Vm;
state.fc = fc;
state.Qmb = Qmb;
state.box.rear_M = Mab;
state.box.rear_C = Cab;
state.box.rear_R = Rab;
state.box.boxDepth_Rmd = boxDepth;
state.box.boxDepth = boxDepth;
state.box.vol_Rmd = vol;
state.box.Va_Rmd = Va;
state.box.Vm_Rmd = Vm;
state.box.Vab = Vab;

state.box.numPorts = 0;
state.box.portRadius = 0.015;
state.box.portLen = 0.05;


% beware of normal mode occurs at half wavelength = boxDepth
firstModeFreq = c / (2* boxDepth);
state.box.firstModeFreq = firstModeFreq;

%% estimating the maximum displacment of the cone est_xmax
% this is mainly for sanity check

inputPower = 50; % 50W
Vab = Va + state.gamma*Vm;
Eg = sqrt(2 * state.elec.Re * inputPower); % v = sqrt( input power x R x 2)
est_xmax = EstXmax_fromTSEgVab(state, Eg, Vab);

Qtc = 0.7;
fc =  state.fs * Qtc / state.Qts;

state.fc = fc;
state.Qtc = Qtc;
state.est_xmax = est_xmax;
state.inputPower = inputPower;

%% front speaker load
% pg 333 , pg 315, fig 4.35 table 4.4, fig 4.39 table 4.5
% beware of a step discontinuity at ka = 1

state.box.front_R_max = 25000;  % max set to 25k ohm 

front_eval_freq = 40;
wavlen = c/front_eval_freq;
k = 2*pi/wavlen;

front_R = calFrontR_rVolF( state, r, vol, front_eval_freq);
front_M = calFrontM_rVolF( state, r, vol, front_eval_freq);

%state.box.alpha = alpha;
state.box.front_M = front_M;
state.box.wavNum = k;
state.box.front_R = front_R;

% box front using Beranek model
% Beranek pg 174, Ch. 4
state.Beranek.Ca = 5.94*S*S*S/(rho*c*c);
state.Beranek.Ma = 8*rho/(3*pi*pi*S);
state.Beranek.Ra1 = 0.1404*rho*c/(S*S);
state.Beranek.Ra2 = rho*c/(pi*S*S);

%% 
% create sine sweep signal
% input: fs_sineSweep, sineSignal, timePerSine, timeGapBetween 
%
% the sine sweep is a successive sine wave being used to test the
% loudspeaker. It is option 2 of the selectable input.

fs_sineSweep = 32000;   % sampling freq
sineSignal = [20 46 100 500 1000 2000 5000 10000];  % tone freqencies
timePerSine = 0.1;  % in seconds
timeGapBetween = 0.01;  % time between each tone

% 50W input
signalGain = sqrt(50*state.elec.Re)*sqrt(2);

gg =(0:1/fs_sineSweep:timeGapBetween -2/fs_sineSweep)*0;
ggt = 0:1/fs_sineSweep:timeGapBetween -2/fs_sineSweep;
xx = 0:1/fs_sineSweep:timePerSine;
ll = length(xx);
lenFreq = length(sineSignal);
%sinOut = zeros(length(xx)*lenFreq + length(gg)*(lenFreq),1);
sinOut = [];
tt = [];
tt0 = 0;
ff = []; 
for ii=1:lenFreq
   yy = sin(2*pi*sineSignal(ii)*xx)*signalGain;
   sinOut = [sinOut; yy'];
   tt = [tt; xx'+tt0];
   tt0 = tt(end) + 1/fs_sineSweep;
   ff0 = sineSignal(ii) * ones(ll,1);
   ff = [ff; ff0];
   if ii~= lenFreq
       sinOut = [sinOut; gg'];
       tt = [tt; ggt'+tt0];
       tt0 = tt(end) + 1/fs_sineSweep;  
       ff = [ff; gg'+sineSignal(1)];
   end
end

sineSweepTime = tt;
front_R_fidx = ff;
%front_R_fidx = calFrontR_rVolF( state, r, vol, ff);
% front_M = calFrontM_rVolF( state, r, vol, front_eval_freq);


%%
% Calculate a multitone signal for use in testing audio devices.
%
% This script generates (N+N_relax) samples of a multitone waveform. We 
% want to do a measurement with N cycles after the startup transient of the 
% DUT has been allowed to die out. We will measure and record the
% (N+N_relax) samples, then diosacrd the first N_relax samples. This 
% discards the startup transient. The final N samples are transformed to 
% the frequency domain as the "measured" response.
%
% The muti-tone signal is being used to test the
% loudspeaker. It is option 4 of the selectable input.


fs_mt = 48000; % sample rate
N  = 65536; % numeber of samples
df = fs_mt/N;
f  = 0:df:(N-1)*df; % frequency array
dt = 1/fs_mt;
T  = N*dt;
t  = 0:dt:(N-1)*dt;
t_relax = 0.1; %
N_relax = floor(t_relax/dt)+1;
t_long = 0:dt:(N+N_relax)*dt;

lowF = 20; % Use all freqs to this freq
NperOctave = 24; % Number of freqs per octave above lowF
maxF  = 20000; % max freq in source excitation, 5k
Nlow = length(find(f < lowF));

for ii = 1:4
    Nf = floor((log2(maxF)-log2(lowF))*NperOctave);
    indices = zeros(1,Nlow+Nf);
    indices(1:Nlow) = 1:Nlow;
    indices(Nlow:Nlow+Nf) = floor(logspace(log10(lowF),log10(maxF),Nf+1)/df);
    indices = unique(indices);
    Nf = length(indices);
    for jj = 1:Nf-2
        if(indices(jj+1)==indices(jj)+1 & indices(jj+2)==indices(jj)+2) 
            indices(jj+1)=indices(jj);
        end
    end
    indices = unique(indices);
    Nf = length(indices);
    lines = zeros(1,N);
    lines(indices) = 1;
    lines = lines .* exp(1i*(2*pi*rand(1,N) - pi));
    
    signal_i(ii,:) = ifft(lines,'symmetric')*N/2;
    %rms_i(ii) = sqrt(sumsqr(signal_i(ii,:))*2/N);
    rms_i(ii) = sqrt(sum((signal_i(ii,:)).^2)  *2/N);
    smax_i(ii) = max(signal_i(ii,:));
    cf_i(ii) = smax_i/rms_i;
end

[m,ii] = min(cf_i);
signal = signal_i(ii,:);
rms = rms_i(ii);
cf = cf_i(ii);
signal = signal/rms;
X = fft(signal)*2/N;
long_signal = [signal(1,N-N_relax:N) signal];

long_signal = long_signal';
t_long = t_long';
%plot(t_long, long_signal)

%%

chirpBegin = 10;        % chip signal used for testing would start at this value, it is also used in ramp display
chirpTarget = 1000;      % the chip signal used for testing would end at this value, it is also used in ramp display


