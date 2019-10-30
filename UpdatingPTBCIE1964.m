clear, clc, close all

%% Load current PTB data

load T_xyz1964.mat

figure, hold on
plot(SToWls(S_xyz1964),T_xyz1964')

%% Load CVRL data

clear

%CVRL
A = readmatrix('C:\Users\cege-user\Downloads\ciexyz64_1.csv')';

S_xyz1964 = WlsToS(A(1,:)');
T_xyz1964 = A(2:4,:);

clear A

plot(SToWls(S_xyz1964),T_xyz1964')

%% Save new PTB

save T_xyz1964.mat
