% Messing around with Psychtoolbox LMSToMacBoyn
% C:\toolbox\Psychtoolbox\PsychColorimetric
clear, clc

%Get some random LMS (but same each time)
rng(1)
LMS=rand(3,10);

% Scale LMS so that L+M = luminance
% LMS = [1,1,1] would -> LMS = [0.6373 0.3924 1]
% 0.6373 0.3924 must be relative contributions to luminance (?)
% Renaming for clarity
LMS_d = diag([0.6373 0.3924 1]')*LMS;

% if (nargin == 1)
% 	LMS = diag([0.6373 0.3924 1]')*LMS;
% else
% 	factors = (T_cones(1:2,:)'\T_lum');
% 	LMS = diag([factors ; 1])*LMS;
% end

% Compute ls coordinates from LMS
ls = zeros(2,size(LMS_d,2)); %pre-allocate variable

denom = [1 1 0]*LMS_d; %L+M
ls = LMS_d([1 3],:) ./ ([1 1]'*denom);

%% A test to see - what are we calling luminance?
clear, clc

load T_cones_ss10
T_cones=T_cones_ss10;
T_lum=T_cones_ss10(1,:)+0.5*T_cones_ss10(2,:);

factors = (T_cones(1:2,:)'\T_lum')
diag([factors ; 1])

%% In PTB are all the sensitivities normalised?
clear, clc

load T_cones_ss2.mat
load T_cones_sp.mat

figure, hold on
plot(SToWls(S_cones_sp),T_cones_sp)
plot(SToWls(S_cones_ss2),T_cones_ss2)

% That's a yes Houston.