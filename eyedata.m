function data = eyedata(n)

n=num2str(n);
data = dlmread(['C:\Users\cege-user\Desktop\eye_movements\eye_movements\',n,'.dat']);

% figure
% plot(data(:,2),data(:,3))
% axis equal

hold on
plot(data(:,1),data(:,2),'DisplayName','horizontal')
plot(data(:,1),data(:,3),'DisplayName','vertical')
legend

end



%%




