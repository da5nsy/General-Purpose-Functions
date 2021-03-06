%% Prepare for Newastle presentation
% Make graphs from Granada data for presentation at Newcastle University on
% 2018/03/21
% ppt archived here: https://doi.org/10.6084/m9.figshare.6007658.v2

%Requires:
%psychtoolbox
%spectral_color_1

% Pre
clear, clc, close all

nmlz=0;%[1,560]; %normalisation. if nmlz ==0, no nmlz, else, nmlz == normalisation value and point (nm)
gif=0;  %if gif == 0, no gif, else, gif is made and saved
ETR=0;  %Include extra-terrestrial radiation?
    ETR_Smooth = 0; %Smooth ETR data to look like Granada data?
PCA=1; %Plot principle components

% Load data

load T_xyz1964

load('Granada_daylight_2600_161.mat');
% From: http://colorimaginglab.ugr.es/pages/data/Granada_daylight_2600_161
% Info: http://colorimaginglab.ugr.es/pages/Data#__doku_granada_daylight_spectral_database
% Ref:  J. Hern�ndez-Andr�s, J. Romero, J.L. Nieves & R.L. Lee, Jr., "Color and spectral analysis of daylight in southern Europe", Journal of the Optical Society of America A, Vol. 18, N. 6, pp. 1325-1335, June 2001
data=final; clear final;
lambda=300:5:1100;

if nmlz; ETR = 0; end %hard-coded, don't show ETR if data is normalised
if ETR
    ETR_data=xlsread('C:\Users\cege-user\Dropbox\UCL\Reference Data\ASTMG173.xls', 'SMARTS2','A3:B2004');
    ETR_lambda = ETR_data(:,1);
    ETR_data=ETR_data(:,2);    
    if ETR_Smooth        
        ETR_data=interp1(ETR_lambda,ETR_data,lambda(1):lambda(end),'spline'); %interpolates to single wavelength intervals
        ETR_5=movmean(ETR_data,5); %smooths the data by a moving mean of 5
        ETR_data=interp1(lambda(1):lambda(end),ETR_5,lambda); %interpolates back to lambda to match granada data
    else
        ETR_data=interp1(ETR_lambda,ETR_data,lambda,'spline');
    end
end

% Normalise data at 555nm

if nmlz
    for i=1:2600
        %data(:,i)=data(:,i)/data((norm(2)-1)*5+300,i)*norm(1);
        data(:,i)=data(:,i)/data((nmlz(2)-300)/5+1,i)*nmlz(1);
    end
end

% Plot data
%clc

%figure, plot(lambda,data); ylim([0 2.2]) %all data

fig=figure('Position',[200,100,950,500], 'color', 'white'); 
ax=axes; hold on
xlabel('Wavelength (nm)')
ylabel('Spectral Irradiance (W m^{-2} nm^{-1})')
if nmlz
    ylabel('Relative SPD'); 
elseif PCA
    ylabel('PCA coefficient')
end
% Units taken from http://colorimaginglab.ugr.es/pages/images/database/daylight/!

if ETR; plot(ax,lambda,ETR_data,'r','LineWidth',1);end
xlim([300 1100])
ylim([0 2.5])

if PCA ~= 1 %If we're not plotting PCA
    plot(lambda,data(:,100),'k','LineWidth',1);
elseif PCA == 1
    [coeff,score,latent,tsquared,explained] = pca(data(11:81,:)'); %lambda(11:81) == 350:5:700
    
    linetype={'k-','k--','k:'};
    for i=2:3
        %plot(lambda(11:81),coeff(:,i),linetype{i},'LineWidth',1)
        plot(lambda(11:81),coeff(:,i)*explained(i),linetype{i},'LineWidth',1)
        %ylim([-.3 .3])
        ylim([-.02 .02])
        %plot([300,1100],[0,0])
    end
end


xh = get(ax,'xlabel');      % handle to the label object
px = get(xh,'position');    % get the current position property
px(2) = 2.5*px(2);          % multiply the distance
set(xh,'position',px);      % set the new position

yh = get(ax,'ylabel');
py = get(yh,'position');
py(1) = 0.92*py(1);
set(yh,'position',py);

a2=get(ax,'position');
set(ax,'position',[0.1300 0.200 0.7750 0.750]);

%spectrumLabel(ax); 

%-% The following is taken from: https://uk.mathworks.com/matlabcentral/fileexchange/7021-spectral-and-xyz-color-functions 
% and modified because the original messes up the x-axis tick labels when
% used as above

%hFig = ancestor(ax, 'figure');

% Add a new axes to the same figure as the target axes.
%figure(hFig);
hAxesSpectrum = axes;
%set(hAxesSpectrum, 'visible', 'off')

% Position the axes as appropriate.
targetPosition = get(ax, 'position');
spectrumPosition = [targetPosition(1), ...
                    targetPosition(2), targetPosition(3), 1];
set(hAxesSpectrum, 'position', spectrumPosition)
set(hAxesSpectrum, 'units', 'pixels')

spectrumPosition = get(hAxesSpectrum, 'position');
set(hAxesSpectrum, 'position', [spectrumPosition(1), ...
                                spectrumPosition(2) - 20, ...
                                spectrumPosition(3), ...
                                20])

% I swapped the two below sections around and it seemed to sort of solve
% the problem, so it must be something to do with createSpectrum adding
% it's own axes, but not sure exactly what.
                            
[lambda_cbar, RGB] = createSpectrum('1964_full');
axes(hAxesSpectrum);
image(lambda_cbar, 1:size(RGB,1), RGB);

% Line the X limits of the two axes up and display the spectrum.
t1=get(ax, 'XTick');
set(hAxesSpectrum, 'Xlim', get(ax,'Xlim'));
set(hAxesSpectrum, 'XTick', t1 )


% Added the below here (as opposed to earlier in the function) as a quick fix to the white areas made when rescaling the axes
% I suspect the real fix would be to go into 'creaeteSpectrum and work out
% why it is controlling the axis  

% Areas outside the visible spectrum are black.
set(hAxesSpectrum, 'color', [0 0 0])

% Turn off the unneeded axes labels.
set(ax, 'XTick', []);
set(hAxesSpectrum, 'YTick', []);

% Make the figure visible.
set(hAxesSpectrum, 'units', 'normalized')
set(hAxesSpectrum, 'visible', 'on')

%-%


filename = sprintf('GranadaGif_%s.gif',datestr(now,'yymmddHHMMSS'));

% Gif
if gif
    for i=1:50:2500
        frame = getframe(1);
        im{i} = frame2im(frame);
        [A,map] = rgb2ind(im{i},256);
        if i == 1
            imwrite(A(20:end-20,20:end-20),map,filename,'gif','LoopCount',0,'DelayTime',0);
        else
            imwrite(A(20:end-20,20:end-20),map,filename,'gif','WriteMode','append','DelayTime',0);
        end
        plot(ax,lambda,data(:,i),'k','LineWidth',1);
        drawnow
    end
end




%%

%This messes up the axis labels and I haven't had chance to work out why 

% Plot reflectance
cla(ax)
load sur_vrhel
ylabel(ax,'Spectral Reflectance Function')
ylim(ax,[0 1])

plot(ax,SToWls(S_vrhel),sur_vrhel(:,90),'k')

%Plot CIE 1931
load('T_cones_ss10')
cla(ax)
%figure,
hold on
plot(ax,SToWls(S_cones_ss10),T_cones_ss10(1,:),'k')
%plot(ax,SToWls(S_cones_ss10),T_cones_ss10(1,:),'r')
%plot(ax,SToWls(S_cones_ss10),T_cones_ss10(2,:),'g')
%plot(ax,SToWls(S_cones_ss10),T_cones_ss10(3,:),'b')


%% Make basic 3D plot
clear, clc, close all

fig=figure;
fig.Color=[1,1,1];

x=[0,0,0;0,0,1];
y=[0,0,0;0,1,0];
z=[0,0,0;1,0,0];

plot3(x,y,z,'k','LineWidth',5);
view(3)
grid on

% xlabel('1. Cloudiness')
% ylabel('3. Elevation and water content')
% zlabel('2. Sky vs. Sun')

ax=gca;
ax.XTick=[0,1];
ax.YTick=[0,1];
ax.ZTick=[0,1];

view(25,32)