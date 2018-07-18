% Messing around with Psychtoolbox LMSToMacBoyn
% C:\toolbox\Psychtoolbox\PsychColorimetric

%Get some random LMS (but same each time)
clc
try load LMS
catch
    LMS=rand(3,10);
    save('LMS')
end
LMS

% Scale LMS so that L+M = luminance
LMS = diag([0.6373 0.3924 1]')*LMS;

% Compute ls coordinates from LMS
n = size(LMS,2);
ls = zeros(2,n);
denom = [1 1 0]*LMS;
ls = LMS([1 3],:) ./ ([1 1]'*denom);