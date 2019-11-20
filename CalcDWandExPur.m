function [dominantWavelength,exPurity] = CalcDWandExPur(xy,xy_white)

% Calculate Dominant Wavelength and Excitation Purity
%
% As per:
% Schanda, J., 2015. CIE Chromaticity Diagrams, CIE Purity, CIE Dominant Wavelength. In: R. Luo, ed. Encyclopedia of Color Science and Technology. [online] Berlin, Heidelberg: Springer Berlin Heidelberg.pp.1–6. Available at: <http://link.springer.com/10.1007/978-3-642-27851-8_325-1> [Accessed 19 Nov. 2019].

%clear, clc, close all

% TO DO
% - Purity for purples
% - Add option for where xy == xy_white
% - rotate data to suit (?)
% - What happens is x_white == x? Does it mess up the trig with
% infinity/divide by zero stuff?
% - Build in support for 1964
% - sub-nm precision?

%% Load CIE data

% if ~exist('xy','var')
%     xy = [0.5;0.4];
%     disp('Bugtesting mode')
% end
% 
% if ~exist('xy_white','var')
%     xy_white = [0.31271;0.32902];
%     disp('Using default white point (D65)')
% end
    
    
load T_xyz1931.mat T_xyz1931 S_xyz1931
SL = [T_xyz1931(1,:)./sum(T_xyz1931);T_xyz1931(2,:)./sum(T_xyz1931)];

figure, hold on
plot(SL(1,:),SL(2,:),'k.','HandleVisibility','off')
axis equal
scatter(xy_white(1),xy_white(2),'k*','DisplayName','White')
scatter(xy(1),xy(2),'r*','DisplayName','Surface')
legend('AutoUpdate','off')

%% Calculate equation of line that goes through xy_white and xy

m = (xy_white(2)-xy(2))/(xy_white(1)-xy(1));
c = xy(2) - (m*xy(1));

%% Generate line of fixed length

xlen = cosd(atand(m(1)))*0.8849; %0.8849 roughly equals the largest distance between arbitrary points in 1931 xy
incr = xlen/1000;
if xy_white(1) < xy(1) % make sure the line goes towards the spectral locus
    x = xy_white(1):incr:xy_white(1) + xlen;
else
    x = xy_white(1):-incr:xy_white(1) - xlen;
end
y = m(1).*x + c(1);

plot(x,y,'k.')

%% Find closest point on spectral locus (dominantWavelength)

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

%% Purple catch

if minDistanceTop > 0.0254/2
    % then repeat above but with line in opposite direction
    
    xlen = cosd(atand(m(1)))*0.8849;
    incr = xlen/1000;
    if xy_white(1) < xy(1)
        x = xy_white(1):-incr:xy_white(1) - xlen; %signs switched
    else
        x = xy_white(1):incr:xy_white(1) + xlen; %signs switched
    end
    y = m(1).*x + c(1);
    
    figure(1) %adds this back to the original figure
    plot(x,y,'k.')    
    
    for k = 1 : size(x,2)
        distances = sqrt((SL(1,:)-x(1,k)).^2 + (SL(2,:)-y(1,k)).^2);
        [minDistance(k), indexOfMin(k)] = min(distances);
    end
    [minDistanceTop, indexOfMinTop] = min(minDistance);
    
    figure, plot(minDistance)
    figure, plot(indexOfMin)
    
    wl = SToWls(S_xyz1931);
    dominantWavelength = -wl(indexOfMin(indexOfMinTop)); % provide negated dominantWavelength to denote complementary
    
    disp(dominantWavelength)
    if minDistanceTop > 0.0254/2
        % if the distance is still greater than half the distance between
        % adjacent points on the SL...
        error('something has gone wrong in purple land')
    end
end

%% Calculate Excitation Purity

NA = sqrt(((xy_white(1)-xy(1))^2) + ((xy_white(2)-xy(2))^2));% distance between white and sample

SLxyEst = [x(indexOfMinTop);y(indexOfMinTop)]; 
% point on spectral locus and line (not neccesarily coordinates of a specific point on SL)
% calculated this way (as opposed to using the coordinates for the closest point in the SL data)
% so that the lines are actually colinear, otherwise you could end up with some weird artefacts

ND = sqrt(((xy_white(1)-SLxyEst(1))^2) + ((xy_white(2)-SLxyEst(2))^2));% distance between white and point on spectral locus

exPurity = NA./ND;
disp(exPurity)


%% Working out the grestest distance between arbitrary points on a 1931 diagram
%
% for k = 1 : size(SL,2)
%   distances = sqrt((SL(1,:)-SL(1,k)).^2 + (SL(2,:)-SL(2,k)).^2);
%   [maxDistance(k), indexOfMax(k)] = max(distances);
%   % %Creates a nice visualisation of furthest away points
%   %plot([SL(1,k),SL(1,indexOfMax(k))],[SL(2,k),SL(2,indexOfMax(k))])
%   %pause(0.1)
% end
%
% max(maxDistance)

%% Working out the maximum distance between two points on the spectral locus
%
% for i=1:S_xyz1931(3)-1
%     t(i) = sqrt((SL(1,i)-SL(1,i+1)).^2 + (SL(2,i)-SL(2,i+1)).^2);
% end
% 
% figure, plot(SToWls(S_xyz1931),[t,t(end)])
% maxt = max(t);
% disp(maxt);


end