% Script to query the link between correlated colour temperature and damage factor

% SPD data from IES TM-30-15
% Source: https://ies.org/redirect/tm-30/

% Requires: 
% "psychtoolbox" for generating daylights and black body radiators (though
% there's a few of these already in the TM-30-15 dataset
% "extractfield" for pulling fields to plot (could do this with a loop)

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

%% Generate daylight and black body radiators

spec_Daylight_CCT = [5500,6500,7500];
load B_cieday
daylight_spd = GenerateCIEDay(spec_Daylight_CCT,[B_cieday]);

% figure, hold on
% plot(SToWls(S_cieday),daylight_spd);

spec_BBR_CCT=2500:500:7500;
for i=1:length(spec_BBR_CCT)
BBR_spd(:,i) = GenerateBlackBody(spec_BBR_CCT(i),380:5:780);
end

% figure, hold on
% plot(380:5:780,BBR_spd);

%UV filtering
daylight_spd(1:4,:) = 0;
BBR_spd(1:4,:) = 0;

% figure, hold on
% plot(SToWls(S_cieday),daylight_spd);
% 
% figure, hold on
% plot(380:5:780,BBR_spd);

%% Calculate DI

% "CIE 157:2004 Control of damage to museum objects by optical radiation"
b = 0.0115;
S_dm_rel = exp(-b*(spd_lambda-300)); % eq 2.5:
%figure, plot(spd_lambda,S_dm_rel);

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

load T_xyz1964 %2 degree observer
v=T_xyz1964(2,:);
%figure, plot(SToWls(S_xyz1964),v_lamda);

% figure(1); hold on, title('Original Data');
% figure(2); hold on, title('Normalised Data');
% figure(3); hold on, title('UV cut');
% figure(4); hold on, title('Damage Factors (indicated by line width)');

AN = 7.2; %Arbitrary Normalization value
% This is set to roughly match the values quoted in CIE 2004. Any
% significance of this value is not known.

for i=1:318
    
    % Normalise for same photopic value
    Ts=sum(spd_data(i).spd.*v');
    spd_data(i).spd_norm=AN/Ts*spd_data(i).spd;
    
 
    % Calculate DI (damage factor)
    spd_data(i).DI=S_dm_rel'*spd_data(i).spd_norm;
    
    %figure(1); plot(spd_lambda,spd_data(i).spd)
    %figure(2); plot(spd_lambda,spd_data(i).spd_norm)
    %figure(3); plot(spd_lambda,spd_data(i).spd_norm_uv)
    %figure(4); plot(spd_lambda,spd_data(i).spd_norm_uv,'k','LineWidth',spd_data(i).DI*2)
    
end

% Daylight
for i=1:size(daylight_spd,2)
    
    % Normalise for same photopic value
    Ts=sum(daylight_spd(:,i).*v');
    daylight_spd_norm(:,i)=AN/Ts*daylight_spd(:,i);
    
    % Calculate DI (damage factor)
    daylight_spd_DI(i)=S_dm_rel'*daylight_spd_norm(:,i);
    
end

% figure; plot(daylight_spd)
% figure; plot(daylight_spd_norm)

% BBR
for i=1:size(BBR_spd,2)
    
    % Normalise for same photopic value
    Ts=sum(BBR_spd(:,i).*v');
    BBR_spd_norm(:,i)=AN/Ts*BBR_spd(:,i);
    
    % Calculate DI (damage factor)
    BBR_spd_DI(i)=S_dm_rel'*BBR_spd_norm(:,i);
    
end

% figure; plot(BBR_spd)
% figure; plot(BBR_spd_norm)

%% Plot all

figure, hold on
t_CCT=extractfield(spd_data,'CCT');
t_DI=extractfield(spd_data,'DI');
scatter(t_CCT,t_DI,'k','filled','MarkerFaceAlpha',.2, 'DisplayName','All sources');

%Plot everything
% scatter(spec_Daylight_CCT,daylight_spd_DI,'r','filled','MarkerFaceAlpha',.5);
% scatter(spec_BBR_CCT,BBR_spd_DI,'b','filled','MarkerFaceAlpha',.5);

xlabel('CCT')
ylabel('DI (arbitrarily scaled)')

c_choice={'Model','Commercial','Experimental','Theoretical',};
colours=jet(4);

for i=1:length(c_choice)
    chosen_category=c_choice{i};
    chosen_category_index=strcmp(extractfield(spd_data,'category'),chosen_category);
    scatter(t_CCT(chosen_category_index),t_DI(chosen_category_index),...
        [],colours(i,:),'filled','MarkerFaceAlpha',.5,...
        'DisplayName',chosen_category);
end
legend('Location','Best')

xlim([1000 9000]);
ylim([0.4 2.1]);

%% - %%

% If I were to calculate the CCTs fresh:
% https://uk.mathworks.com/matlabcentral/fileexchange/28185-pspectro--photometric-and-colorimetric-calculations

% or
% http://www.lrc.rpi.edu/programs/nlpip/lightinganswers/lightsources/appendixb1.asp
% http://www.lrc.rpi.edu/programs/nlpip/lightinganswers/lightsources/scripts/NLPIP_LightSourceColor_Script.m
