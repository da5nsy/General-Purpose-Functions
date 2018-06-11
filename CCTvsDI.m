% Script to query the link between correlated colour temperature and damage factor

% SPD data from IES TM-30-15
% Source: https://ies.org/redirect/tm-30/

% ... which itself references:
% http://dx.doi.org/10.1364/OE.21.010393

% Requires: 
% "psychtoolbox" for observers and App 2
% "extractfield" for pulling fields to plot (could alternatively do this with a loop)

%% Load Light Sources

clear, clc, close all

spd_data_filename='C:\Users\cege-user\Dropbox\UCL\Data\Colour standards\IES TM-30-15 Advanced CalculationTool v1.02.xlsm';
[d.num,d.txt,d.raw] = xlsread(spd_data_filename,'MultipleSPDCalc_5nm'); %alternative: 'MultipleSPDCalc_1nm' #untested

for i=1:318
    %SPD:
    spd_data(i).spd =           d.num(5:end,i+1);
    
    %Additional data:
    spd_data(i).sourceType =    d.raw{4,i+1};
    spd_data(i).name =          d.raw{5,i+1};
    spd_data(i).category =      d.raw{6,i+1};
    spd_data(i).Rf =            d.num(1,i+1);  
    spd_data(i).Rg =            d.num(2,i+1);    
    spd_data(i).CCT =           d.num(3,i+1);
    
    % UV cut
    spd_data(i).spd(1:4)=0;
end

spd_lambda = d.num(5:end,1);

% figure, hold on
% for i=1:318
%     plot(spd_lambda,spd_data(i).spd)
% end

%% Calculate DI

% "CIE 157:2004 Control of damage to museum objects by optical radiation"
b = 0.0115;
S_dm_rel = exp(-b*(spd_lambda-300)); % eq 2.5:
%figure, plot(spd_lambda,S_dm_rel);         %Lin-lin axes
%figure, semilogy(spd_lambda,S_dm_rel);     %Lin-log axes

% % %-% Padfield terminology:
% %
% % http://research.ng-london.org.uk/scientific/spd/?page=info#Relative_Spectral_Sensitivity
% % Following:
% % 2: S. Aydinli, E. Krochmann, G.S. Hilbert, J. Krochmann: On the deterioration of exhibited museum objects by optical radiation, CIE Technical Collection 1990, CIE 089-1991, ISBN 978 3 900734 26 8
% %
% % b = 0.012;
% % a = 1/exp(-b*300);
% % S_dm_rel = a*exp(-b*spd_lambda);
% %
% % %-%

load T_xyz1964 %10 degree observer
v=T_xyz1964(2,:);
%figure, plot(SToWls(S_xyz1964),v);

ref_idx=76; % Which SPD to use as a reference? (Will be set to DI of 1)
ref_Ts=sum(spd_data(ref_idx).spd.*v');  % Compute photopic value for ref
ref_spd_norm=1/ref_Ts*spd_data(ref_idx).spd;  % Compute normalisation value
ref_DI=S_dm_rel'*ref_spd_norm;          % Compute ref DI (damage factor)
N = 1/ref_DI;                           % Normalization value

for i=1:318    
    % Normalise for same photopic value
    Ts=sum(spd_data(i).spd.*v');
    spd_data(i).spd_norm=N/Ts*spd_data(i).spd;    
 
    % Calculate DI (damage factor)
    spd_data(i).DI=S_dm_rel'*spd_data(i).spd_norm;
end

%% Plot all

figure, hold on
t_CCT=extractfield(spd_data,'CCT');
t_DI=extractfield(spd_data,'DI');
scatter(t_CCT,t_DI,'k','filled','MarkerFaceAlpha',.2, 'DisplayName','All sources');

%c_choice={'Model','Commercial','Experimental','Theoretical'};
c_choice={'Fluorescent Broadband','Fluorescent Narrowband','High Intensity Discharge','Incandescent/Filament','LED Hybrid','LED Mixed','LED Phosphor','Mathematical','Other'};
colours=jet(length(c_choice));

for i=1:length(c_choice)
    chosen_category=c_choice{i};
    %chosen_category_index=strcmp(extractfield(spd_data,'category'),chosen_category);
    chosen_category_index=strcmp(extractfield(spd_data,'sourceType'),chosen_category);
    scatter(t_CCT(chosen_category_index),t_DI(chosen_category_index),...
        [],colours(i,:),'filled','MarkerFaceAlpha',.5,...
        'DisplayName',chosen_category);
end

legend('Location','Best')

xlabel('CCT')
ylabel('DI (arbitrarily scaled)')

% xlim([1500 8500]);
% ylim([0.4 2.5]);

% Plot reference (point and line)
scatter(t_CCT(ref_idx),t_DI(ref_idx),'k','DisplayName',['Reference:',spd_data(ref_idx).name])
plot([1000,9000],[1,1],'k','DisplayName','Reference line')

%% Plot theoretical sources only (daylight and BBRs)

figure, hold on
for i=1:318
    if strcmp(spd_data(i).name(1:5),'CIE D')
        scatter(t_CCT(i),t_DI(i),[],colours(1,:),'filled');
        text(t_CCT(i),t_DI(i),['  ',spd_data(i).name([5,14,15])])
    elseif strcmp(spd_data(i).name(1:5),'Planc')
        scatter(t_CCT(i),t_DI(i),[],colours(end,:),'filled');
        text(t_CCT(i),t_DI(i),['  BBR:',spd_data(i).name(end-6:end)])
    end
end

xlabel('CCT')
ylabel('DI (arbitrarily scaled)')

xlim([1500 8500]);
ylim([0.4 2.5]);


%% Plot all, coloured for Rf

% split at 80 (green above, red below)
figure, hold on
t_CCT=extractfield(spd_data,'CCT');
t_DI=extractfield(spd_data,'DI');
t_Rf=extractfield(spd_data,'Rf');
t_Rf_idx=t_Rf<80;
scatter(t_CCT(t_Rf_idx),t_DI(t_Rf_idx),'r','filled');
scatter(t_CCT(~t_Rf_idx),t_DI(~t_Rf_idx),'g','filled');

xlabel('CCT')
ylabel('DI (arbitrarily scaled)')

legend({'Rf<80','Rf>80'})

% xlim([1000 9000]);
% ylim([0.4 2.1]);


% % graded by colour
% figure, hold on
% t_CCT=extractfield(spd_data,'CCT');
% t_DI=extractfield(spd_data,'DI');
% t_Rf=extractfield(spd_data,'Rf');
% scatter(t_CCT,t_DI,[],t_Rf,'filled');
% 
% xlabel('CCT')
% ylabel('DI (arbitrarily scaled)')
% 
% colorbar

%% - %% App 1

% If I were to calculate the CCTs fresh:

% https://uk.mathworks.com/matlabcentral/fileexchange/28185-pspectro--photometric-and-colorimetric-calculations

% or
% http://www.lrc.rpi.edu/programs/nlpip/lightinganswers/lightsources/appendixb1.asp
% http://www.lrc.rpi.edu/programs/nlpip/lightinganswers/lightsources/scripts/NLPIP_LightSourceColor_Script.m

%% - %% App 2

% Or create the BBR/D-series ills fresh:
 
% %% Generate daylight and black body radiators
% 
% spec_Daylight_CCT = [5500,6500,7500];
% load B_cieday
% daylight_spd = GenerateCIEDay(spec_Daylight_CCT,[B_cieday]);
% 
% % figure, hold on
% % plot(SToWls(S_cieday),daylight_spd);
% 
% spec_BBR_CCT=2500:500:7500;
% for i=1:length(spec_BBR_CCT)
% BBR_spd(:,i) = GenerateBlackBody(spec_BBR_CCT(i),380:5:780);
% end
% 
% % figure, hold on
% % plot(380:5:780,BBR_spd);
% 
% %UV filtering
% daylight_spd(1:4,:) = 0; %380:395 = 0; remove radiation below 400nm
% BBR_spd(1:4,:) = 0;
% 
% % figure, hold on
% % plot(SToWls(S_cieday),daylight_spd);
% % 
% % figure, hold on
% % plot(380:5:780,BBR_spd);

% - %
% % Normalisation
% 
% % Daylight
% for i=1:size(daylight_spd,2)
%     
%     % Normalise for same photopic value
%     Ts=sum(daylight_spd(:,i).*v');
%     daylight_spd_norm(:,i)=N/Ts*daylight_spd(:,i);
%     
%     % Calculate DI (damage factor)
%     daylight_spd_DI(i)=S_dm_rel'*daylight_spd_norm(:,i);
%     
% end
% 
% % figure; plot(daylight_spd)
% % figure; plot(daylight_spd_norm)
% 
% % BBR
% for i=1:size(BBR_spd,2)
%     
%     % Normalise for same photopic value
%     Ts=sum(BBR_spd(:,i).*v');
%     BBR_spd_norm(:,i)=N/Ts*BBR_spd(:,i);
%     
%     % Calculate DI (damage factor)
%     BBR_spd_DI(i)=S_dm_rel'*BBR_spd_norm(:,i);
%     
% end
% 
% % figure; plot(BBR_spd)
% % figure; plot(BBR_spd_norm)

% %Plot D series 
% scatter(spec_Daylight_CCT,daylight_spd_DI,'r','filled','MarkerFaceAlpha',.5);

% Plot black body radiators 
% scatter(spec_BBR_CCT,BBR_spd_DI,'b','filled','MarkerFaceAlpha',.5);
