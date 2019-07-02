clear, clc, close all

load T_xyz1931.mat T_xyz1931 S_xyz1931

figure, hold on
plot(SToWls(S_xyz1931),T_xyz1931./max(T_xyz1931,[],2))

ax = gca; ax.ColorOrderIndex = 1; %resets colour order so that colours correspond

%%

M_BFD = [0.8951,0.2664,-0.1614;-0.7502,1.7135,0.0367;0.0389,-0.0685,1.0296];

T_BFD = M_BFD*T_xyz1931;

plot(SToWls(S_xyz1931),T_BFD./max(T_BFD,[],2),'--');