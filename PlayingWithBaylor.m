% Messing around with BaylorNomogram.
% I think that the description might have a typo - should call
% QuantaToEnergy rather than EnergyToQuanta but I don't know enough about
% it for now.

clear, clc, %close all

%load T_melanopsin.mat T_melanopsin S_melanopsin

% load T_cones_ss10.mat T_cones_ss10 S_cones_ss10
% T = T_cones_ss10;
% S = S_cones_ss10;

load T_cones_ss2.mat T_cones_ss2 S_cones_ss2
T = T_cones_ss2;
S = S_cones_ss2;

peakWls = FindCmfPeaks(S,T);

for i=1:size(T,1)
    %T_Baylor(:,i) = EnergyToQuanta(S,BaylorNomogram(S,peakWls(i))');
    T_Baylor(:,i) = BaylorNomogram(S,peakWls(i));
end

figure, hold on
plot(SToWls(S),T,'DisplayName','T')
ax = gca; ax.ColorOrderIndex = 1; %resets colour order so that colours correspond
plot(SToWls(S),T_Baylor./max(T_Baylor),'--','DisplayName','T\_baylor')

legend