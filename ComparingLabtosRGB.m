clear, clc, close all

%%
% 
load spd_D65
% load sur_vrhel
load T_xyz1931
% 
S_out = [380,1,401];
% 
spd_D65 = SplineSpd(S_D65,spd_D65,S_out,1);
S_D65 = S_out;
% 
% sur_vrhel = SplineSrf(S_vrhel,sur_vrhel,S_out,1);
% S_vrhel = S_out;
% 
T_xyz1931 = SplineCmf(S_xyz1931,T_xyz1931,S_out,1);
S_xyz1931 = S_out;
% 
% colourSignals = sur_vrhel.*spd_D65;
norm = (T_xyz1931(2,:)*spd_D65)/100; % to normalise Y to 100 for white
XYZ_D65 = (T_xyz1931*spd_D65)/norm; % not exactly the same as listed online but it'll do for this
% XYZ = (T_xyz1931*colourSignals)/norm;
% 
% LAB = XYZToLab(XYZ,XYZ_D65);

%%

rng(42)
sz = [1,5000];
XYZ = [rand(sz)*100;rand(sz)*100;rand(sz)*100];

%% Prep values for plotting

xyY = XYZToxyY(XYZ);
DrawChromaticity
scatter3(xyY(1,:),xyY(2,:),xyY(3,:),'filled','k','MarkerFaceAlpha',0.2);
daspect([1,1,100])

%% LAB -> XYZ

% XYZ_PTB = LabToXYZ(LAB,XYZ_D65);
% XYZ_IMT = lab2xyz(LAB','WhitePoint',XYZ_D65'); %IMT for 'image toolbox'
% 
% devInd_XYZ = all(XYZ_PTB ~= XYZ_IMT');
% deviation_XYZ = max(abs(XYZ_PTB - XYZ_IMT'));
% fractionalDeviation_XYZ = deviation_XYZ/mean(abs(XYZ_PTB(:)));
% 
% figure,
% DrawChromaticity, hold on
% scatter3(xyY(1,:),xyY(2,:),xyY(3,:),'filled','k','MarkerFaceAlpha',0.1);
% scatter3(xyY(1,devInd_XYZ),xyY(2,devInd_XYZ),xyY(3,devInd_XYZ),...
%     [],fractionalDeviation_XYZ(devInd_XYZ),'filled')
% zlabel('Y')
% daspect([1,1,100])
% view(3)
% colormap('cool')
% cb = colorbar;
% ylabel(cb, 'fractionalDeviation\_XYZ')

% %% XYZ -> sRGBlin
% 
% sRGBlin_PTB = XYZToSRGBPrimary(XYZ);
% sRGBlin_IMT = xyz2rgb(XYZ','ColorSpace','linear-rgb');
% 
% devInd_sRGBlin = ~all(sRGBlin_PTB == sRGBlin_IMT');
% deviation_sRGBlin = max(abs(sRGBlin_PTB - sRGBlin_IMT'));
% fractionalDeviation_sRGBlin = deviation_sRGBlin/mean(abs(sRGBlin_PTB(:)));
% 
% figure,
% DrawChromaticity, hold on
% scatter3(xyY(1,:),xyY(2,:),xyY(3,:),'filled','k','MarkerFaceAlpha',0.1);
% scatter3(xyY(1,devInd_sRGBlin),xyY(2,devInd_sRGBlin),xyY(3,devInd_sRGBlin),...
%     [],fractionalDeviation_sRGBlin(devInd_sRGBlin),'filled')
% zlabel('Y')
% daspect([1,1,max(xyY(:))])
% view(0,0)
% colormap('cool')
% cb = colorbar;
% ylabel(cb, 'fractionalDeviation\_sRGBlin')
% 
% %% sRGBlin -> sRGB
% 
% sRGB_PTB = uint8(SRGBGammaCorrect(sRGBlin_PTB/100,0)'); % unclear where the factor of 100 comes from but it needs it...
% sRGB_IMT = lin2rgb(sRGBlin_PTB/100,'OutputType','uint8');
% 



sRGB_IMT = xyz2rgb(XYZ','WhitePoint','d65','OutputType','uint8');

sRGBlin = XYZToSRGBPrimary(XYZ);
sRGB_PTB = uint8(SRGBGammaCorrect(sRGBlin,0)');

devInd_sRGB = ~all(double(sRGB_PTB) == double(sRGB_IMT),2)'; %need some transposing for some reason
deviation_sRGB = max(abs(double(sRGB_PTB) - double(sRGB_IMT)),[],2);

figure,
DrawChromaticity, hold on
scatter3(xyY(1,:),xyY(2,:),xyY(3,:),'filled','k','MarkerFaceAlpha',0.1);
scatter3(xyY(1,devInd_sRGB),xyY(2,devInd_sRGB),xyY(3,devInd_sRGB),...
    [],deviation_sRGB(devInd_sRGB),'filled')
zlabel('Y')
daspect([1,1,max(xyY(:))])
colormap('cool')
cb = colorbar;
ylabel(cb, 'fractionalDeviation\_sRGB')

%% vis (for fun)

figure,
image(permute(sRGB_PTB,[1,3,2]))