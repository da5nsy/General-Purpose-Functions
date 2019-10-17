clear, clc, close all

%%

load T_xyz1931.mat

cie_xl = xlsread('C:\Users\cege-user\Downloads\204.xls','1931 col observer','B6:D86')';
S_cie_xl = WlsToS([380:5:780]');

%% 
%T_xyz1931 - cie_xl;

%% Plot T

T_x = T_xyz1931(1,:)./sum(T_xyz1931);
T_y = T_xyz1931(2,:)./sum(T_xyz1931);

figure, hold on
plot3(T_x,T_y,1:length(T_x),'DisplayName','PTB')

%% Plot CIE

CIE_x = cie_xl(1,:)./sum(cie_xl);
CIE_y = cie_xl(2,:)./sum(cie_xl);

plot3(CIE_x,CIE_y,1:length(T_x),'DisplayName','CIE')

%% view settings
daspect([1,1,80])
view(3)

legend
