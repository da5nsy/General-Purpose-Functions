% Do natural surfaces spread more in BY axis?
% Following Jenny Bosten talk at AVA Xmas 2018

clear, clc

%Vrhel reflectances
load sur_vrhel_withLabels.mat %DG PTB mod (https://github.com/da5nsy/Melanopsin_Computational/blob/0f854262aaf4ef703c41b711bf374ed044673c8d/sur_vrhel_withLabels.mat)
%load sur_vrhel.mat %standard PTB

%CIE 1931 2deg
load T_xyz1931.mat

%%

%interpolate to match interval and range
sur_vrhel_i = SplineSrf(S_vrhel,sur_vrhel,S_xyz1931);

%calculate XYZ
XYZ = T_xyz1931*sur_vrhel_i;
XYZ_nat = XYZ(:,[labels_vrhel.nat]);

%%

plotChromaticity
hold on

scatter(XYZ(1,:)./sum(XYZ),XYZ(2,:)./sum(XYZ),'k.')

%just natural 
scatter(XYZ_nat(1,:)./sum(XYZ_nat),XYZ_nat(2,:)./sum(XYZ_nat),'g.')

%would be nice to pick out skin/hair as this is probably overly represented
%here, but this isn't working currently:

% for i = 1:size(sur_vrhel,2)
%     t_label = string(labels_vrhel(i).label);
%     if strcmp(labels_vrhel(i).label{1:4},'skin') || strcmp(labels_vrhel(i).label(1:4),'skin') || strcmp(labels_vrhel(i).label(1:4),'skin') 
%         disp(label(i).label)
%     end
% end

%% Conclusion

% There is a greater spread in this dataset, but not so much for natural
% objects.
% I should probably do this in MB space.