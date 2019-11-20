% Plan:
% - Calculate dominant wavelengths (hues?) for surfaces under D65 in 1931.
% - Scatter either sMB (or similar), or abstract monotonic filter values, 
%   against dominant wavelength. Presumably fairly strong corrlation but 
%   not necessarily simple mapping. Might be specific areas where things fail.
% - Same again for purity - presumably much less successful.

clc, clear, close all

%% Data

load T_xyz1931.mat T_xyz1931 S_xyz1931
load spd_D65.mat spd_D65 S_D65
load sur_macbeth.mat sur_macbeth S_macbeth
%load sur_nickerson.mat sur_nickerson S_nickerson

figure, 
subplot(3,1,1)
plot(SToWls(S_xyz1931),T_xyz1931)
subplot(3,1,2)
plot(SToWls(S_D65),spd_D65)
subplot(3,1,3)
plot(SToWls(S_macbeth),sur_macbeth)
%plot(SToWls(S_nickerson),sur_nickerson)

%% Colorimetry

if ~isequal(S_xyz1931,S_D65)
    T_xyz1931 = SplineCmf(S_xyz1931,T_xyz1931,S_D65);
    S_xyz1931 = S_D65;
end

XYZ = T_xyz1931*(sur_macbeth.*spd_D65);
%XYZ = T_xyz1931*(sur_nickerson.*spd_D65);
xy = [XYZ(1,:)./sum(XYZ); XYZ(2,:)./sum(XYZ)];

XYZ_d65 = T_xyz1931*spd_D65;
xy_d65 = [XYZ_d65(1,:)./sum(XYZ_d65); XYZ_d65(2,:)./sum(XYZ_d65)];

figure,
DrawChromaticity
scatter(xy(1,:),xy(2,:),'k*');
scatter(xy_d65(1,:),xy_d65(2,:),'r*');

%% Calculate dominant wavelengths and purity

for i=1:size(sur_macbeth,2)
%for i=1:size(sur_nickerson,2)
    [dominantWavelength(i),exPurity(i)] = CalcDWandExPur(xy(:,i),xy_d65);
    close all
end

%% Plot against x

figure,

scatter(xy(1,:),dominantWavelength)







