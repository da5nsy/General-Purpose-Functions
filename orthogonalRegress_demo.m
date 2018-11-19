clear, clc, close all

load melcomp_3_fullWorkspace.mat
clearvars -except i j LMSRI

ill = 1;
x = log10(LMSRI(i,:,ill));
y = log10(LMSRI(j,:,ill));

xvals = linspace(min(x),max(x));

mc1 = polyfit(x,y,1)
mc2 = flip([ones(1,120);x]'\y')'
mc3 = orthogonalRegress(x,y)

figure, hold on
axis image
scatter(x,y,'r.')
plot(xvals,xvals*mc1(1)+mc1(2),'r-')
%plot(xvals,xvals*mc2(1)+mc2(2),'--')
plot(xvals,xvals*mc3(1)+mc3(2),'k--')

legend('points','polyfit','mldivide','orthogonalRegress','Location','best')

%%

yvals = linspace(min(x),max(x));


mc1b = polyfit(y,x,1);
mc2b = flip([ones(1,120);y]'\x')';
mc3b = orthogonalRegress(y,x);

scatter(y,x,'g.')
plot(yvals,yvals*mc1b(1)+mc1b(2),'g-')
%plot(yvals,yvals*mc2b(1)+mc2b(2),'--')
plot(yvals,yvals*mc3b(1)+mc3b(2),'k--')

plot(xvals,xvals,'k.')

