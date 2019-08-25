% Black body radiator curve plotter

clear, clc, close all

d = DGdisplaydefaults;
drawChromaticity('1931')
hold on
cleanTicks

BB_SPD = GenerateBlackBody(1000:10:10000,SToWls([380,5,81]));

load T_xyz1931.mat T_xyz1931 S_xyz1931

BB_XYZ = T_xyz1931*BB_SPD;
BB_xyY = XYZToxyY(BB_XYZ);

plot(BB_xyY(1,:),BB_xyY(2,:),'k')
scatter(BB_xyY(1,[1,551,end]),BB_xyY(2,[1,551,end]),'k','filled')

text(BB_xyY(1,1)-0.17,BB_xyY(2,1),'1000K')
text(BB_xyY(1,551)-0.17,BB_xyY(2,551),'6500K')
text(BB_xyY(1,end)-0.17,BB_xyY(2,end)-0.02,'10000K')


%%
save2pdf