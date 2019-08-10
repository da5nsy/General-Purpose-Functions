% Checking the invertability of CATs

clear, clc, close all

%%

load spd_D65.mat

load sur_macbeth.mat
sur_macbeth = sur_macbeth(:,12);

load T_xyz1931.mat

M = [0.7328,0.4296,-0.1624;
    -0.7036,1.6975,0.0061;
    0.0030,0.0136,0.9834];

%% 

col_sig = spd_D65.*sur_macbeth;
figure, hold on
plot(SToWls(S_D65),col_sig)
plot(SToWls(S_xyz1931),T_xyz1931)

%%

col_sig'*(M*T_xyz1931)'
(M*(col_sig'*T_xyz1931')')'



