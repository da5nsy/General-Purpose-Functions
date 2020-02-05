function git(message)

% Git upload

if exist([cd,'\.git'], 'file') == 7
    !git pull
    disp('hit any key to continue with adding and pushing')
    pause
    !git add -A
    system(strcat('git commit -m "',message,'"')); %system is just the same as the ! used in other lines, but this way I get to add the message from the function
    !git push
    
else 
    disp('change cd to a folder with a .git')
end
    
    %cd('C:\Users\cege-user\Dropbox\Documents\MATLAB\SAPS')
    %cd('C:\Users\cege-user\Dropbox\Documents\MATLAB\BarrionuevoCao_Reproduction')
    %cd('C:\Users\cege-user\Dropbox\Documents\MATLAB\General Purpose Functions')
    %cd('C:\Users\cege-user\Dropbox\Documents\MATLAB\Melanopsin_Computational')   
    
    %!git add SAPS_DataAnalysis.m
    
    
end

