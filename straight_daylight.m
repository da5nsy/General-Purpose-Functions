%% Straight_daylight

% This script shows how real daylight measurements fall on roughly a
% straight line in chromaticity space.
% However, this is just one datatset, measured in one specific way in one
% specific location.
% The sun doesn't change temperature though, and the true influencers of
% chromatic variation of daylight is the relative contribution of scattered
% light and direct sunlight.
% I think there's a paper by Hernandez-Andres that considers modelling,
% and the Spitschan paper (10.1038/srep26756) might have something useful.
% See also 'cie investigation.m'

clear, clc, close all

%%
load T_xyz1931.mat
XYZ_cie = T_xyz1931;

figure, hold on
xy_cie = [XYZ_cie(1,:)./sum(XYZ_cie);XYZ_cie(2,:)./sum(XYZ_cie)];
scatter(xy_cie(1,:),xy_cie(2,:),'.')

%% Daylight data

% http://colorimaginglab.ugr.es/pages/Data#__doku_granada_daylight_spectral_database
% From: J. Hernández-Andrés, J. Romero& R.L. Lee, Jr., "Colorimetric and
%       spectroradiometric characteristics of narrow-field-of-view
%       clear skylight in Granada, Spain" (2001)

load('C:\Users\cege-user\Dropbox\UCL\Data\Reference Data\Granada Data\Granada_daylight_2600_161.mat');
T_SPD=final; clear final
T_SPD = T_SPD(17:97,:);
S_SPD=[380,5,81];

XYZ_spd = T_xyz1931*T_SPD;
xy_spd = [XYZ_spd(1,:)./sum(XYZ_spd);XYZ_spd(2,:)./sum(XYZ_spd)];

scatter(xy_spd(1,:),xy_spd(2,:),'.')

%%

load B_cieday.mat
T_d = GenerateCIEDay(2500:200:10000,B_cieday);

XYZ_d = T_xyz1931*T_d;
xy_d = [XYZ_d(1,:)./sum(XYZ_d);XYZ_d(2,:)./sum(XYZ_d)];

scatter(xy_d(1,:),xy_d(2,:),'k.')

%% uv scatter

uv_cie = XYZTouv(XYZ_cie);
uv_spd = XYZTouv(XYZ_spd);
uv_d = XYZTouv(XYZ_d);

figure, hold on

scatter(uv_cie(1,:),uv_cie(2,:),'.')
scatter(uv_spd(1,:),uv_spd(2,:),'.')
scatter(uv_d(1,:),uv_d(2,:),'.k')

xlim([0 0.6])
ylim([0 0.6])
axis square




