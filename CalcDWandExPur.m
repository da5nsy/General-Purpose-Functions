function [dominantWavelength,purity] = CalcDWandExPur(xy,xy_white)

% Calculate Excitation Purity
%
% As per:
% Schanda, J., 2015. CIE Chromaticity Diagrams, CIE Purity, CIE Dominant Wavelength. In: R. Luo, ed. Encyclopedia of Color Science and Technology. [online] Berlin, Heidelberg: Springer Berlin Heidelberg.pp.1–6. Available at: <http://link.springer.com/10.1007/978-3-642-27851-8_325-1> [Accessed 19 Nov. 2019].

clear, clc, close all

% TO DO
% Test:
% - using single xy and xy_white
% - using multiple values of xy and single value of xy_white
% - using multiple values of xy and multiple value of xy_white
% - write error for if there's multiple xy_white and only one xy
% - rotate data to suit (?)

%% Load CIE data

if ~exist('xy','var')
    xy = [0.30;0.33];
    disp('Bugtesting mode')
end

if ~exist('xy_white','var')
    xy_white = [0.31271;0.32902];
    disp('Using default white point (D65)')
end
    
    
load T_xyz1931.mat T_xyz1931 S_xyz1931
SL = [T_xyz1931(1,:)./sum(T_xyz1931);T_xyz1931(2,:)./sum(T_xyz1931)];

figure, hold on
plot(SL(1,:),SL(2,:),'k','HandleVisibility','off')
axis equal
scatter(xy_white(1,:),xy_white(2,:),'k*','DisplayName','White')
scatter(xy(1,:),xy(2,:),'r*','DisplayName','Surface')
legend('AutoUpdate','off')

%%

m = (xy_white(2,:)-xy(2,:))./(xy_white(1,:)-xy(1,:));
c = xy(2,:) - (m.*xy(1,:));

xlen = cosd(atand(m(1)))*0.8849;
incr = xlen/1000;
if xy_white(1) < xy(1)
    x = xy_white(1):incr:xy_white(1) + xlen;
else
    x = xy_white(1):-incr:xy_white(1) - xlen;
end
y = m(1).*x + c(1);

plot(x,y,'k.')

%%

for k = 1 : size(x,2)
  distances = sqrt((SL(1,:)-x(1,k)).^2 + (SL(2,:)-y(1,k)).^2);
  [minDistance(k), indexOfMin(k)] = min(distances);
end
[minDistanceTop, indexOfMinTop] = min(minDistance);

figure, plot(minDistance)
figure, plot(indexOfMin)

wl = SToWls(S_xyz1931);
dominantWavelength = wl(indexOfMin(indexOfMinTop));

disp(dominantWavelength)

%% Working out the grestest distance between points on a 1931 diagram

% for k = 1 : size(SL,2)
%   distances = sqrt((SL(1,:)-SL(1,k)).^2 + (SL(2,:)-SL(2,k)).^2);
%   [maxDistance(k), indexOfMax(k)] = max(distances);
%   % %Creates a nice visualisation of furthest away points
%   %plot([SL(1,k),SL(1,indexOfMax(k))],[SL(2,k),SL(2,indexOfMax(k))])
%   %pause(0.1)
% end
%
% max(maxDistance)


end