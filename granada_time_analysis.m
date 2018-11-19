% Show variation in spectra across time/elavation in Granada dataset


clear, clc, close all

load('C:\Users\cege-user\Dropbox\UCL\Data\Reference Data\Granada Data\Granada_daylight_2600_161.mat');
% http://colorimaginglab.ugr.es/pages/Data#__doku_granada_daylight_spectral_database
% From: J. Hernández-Andrés, J. Romero& R.L. Lee, Jr., "Colorimetric and
%       spectroradiometric characteristics of narrow-field-of-view
%       clear skylight in Granada, Spain" (2001)
T_SPD=final; clear final
S_SPD=[300,5,161];

% Additional SPD info (source: personal correspondance with J. Hernández-Andrés)
[addI.NUM,addI.TXT,addI.RAW] = xlsread('C:\Users\cege-user\Dropbox\UCL\Data\Reference Data\Granada Data\add_info.xlsx');
for i=1:length(T_SPD) %a lot of stupid code just to get the date and time out
    addI.t(i) = datetime(...
        [char(addI.RAW(2,2)),' ',char(days(cell2mat(addI.RAW(2,3))),'hh:mm')],...
        'InputFormat','dd/MM/uuuu HH:mm');
end
% addI.el = addI.NUM(:,4); %elevation
% addI.az = addI.NUM(:,5); %azimuth

figure,
plot(SToWls(S_SPD),T_SPD) %all spd
ylim([0 max(T_SPD(:))]); yticks([0,1,2]);
xlabel('Wavelength'); ylabel('Power');

%% Pull data into bins depending on time

nb = 15; % number of bins
bnd = addI.NUM(:,4);%binning data
bnd(bnd == 0) = NaN;
bins = linspace(min(bnd),max(bnd),nb+1);

for i = 1:nb
    bd(i).data = T_SPD(:,and(bnd>bins(i),bnd<bins(i+1))); %binned data
    bd(i).av = mean(bd(i).data,2);
end

%% Plot binned data

cols = jet(nb-1);

%Not normalised
figure, hold on
legend
for i=1:nb-1
    plot(SToWls(S_SPD),bd(i).av,'Color',cols(i,:),'DisplayName',[num2str(bins(i),2),' to ',num2str(bins(i+1),2)])
end

%Normalised (to max value)
figure, hold on
legend
for i=1:nb-1
    plot(SToWls(S_SPD),bd(i).av/max(bd(i).av),'Color',cols(i,:),'DisplayName',[num2str(bins(i),2),' to ',num2str(bins(i+1),2)])
end