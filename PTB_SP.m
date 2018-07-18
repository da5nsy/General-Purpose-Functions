% Investigating PTB Smith-Pokorny data
clear, clc

% 1: SP as it exists in PTB
load T_cones_sp.mat

% 2: SP derived from Judd/Vos, as instructed on CVRL
load T_xyzJuddVos
T_sp_jv(1,:) = (...
    + 0.15514*(T_xyzJuddVos(1,:))...
    + 0.54312*(T_xyzJuddVos(2,:))...
    - 0.03286*(T_xyzJuddVos(3,:)));

T_sp_jv(2,:) = (...
    - 0.15514*(T_xyzJuddVos(1,:))...
    + 0.45684*(T_xyzJuddVos(2,:))...
    + 0.03286*(T_xyzJuddVos(3,:)));

% Scaling of the S cones is theoretically arbitrary:

% CVRL:
% T_sp_jv(3,:) = (...
%     + 0.00801*(T_xyzJuddVos(3,:)));

% Mac & Boyn 1978:
T_sp_jv(3,:) = (...
    + 0.01608*(T_xyzJuddVos(3,:)));


T_sp_jv=(T_sp_jv'/diag([max(T_sp_jv')]))';

% 3: SP from CVRL
T_sp_CVRL = csvread('C:\Users\cege-user\Dropbox\Documents\MATLAB\General Purpose Functions\sp.csv');
%Make non-log, and normalise to peak 1
T_sp_CVRL(:,2:4)=(10.^(T_sp_CVRL(:,2:4)))./max(10.^(T_sp_CVRL(:,2:4))); 
%Get wavlength range, and put in psychtoolbox format
S_sp_CVRL=[T_sp_CVRL(1,1),T_sp_CVRL(2,1)-T_sp_CVRL(1,1),length(T_sp_CVRL)]; 
T_sp_CVRL=T_sp_CVRL(:,2:4)'; %Remove wavelength range


%%

figure, hold on

plot(SToWls(S_cones_sp),T_cones_sp,'ro-','DisplayName','PTB');
plot(SToWls(S_xyzJuddVos),T_sp_jv,'go--','DisplayName','Computed from Judd/Vos');
plot(SToWls(S_sp_CVRL),T_sp_CVRL,'bo:','DisplayName','CVRL');

legend

%% Investigate differences

d = T_sp_CVRL(:,1:81)-T_sp_jv; %calculate differences over comparable range

figure, hold on,
for i=1:3
    plot(SToWls(S_cones_sp), d(i,:))
end

% I don't know what level is important...

%%
% Conclusion:
%  - Either Judd/Vos or CVRL are better than current PTB (they don't drop to
%    zero below 400 and above 700)
%  - Judd/Vos and CVRL seem to be ever so slightly different
%  - CVRL has a larger range (380:825) and all is non-zero
%  - However, CVRL data does have to go through 'un-logging' and
%    normalisation in order to be used, and this could plausibly introduce
%    artefacts, and so maybe the more direct derivation from JuddVos is
%    preferable.
    

