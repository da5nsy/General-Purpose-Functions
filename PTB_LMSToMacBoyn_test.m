% The PTB function LMSToMacBoyn does not use the scaling factor for s
% values.

% % From CIE 170-2:2015, pg 12:
% % 
% % "The MacLeod–Boynton chromaticity diagram for 10° field size is shown in Figure 8.3. In
% % particular, Illuminant E (the equi-energetic spectrum) is represented at
% % (0,699 237; 0,025 841)."

%% Load observer
load T_cones_ss10.mat
T_cones = T_cones_ss10; clear T_cones_ss10

% Scaling factors from CIE 170-2:2015, pg 8.
sf_10 = [0.69283932, 0.34967567, 0.05547858]; %energy 10deg
T_lum = sf_10(1)*T_cones(1,:)+sf_10(2)*T_cones(2,:);

%% Define equi-energy illuminant

EE = ones(length(T_cones),1); % define equi-energy (EE) white
EE_LMS = T_cones*EE;

LMS = EE_LMS;


%% Scale LMS so that L+M = luminance
factors = (T_cones(1:2,:)'\T_lum');
LMS = diag([factors ; 1])*LMS;


%% Compute ls coordinates from LMS
n = size(LMS,2);
ls = zeros(2,n);
denom = [1 1 0]*LMS;
ls = LMS([1 3],:) ./ ([1 1]'*denom)

% l is correct but s is off by an order of magnitude

%% Calculates spectral locus co-ordinates

ls_spectral = LMSToMacBoyn(T_cones,T_cones,T_lum);

figure, hold on
scatter(ls_spectral(1,:),ls_spectral(2,:),'.') %spectral locus

scatter(ls(1),ls(2),'*') %EE white chromaticity

%% Plots correct chromaticity diagram

CIE170MBtest
