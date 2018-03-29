% Calculate 2 degree and 10 degree chromaticities for TM30-15 Illuminants

clc, clear, close all

%% Load
TM3015SpreadsheetFilename = 'C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Archive\2017\IES TM-30-15 Advanced CalculationTool v1.01.xlsm';
SFR=xlsread(TM3015SpreadsheetFilename, 'CES1nm','B11:CV411');
S_SFR=[380,1,401];

load T_xyz1931
load T_xyz1964

load spd_D65

%% Calc colorimetry

%Interp - drop SFR from 1nm to 5nm
for i=1:size(SFR,2)
    SFR_int(:,i)=interp1(SToWls(S_SFR),SFR(:,i),SToWls(S_xyz1931),'spline');
end

Tristim31=T_xyz1931*SFR_int;
Tristim64=T_xyz1964*SFR_int;

C31=[Tristim31(1,:)./sum(Tristim31);Tristim31(2,:)./sum(Tristim31)];
C64=[Tristim64(1,:)./sum(Tristim64);Tristim64(2,:)./sum(Tristim64)];


%% Plot
plotChromaticity 
hold on

scatter(C31(1,:),C31(2,:),'r','filled')
scatter(C64(1,:),C64(2,:),'b','filled')
