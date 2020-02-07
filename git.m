function git(message)

% Adds, commits, pulls and pushes to github, in a neat wrapper.

if exist([cd,'\.git'], 'file') == 7
    !git add -A
    system(strcat('git commit -m "',message,'"')); %system is just the same as the ! used in other lines, but this way I get to add the message from the function
    disp('pulling')
    !git pull
    disp('hit any key to continue with adding and pushing')
    pause
    disp('pushing')
    !git push    
else
    disp('change cd to a folder with a .git')
end

end

