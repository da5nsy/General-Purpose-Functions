% Is there a greater correlation between melanopic and photopic luminance
% for natural light sources than for artificial light sources?
% Colour? - less simple to test correlation


%% Load Data
clear, clc, close all

% Load artificial light sources (1nm data from IES TM-30-15 spreadsheet)
spd_data_filename='C:\Users\cege-user\Dropbox\UCL\Data\Colour standards\IES TM-30-15 Advanced CalculationTool v1.02.xlsm';
[d.num,d.txt,d.raw] = xlsread(spd_data_filename,'MultipleSPDCalc_5nm');
S_artificial = [380,5,81];

for i=1:size(d.num,2)-1
    %SPD:
    spd_data(i).spd =           d.num(5:end,i+1);
    
    %Additional data:
    spd_data(i).sourceType =    d.raw{4,i+1};
    spd_data(i).name =          d.raw{5,i+1};
    spd_data(i).category =      d.raw{6,i+1};
    %spd_data(i).Rf =            d.num(1,i+1);
    %spd_data(i).Rg =            d.num(2,i+1);
    spd_data(i).CCT =           d.num(3,i+1);
    
    % Only add 'Commercial' SPDs
    if strcmp(spd_data(i).category,'Commercial')
        if ~exist('T_artif','var') %declare this variable if it doesn't exist yet
            T_artif=spd_data(i).spd;
        else
            T_artif(:,end+1)=spd_data(i).spd;
        end        
    end
end

% Load Daylight Data
load('C:\Users\cege-user\Dropbox\UCL\Reference Data\Granada Data\Granada_daylight_2600_161.mat');
granada = final; clear final
% 300 - 1100nm, 5nm interval, unlabeled
% 2600 samples
T_day = granada(17:97,:); %match obs
S_day = [380,5,81];
% http://colorimaginglab.ugr.es/pages/Data#__doku_granada_daylight_spectral_database
% From: J. Hernández-Andrés, J. Romero& R.L. Lee, Jr., "Colorimetric and
%       spectroradiometric characteristics of narrow-field-of-view
%       clear skylight in Granada, Spain" (2001)


% Load data from:
% Royer, M., Wilkerson, A., Wei, M., Houser, K., Davis, R., 2016. 
% "Human perceptions of colour rendition vary with average fidelity, 
% average gamut, and gamut shape." Lighting Research & Technology 1–26. 
% https://doi.org/10.1177/1477153516663615
% (Supplemental data received from personal correspondance with first
% author)

data_filename='C:\Users\cege-user\Zotero\storage\FBA56DDB\Supplemental Data Summary.xlsx';
[e.num,e.txt,e.raw] = xlsread(data_filename,'Data');

T_e           = e.num(61:461,2:end); %no reason for 'e', it just followed 'd', for which I've forgotten the logic.
e_ratings     = e.num(1:3,2:end);
e_Rcs         = e.num(10:25,2:end);
e_Rf          = e.num(8,2:end);
S_e=[380,1,401];
%figure, plot(SToWls(S_e),T_e);

%% Load observer

% Obs data
load('T_cones_ss10')  % 10 deg obs
% load('T_cones_ss2') % 2 deg obs
load('T_melanopsin')

% figure, hold on
% for i=1:3
%     plot(SToWls(S_cones_ss10),T_cones_ss10(i,:))
% end
% legend

%% Calculate cone/mel values

% Calculate LMS of daylight samples
LMS_d(:,:)=SplineSpd(S_cones_ss10,T_cones_ss10',S_day)'*T_day;
LMS_a(:,:)=SplineSpd(S_cones_ss10,T_cones_ss10',S_day)'*T_artif;
LMS_e(:,:)=SplineSpd(S_cones_ss10,T_cones_ss10',S_e)'*T_e;

% Calulate M of daylight samples
Mel_d(:,:)=SplineSpd(S_melanopsin,T_melanopsin',S_day)'*T_day;
Mel_a(:,:)=SplineSpd(S_melanopsin,T_melanopsin',S_day)'*T_artif;
Mel_e(:,:)=SplineSpd(S_melanopsin,T_melanopsin',S_e)'*T_e;


%% Plot luminince comparison (L+M)

figure, hold on

P_d=(LMS_d(1,:)+LMS_d(2,:))/max(LMS_d(1,:)+LMS_d(2,:));
P_a=(LMS_a(1,:)+LMS_a(2,:))/max(LMS_a(1,:)+LMS_a(2,:));
P_e=(LMS_e(1,:)+LMS_e(2,:))/max(LMS_e(1,:)+LMS_e(2,:));
I_d=Mel_d/max(Mel_d);
I_a=Mel_a/max(Mel_a);
I_e=Mel_e/max(Mel_e);
% I_d=Mel_d/max(LMS_d(1,:)+LMS_d(2,:));
% I_a=Mel_a/max(LMS_a(1,:)+LMS_a(2,:));
% I_e=Mel_e/max(LMS_e(1,:)+LMS_e(2,:));

scatter(P_d,I_d,'r')
scatter(P_a,I_a,'b')
%scatter(P_e,I_e,'g')
scatter(P_e,I_e,((e_ratings(2,:)-min(e_ratings(2,:)))*10)+1,'g','filled')

% scatter(P_e,I_e,((e_ratings(1,:)-min(e_ratings(3,:)))*10)+1,'g','filled')
% scatter(P_e,I_e,((e_ratings(1,:)-min(e_ratings(3,:)))*10)+1,'g','filled')

xlabel('L+M')
ylabel('I (Mel)')

legend({'Daylight','Artificial','Royer'},'Location','Best')

% % To do list
% % ----------
% % - add a line of best fit
% % - add a r2 value for each line





% %% Plot individual cone channels
% figure,
% 
% i_idx={'L','M','S'};
% 
% N_d=(LMS_d'./repmat(max(LMS_d'),length(LMS_d),1))'; %normalise
% N_a=(LMS_a'./repmat(max(LMS_a'),length(LMS_a),1))';
% I_d=Mel_d/max(Mel_d);
% I_a=Mel_a/max(Mel_a);
% 
% % plot each cone pop in turn
% for i=1:3
%     subplot(1,3,i)
%     hold on
%     
%     scatter(N_d(i,:),I_d,'r.')
%     scatter(N_a(i,:),I_a,'b.')
%     
%     xlabel(i_idx{i})
%     if i==1
%         ylabel('I (Mel)')
%     end
% end
% 
% legend({'Daylight','Artificial'},'Location','Best')




% %% Scatter colour shifts vs each rating
% 
% for i=1:3
%     figure,
%     scatter(e_Rcs(end,:),e_ratings(i,:))
% end
% 
% % Scatter P/I ratio against ratings
% for i=1:3
%     figure,    
%     scatter(P_e./I_e,e_ratings(i,:))
% end






% %% Reproduce figure from Royer at al
% % numbers from Royer et al
% e_pred_pref = -0.041*(e_Rf)-9.99*(e_Rcs(16,:))-0.90*(e_Rcs(16,:).^2)+106.6*(e_Rcs(16,:).^3)+7.45;
% 
% figure, scatter(e_pred_pref,e_ratings(3,:),'k','filled')
% axis equal
% xlim([2,7])
% ylim([2,7])
% yticks([2:1:7])
% grid on
% hold on
% 
% plot([2,7],[2,7],'k')

%%
figure, scatter(P_e,I_e,((e_ratings(3,:)-min(e_ratings(3,:)))*10)+1)

%% - %% Previous version where I tried to use the IES TM-30-15 SPDs and github code from:
% https://github.com/jaakkopasanen/matlab-led-designer
%
%
%
% %% Load Data
% clear, clc, close all
%
% % Load artificial light sources (1nm data from IES TM-30-15 spreadsheet)
% spd_data_filename='C:\Users\cege-user\Dropbox\UCL\Data\Colour standards\IES TM-30-15 Advanced CalculationTool v1.02.xlsm';
% [d.num,d.txt,d.raw] = xlsread(spd_data_filename,'MultipleSPDCalc_5nm');
% S_artif = [380,5,81];
%
% for i=1:size(d.num,2)-1
%     %SPD:
%     spd_data(i).spd =           d.num(5:end,i+1);
%
%     %Additional data:
%     spd_data(i).sourceType =    d.raw{4,i+1};
%     spd_data(i).name =          d.raw{5,i+1};
%     spd_data(i).category =      d.raw{6,i+1};
%     %spd_data(i).Rf =            d.num(1,i+1);
%     %spd_data(i).Rg =            d.num(2,i+1);
%     spd_data(i).CCT =           d.num(3,i+1);
%
%     % Only add 'Commercial' SPDs
%     if strcmp(spd_data(i).category,'Commercial')
%         if ~exist('T_artif','var') %declare this variable if it doesn't exist yet
%             T_artif=spd_data(i).spd;
%             cct_all=spd_data(i).CCT;
%         else
%             T_artif(:,end+1)=spd_data(i).spd;
%             cct_all(:,end+1)=spd_data(i).CCT;
%         end
%     end
% end
%
% % Load observer
% load('T_cones_ss10')  % 10 deg obs
% load('T_melanopsin')
%
% % Calculate LMS of daylight samples
% LMS_a(:,:)=SplineSpd(S_cones_ss10,T_cones_ss10',S_artif)'*T_artif;
%
% % Calulate M of daylight samples
% Mel_a(:,:)=SplineSpd(S_melanopsin,T_melanopsin',S_artif)'*T_artif;
%
%
% %% Calculate IES TM-30-15 values
%
% for i=1:size(T_artif,2)
%     spd=T_artif(:,i);
%     cct=round(cct_all(i));
%     [ Rf(i), Rg(i), bins(:,:,i) ] = spdToRfRg(spd', cct);
% end
%
% bins=bins(1:16,:,:); %in function set 1 is duplicated as 17th for unknown reason
%
% %% Start the real stuff
% % Understand what the bins variable contains
% % Calculate
% % Plot the good variable against
%




