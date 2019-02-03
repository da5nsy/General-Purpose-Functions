% Recreate the spectrum locus and equal energy white shown in Figure 8.2
% of CIE 170-2:2015. Also performs a regression check.

% CIE 170-2:2015: 0.699237
% ss10, cie10:    0.699236717675886
% sf:             0.699236682265373

% CIE 170-2:2015: 0.025841
% ss10, cie10:    0.025841849094742
% sf:             0.025841849365799

%%
clc, clear, close all

%figure, hold on

for i=1:10
    
    load T_cones_ss10
    load T_CIE_Y10.mat
    S_out = [S_cones_ss10(1),i,floor(S_cones_ss10(3)/i)];
    T_cones_ss10 = SplineCmf(S_cones_ss10,T_cones_ss10,S_out);
    T_CIE_Y10    = SplineCmf(S_CIE_Y10,T_CIE_Y10,S_out);
    
    LMSEEWhite(i,:) = sum(T_cones_ss10,2);
    
    %plot(SToWls(S_out),T_cones_ss10)
end

lsEEWhite  = LMSToMacBoyn(LMSEEWhite',T_cones_ss10,T_CIE_Y10);

%%

figure,
plot(lsEEWhite(1,:))

figure,
plot(lsEEWhite(2,:))

%%

load T_cones_ss2
load T_CIE_Y2
lsSpectrumLocus = LMSToMacBoyn(T_cones_ss2,T_cones_ss2,T_CIE_Y2);

min_l_scale = 0.62;
max_l_scale = 0.82;
max_s_scale = 0.04;

figure, hold on
xlim([min_l_scale max_l_scale])
ylim([0,max_s_scale])
plot(lsSpectrumLocus(1,:)',lsSpectrumLocus(2,:)','r','LineWidth',3)
comet(lsEEWhite(1,:),lsEEWhite(2,:))


