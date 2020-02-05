
clc, clear, close all

%% Copunctal Points

% https://www.color-blindness.com/2009/01/19/colorblind-colors-of-confusion/
% Wyszecki & Stiles, Color Science (2nd ed.), 1982, Table 1 (5.14.2) p. 464

% Protan 	0.747 	0.253
% Deutan 	1.080 	-0.800
% Tritan 	0.171 	0.000

%%

CP = [0.747, 0.253];

DrawChromaticity
scatter(CP(1),CP(2),'k*');
axis tight

%%

interval = 10; %degrees interval for confusion lines
degs = 90:interval:360;
H = 1; %hypotenuse (line length)

for i = 1:length(degs)
    O = sind(degs(i))*H;
    A = cosd(degs(i))*H;
    line(:,1,i) = linspace(CP(1),CP(1)+O,100);
    line(:,2,i) = linspace(CP(2),CP(1)+A,100);
    plot(line(:,1,i),line(:,2,i),'k')
    drawnow
end

% something is weird...
