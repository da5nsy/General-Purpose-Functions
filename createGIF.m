function createGIF(fig,folder,filename)

drawnow % updates the figure
frame = getframe(fig); % grabs the frame
im = frame2im(frame); % pulls the frame into the image
[A,map] = rgb2ind(im,256); %converts RGB image to indexed image

% (It's possible that some of the above aren't required and removal may
% improve speed.)

%% Constructs gif

try
    % If it exists already, append
    imwrite(A,map,[folder,filename,'.gif'],'gif','WriteMode','append','DelayTime',0.001);
catch
    % If it doesn't exist yet, create it
    imwrite(A,map,[folder,filename,'.gif'],'gif','LoopCount',0,'DelayTime',0.001);
end

end
