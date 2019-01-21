% Forked from https://github.com/spitschan/SilentSubstitutionToolbox/blob/4634f2964ae52ad2a1ad716ddbb227e5500f696f/Nomograms/ShiftNomogramTest.m
% Test to compare T_cones_ss10 with ComputeCIEConeFundamentals(S,10,32,3)

clear, clc, close all

%% Finally, let's see if we get the 10° Stockman-Sharpe fundamentals when we pass in the right parameters
S = [380 2 201]; 
wls = SToWls(S);
T_quantal_PTB = ComputeCIEConeFundamentals(S,10,32,3);
T_energy_PTB = EnergyToQuanta(S,T_quantal_PTB')';
load T_cones_ss10
T_cones_ss10_spline = SplineCmf(S_cones_ss10,T_cones_ss10,S,2);
T_cones_ss10_spline_quantal = QuantaToEnergy(S,T_cones_ss10_spline')';

for ii = 1:3
    T_energyNormalized_PTB(ii, :) = T_energy_PTB(ii, :)/max(T_energy_PTB(ii, :));
    T_cones_ss10_spline(ii,:) = T_cones_ss10_spline(ii,:)/max(T_cones_ss10_spline(ii,:));
    T_cones_ss10_spline_quantal(ii,:) = T_cones_ss10_spline_quantal(ii,:)/max(T_cones_ss10_spline_quantal(ii,:));
end
figure;
hold on;
plot(wls, T_energyNormalized_PTB, '--b');
waitforbuttonpress
plot(SToWls(S_cones_ss10), T_cones_ss10, '--r');
waitforbuttonpress
plot(wls, T_cones_ss10_spline, '--g');
