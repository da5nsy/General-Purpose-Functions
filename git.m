function git(message)

% Git upload

%cd('C:\Users\cege-user\Dropbox\Documents\MATLAB\SAPS')
cd('C:\Users\cege-user\Dropbox\Documents\MATLAB\General Purpose Functions')
%cd('C:\Users\cege-user\Dropbox\Documents\MATLAB\Melanopsin_Computational')


%!git add SAPS_DataAnalysis.m
!git add -A 
system(strcat('git commit -m "',message,'"')); %system is just the same as the ! used in other lines, but this way I get to add the message from the function
!git push

end

