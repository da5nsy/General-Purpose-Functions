figure, hold on

for i=1:5
    subplot(5,1,i)
    eyedata(i);
end

%%
clc
close all
data = eyedata(3);
 
% plot(data(:,1),data(:,4),'DisplayName','horizontal')
% plot(data(:,1),data(:,5),'DisplayName','vertical')

figure, hold on
vel=diff(data(:,2));
% plot(vel,'DisplayName','horizontal')
% legend

windowSize = 10; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

vel_smooth = filter(b,a,vel);
plot(vel_smooth,'DisplayName','horizontal')
% figure, hold on
% plot(diff(data(:,3)),'DisplayName','vertical')
% legend

%%

sac = detectSaccade(data(:,1),data(:,2),vel*2000);

plot([sac(1),sac(1)],[min(ylim),max(ylim)],'k');
plot([sac(2),sac(2)],[min(ylim),max(ylim)],'k');



