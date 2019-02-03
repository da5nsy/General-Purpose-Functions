%% Code to compare LMSToMacBoyn with LMSToMacBoynDG

% The difference between the two scripts is that the latter normalises the
% s values to a max of 1, as detailed in CIE 170-2:2015.
% The way that it is done should mean that it is generalisable to different
% cone fundamentals and luminance values (I think).

%%
clear, clc

%%
load T_cones_ss10.mat
T_cones = T_cones_ss10; clear T_cones_ss10

sf_10 = [0.69283932, 0.34967567, 0.05547858]; %energy 10deg
T_lum = sf_10(1)*T_cones(1,:)+sf_10(2)*T_cones(2,:);

%%

EE = ones(length(T_cones),1); % define equi-energy (EE) white
LMS = T_cones*EE;

%%

LMSToMacBoyn(LMS,T_cones,T_lum)
LMSToMacBoynDG(LMS,T_cones,T_lum)

%%

LMSbig = repmat(LMS,1,100);

LMSToMacBoyn(LMSbig,T_cones,T_lum)
LMSToMacBoynDG(LMSbig,T_cones,T_lum)

%%
LMSToMacBoyn(LMS)
LMSToMacBoynDG(LMS)

%% -- %%

clear, clc

% do it with ss10 to make sure I've understood the calculation correctly
load T_cones_ss10.mat
T_lum_ss10 = 0.69283932*T_cones_ss10(1,:)+0.34967567*T_cones_ss10(2,:); %figures from CIE 170-2
sf_ss10 = 1/max(T_cones_ss10(3,:)./T_lum_ss10); % should produce 0.05547858 (CIE 170-2), 4sf correct then diverges

% calculate the third sf for the sp fundamentals
load T_cones_sp.mat
T_lum_sp = 0.6373*T_cones_sp(1,:)+0.3924*T_cones_sp(2,:); %figures from LMSToMacBoyn.m
sf_sp = 1/max(T_cones_sp(3,:)./T_lum_sp);


%% -- %%

clear, clc

load T_cones_sp.mat

ls = LMSToMacBoyn(T_cones_sp);
lsDG = LMSToMacBoynDG(T_cones_sp);

figure,
scatter(ls(1,:),ls(2,:))

figure,
scatter(lsDG(1,:),lsDG(2,:))

%%

max(ls(2,:))

max(lsDG(2,:))
