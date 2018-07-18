% Investigation into CIE daylight basis functions

% They appear to be upsampled from 10nm data without note

% PTB B_cieday appears to be upsampled from 10nm interval data
%   S = [380,5,81] (780nm)
% perhaps should be downsampled back to:   
%   S = [380,10,36] (780nm)
%
% files.cie.co.at/204.xls 
%   is specified at 5nm intervals
%   also appears to be upsampled from 10nm data
%   but has greater range: S = [300,5,107] (830nm)
%
% D. B. Judd et al., “Spectral Distribution of Typical Daylight as a Function of Correlated Color Temperature,” Journal of the Optical Society of America, vol. 54, no. 8, p. 1031, Aug. 1964.
%   is specified at 10nm intervals
%   S = [300,10,54] (830nm)
%
% Presumably there is an official CIE standard behind a paywall somewhere 
% which exmplains it all

% Recommendation: revert to Judd data

clear, clc

%% Show apparent upsampling
load B_cieday %PTB basis functions
figure, hold on
plot(SToWls(S_cieday),B_cieday,'rv') %Full plot
x=SToWls(S_cieday);
plot(x(1:2:end),B_cieday(1:2:end,:),'g^-','MarkerFaceColor','g') %only plot every second value

%% Show extension of range
figure, hold on
B_cieday_CIE = xlsread('C:\Users\cege-user\Dropbox\UCL\Data\Colour standards\CIE colorimetric data\CIE colorimetric data.xlsx','Daylight comp');
% (files.cie.co.at/204.xls)
S_cieday_CIE = [B_cieday_CIE(1,1),B_cieday_CIE(2,1)-B_cieday_CIE(1,1),length(B_cieday_CIE)];
B_cieday_CIE = B_cieday_CIE(:,2:4)';

plot(SToWls(S_cieday),B_cieday,'o','MarkerFaceColor','g')
plot(SToWls(S_cieday_CIE),B_cieday_CIE,'o')
