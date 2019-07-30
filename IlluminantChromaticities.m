clear, clc, close all

% Wrote script to check out whether some illuminant chromaticities I was seeing were realistic
% Loads the granada daylight data and some artifical illuminants
% Calculates and plots chromaticities in CIE u'v' space

%% Load data

% Load obs
load T_xyz1931.mat

% Load Granada
load('C:\Users\cege-user\Dropbox\UCL\Data\Reference Data\Granada Data\Granada_daylight_2600_161.mat');
spd_gran = final; clear final
S_gran = [300,5,161];

%interp
spd_gran = SplineSpd(S_gran,spd_gran,S_xyz1931);
S_gran = S_xyz1931;

% Load Houser measured SPDs
load spd_houser.mat

%% Compute colorimetry

uv_gran   = XYZTouv(T_xyz1931*spd_gran);
uv_houser = XYZTouv(T_xyz1931*spd_houser);

%% Compute and plot spectral locus

figure, hold on

uvbar = XYZTouv(T_xyz1931);
ubar = uvbar(1,:);
vbar = uvbar(2,:);

sRGB_dcs = XYZToSRGBPrimary(T_xyz1931);
sRGB_dcs(sRGB_dcs>1) = 1;
sRGB_dcs(sRGB_dcs<0) = 0;
for i=1:3
    for j=1:size(sRGB_dcs,2)-1
        t(i,j) = (sRGB_dcs(i,j)+sRGB_dcs(i,j+1))/2;
    end    
end
sRGB_dcs = t;

for i = 1:size(T_xyz1931,2)-1
    plot([ubar(i),ubar(i+1)],[vbar(i),vbar(i+1)],'Color',sRGB_dcs(:,i));
end
plt(1) = plot([ubar(i),ubar(i+1)],[vbar(i),vbar(i+1)],'Color',sRGB_dcs(:,i),'DisplayName','Spectral Locus'); %Repeat just for legened

axis equal
xlim([0 0.65])
ylim([0 0.65])

% slightly different from loading from :
%ciefile = fullfile('C:','Users','cege-user','Dropbox','UCL','Data',...
%    'Colour Standards','CIE colorimetric data','CIE_colorimetric_tables.xls');
% which is curious but for another day.

%%
p(1) = scatter(uv_houser(1,:),uv_houser(2,:),'filled','MarkerFaceAlpha',0.2,'DisplayName','Houser SPDs');
p(2) = scatter(uv_gran(1,:),uv_gran(2,:),'filled','MarkerFaceAlpha',0.2,'DisplayName','Granada Daylight');

legend(p,'Location','best')

cleanTicks

%% Add sRGB gamut

sRGB_R_xy = [0.6400,0.3300];
sRGB_G_xy = [0.3000,0.6000];
sRGB_B_xy = [0.1500,0.0600];

sRGB_R_uv = xyTouv(sRGB_R_xy'); %Uses PsychToolbox function
sRGB_G_uv = xyTouv(sRGB_G_xy');
sRGB_B_uv = xyTouv(sRGB_B_xy');

% scatter(sRGB_R_uv(1),sRGB_R_uv(2),'r*');
% scatter(sRGB_G_uv(1),sRGB_G_uv(2),'g*');
% scatter(sRGB_B_uv(1),sRGB_B_uv(2),'b*');

plt(3) = plot([sRGB_R_uv(1),sRGB_G_uv(1)],[sRGB_R_uv(2),sRGB_G_uv(2)],'k:','DisplayName','sRGB Gamut');
legend('Autoupdate','off')
plot([sRGB_G_uv(1),sRGB_B_uv(1)],[sRGB_G_uv(2),sRGB_B_uv(2)],'k:')
plot([sRGB_B_uv(1),sRGB_R_uv(1)],[sRGB_B_uv(2),sRGB_R_uv(2)],'k:')


