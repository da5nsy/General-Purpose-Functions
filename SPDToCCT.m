function CCT = SPDToCCT(SPD,S_SPD)

% % Generate SPD(s) for testing purposes
% clc, clear, close all
% 
% % single SPD 
% S_SPD = [380,5,81];
% SPD = GenerateBlackBody(9999,SToWls(S_SPD));
% 
% % multiple SPDs
% load spd_houser.mat
% SPD = spd_houser;
% S_SPD = S_houser;

%% Calculate colorimetry

load T_xyz1931.mat T_xyz1931 S_xyz1931

if S_xyz1931 ~= S_SPD
    T_xyz1931 = SplineCmf(S_xyz1931,T_xyz1931,S_SPD); %set to same wavelength range and sampling interval
    S_xyz1931 = S_SPD;
end

SPD_XYZ = T_xyz1931*SPD;
SPD_uv = XYZTouv(SPD_XYZ,'Compute1960');

%% Calculate look ups

S = [380,5,81];
range = 1000:10000;
lookup_uv = zeros(2,length(range));
for i=1:length(range)
    lookup_uv(:,i) = XYZTouv(T_xyz1931*GenerateBlackBody(range(i),SToWls(S)),'Compute1960');
end

%% Find closest

for i=1:size(SPD,2)
    [~,minloc(i)] = min(sqrt(sum((lookup_uv - SPD_uv(:,i)).^2)));
    CCT(i) = range(minloc(i));
end

if any(CCT == range(1) | CCT == range(end))
    warning(['You have found the boundary of the searched for CCT. Current range is ',num2str(range(1)),'K:',num2str(range(end)),'K'])
end
