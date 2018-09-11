function [ sacc ] = detectSaccade(time, x, dx, params)
%DETECTSACCADE Function to detection on- & offsets of saccades
% Calculates a moving average of eye velocity. If a consecutive row of samples exceeds the
% velocity criterion dx_crit relative to the value of the moving average, a
% saccade onset is detected. Saccade offset is detected when the eye
% velocity falls below dx_crit.
%
% input
%   time: time in seconds
%   x:    position vector  
%   dx:   velocity vector
% output
%   sacc: 1st column: saccade onset
%         2nd colum: saccade offset
           
PLOT_MOVIE = 0;

if nargin<4||isempty(params)
    params(1) = 0.05;
    params(2) = 0.005;
    params(3) = 0.3;
    params(4) = 25;
end

%% PARAMETERS                        
sample_freq = 1/mean(diff(time)); % determine sampling frequency
ws = round(params(1)*sample_freq);  % width of pre-saccade moving average
ps(1) = round(params(2)*sample_freq); % number of samples that have to exceed the criterion
ps(2) = round(params(2)*sample_freq); % number of samples that have to exceed the criterion
x_crit = params(3);                  % position cut-off
dx_crit = params(4);                  % velocity cut-off
pause_dur = 0.005;

%% Detection
s=1;
sacc=[];
i = ws+1;
while i<length(dx)-ps

    % calculate baseline velocity
    bl = mean(dx(i-ws:i-1));

    % calculate velocity difference to baseline
    crit = abs(dx(i:i+ps(1))-bl);
    if PLOT_MOVIE
        clf;
        plot(time,dx,'k-');
        hold all;
        plot(time(i-ws:i-1),dx(i-ws:i-1),'g-');
        plot(time(i:i+ps(1)),ones(ps(1)+1,1).*dx_crit+bl,'g-');
        plot(time(i:i+ps(1)),ones(ps(1)+1,1).*dx_crit.*-1+bl,'g-');
        xlim([time(i)-params(1).*5 time(i+ws*5)+params(1).*5]);
        ylim([-100 300]);
        xlabel('Time [s]');
        ylabel('Velocity [deg/s]');
        pause(pause_dur);
    end
    if isempty(find(crit<dx_crit))
        ONSET_SC_X=i;%-ps(1); % set onset of saccade
        if PLOT_MOVIE
            plot([time(ONSET_SC_X) time(ONSET_SC_X)],[-100 300],'r');
            %waitforbuttonpress;
            pause(pause_dur.*100);
        end
        while i<length(dx)-ps(2)
            i=i+1;

            % calculate velocity difference to baseline
            crit = abs(dx(i:i+ps(2))-bl);
            if PLOT_MOVIE
                clf;
                plot(time,dx,'k-');
                hold all;                
                plot(time(i:i+ps(1)),ones(ps(1)+1,1).*dx_crit+bl,'g-');
                plot(time(i:i+ps(1)),ones(ps(1)+1,1).*dx_crit.*-1+bl,'g-');
                plot([time(ONSET_SC_X) time(ONSET_SC_X)],[-100 300],'r');
                plot(time(i:i+ps(2)),ones(ps(2)+1,1).*dx_crit+bl,'g-');
                plot(time(i:i+ps(2)),ones(ps(2)+1,1).*dx_crit.*-1+bl,'g-');
                xlim([time(i)-params(1).*5 time(i)+params(1).*5]);
                ylim([-100 300]);                
                xlabel('Time [s]');
                ylabel('Velocity [deg/s]');
                pause(pause_dur);
            end
            if isempty(find(crit>dx_crit))
                % check position criterion
                %if abs(x(ONSET_SC_X)-x(i))>x_crit
                    if PLOT_MOVIE
                        plot([time(i) time(i)],[-100 300],'b');
                        %waitforbuttonpress;
                        pause(pause_dur.*100);
                    end
                    sacc(s,1) = ONSET_SC_X;
                    sacc(s,2) = i; % set offset of saccade
                    s=s+1;
                %end
                i=i+ws;
                break;
            end
        end
    end
    i=i+1;
end