clear, clc, close all

%% Load current PTB data

load T_xyz1931.mat

figure, hold on
plot(SToWls(S_xyz1931),T_xyz1931')

%% Load CVRL data

clear

%CVRL
A = readmatrix('C:\Users\cege-user\Downloads\ciexyz31_1.csv')';

S_xyz1931 = WlsToS(A(1,:)');
T_xyz1931 = A(2:4,:);

clear A

plot(SToWls(S_xyz1931),T_xyz1931')

%% Save new PTB

save T_xyz1931.mat
