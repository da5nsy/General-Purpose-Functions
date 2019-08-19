% Transforming CIE 1931 into CIELAB at differing propertions of white
% reference. Note that a cone shape emerges.

clear, clc, close all

load T_xyz1931.mat T_xyz1931
SL_XYZ = T_xyz1931; %spectral locus XYZs

figure, hold on
for i = 1:5:50
    SL_Lab(:,:,i) = XYZToLab(SL_XYZ*i,[100,100,100]');
    plot3(SL_Lab(2,:,i),SL_Lab(3,:,i),SL_Lab(1,:,i))
end

view(3)

