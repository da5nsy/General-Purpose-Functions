function [ pursuitOnset regX regY slope intercept] = detectPursuit( time, dx )
%DETECTPURSUIT Determines pursuit onset on single velocity trace
%
% input
%   time: time in seconds
%   dx:   velocity vector
% output
%   pursuitOnset: Sample of detected onset
%   regX:         x-values of final regression line
%   regY:         y-values of final regression line
%   slope:        slope of final regression line
%   intercept:    intercept of final regression line
   
PLOT_MOVIE = 0;

%% Parameters
sample_freq = 1/mean(diff(time));          %Determine sampling frequency
motionOnset = find(time==0);               %Motion onset at time zero
LATENCY_MIN = round(0.05*sample_freq);     %Min pursuit latency
LATENCY_MAX = round(0.4*sample_freq);      %Max pursuit latency
REG_INT = round(0.08 * sample_freq);       %Length of the regression interval
SLOPE_MIN = 10.0;                          %Min slope of the regression
SLOPE_MAX = 200.0;                         %Max slope of the regression
R_CRIT = 0.7;                              %Min R² of regression

%% Preparation
reg_low = motionOnset + LATENCY_MIN;
reg_high = motionOnset + LATENCY_MAX;
len = LATENCY_MAX - LATENCY_MIN;

slope = zeros(len,1);
intercept = zeros(len,1);
rsq = zeros(len,1);

pursuitOnset = NaN;
regX = NaN;
regY = NaN;

%---------------- MOVIE
if PLOT_MOVIE
    f=1;
    hf = figure;
    set(hf,'Units','Centimeters','Position',[2 2 15 15]);
    plot(time,dx,'k');
    xlim([time(motionOnset) time(motionOnset+LATENCY_MAX+REG_INT)]);
    xlabel('Time from motion onset[s]');
    ylabel('X-Velocity [°/s]');
    set(gca,'XTick',[time(motionOnset):0.05:time(motionOnset+LATENCY_MAX+REG_INT)],'XTickLabel',[0:0.05:1.10]);
    axis square;
    hold all
    mov(f) = getframe(hf);
    f=f+1;
end
%---------------- MOVIE

%% Calculate Regressions
for j=reg_low:1:reg_high
    start = j;
    stop = start + REG_INT;
    [b,bint,r,rint,stats] = regress(dx(start:stop),[ones(REG_INT + 1,1) time(start:stop)]);
    slope(j) = b(2);
    intercept(j) = b(1);
    rsq(j) = stats(1);
    %---------------- MOVIE
    if PLOT_MOVIE
        regX = time(start:stop);
        regY = intercept(j) + slope(j) * regX;
        if (slope(j) > SLOPE_MIN) && (slope(j) < SLOPE_MAX)
            h(j) = plot(regX,regY,'c--');

        else
            h(j) = plot(regX,regY,'r--');
        end
        mov(f) = getframe(hf);
        f=f+1;
    end
    %---------------- MOVIE
end


%% select best regression
%---------------- MOVIE
if PLOT_MOVIE
    for j=reg_low:1:reg_high
        if (slope(j) < SLOPE_MIN) || (slope(j) > SLOPE_MAX)
            delete(h(j));
        end
    end
    mov(f) = getframe(hf);
    f=f+1;
    for j=1:20
        mov(f)=getframe(hf);
        f=f+1;
    end
    index = 1:reg_high; index=index';
    temp=cat(2,rsq,index);
    temp=sortrows(temp,1);
    for i=1:length(temp(:,1))
        j=temp(i,2);
        if j >= reg_low
            if (slope(j) > SLOPE_MIN) && (slope(j) < SLOPE_MAX)
                delete(h(j));
                mov(f)=getframe(hf);
                f=f+1;
            end
        end
    end
    %        for j=reg_low:reg_high
    %            if (slope(j) > SLOPE_MIN) && (slope(j) < SLOPE_MAX)
    %                delete(h(j));
    %            end
    %        end
end
%---------------- MOVIE

slope_min = find(slope > SLOPE_MIN);
slope_max = find(slope < SLOPE_MAX);
valid_slopes = intersect(slope_min, slope_max);
if ~isempty(valid_slopes)
    rsq = rsq(valid_slopes);
    [rmax rimax] = max(rsq);
    if rmax > R_CRIT
        start = valid_slopes(rimax);
        stop = start + REG_INT;
        pursuitOnset = round((-intercept(start)) / slope(start) * sample_freq)+motionOnset;
        regX = time(start:stop);
        regY = intercept(start) + slope(start) * regX;
        slope = slope(start);
        intercept = intercept(start);
        %---------------- MOVIE
        if PLOT_MOVIE
            plot([time(motionOnset) time(motionOnset+LATENCY_MAX+REG_INT)],[0 0],'g--');
            plot(regX,regY,'g--');
            plot(time(pursuitOnset),dx(pursuitOnset),'go');
            mov(f) = getframe(hf);
            f=f+1;            
        end
        %---------------- MOVIE
    else
        slope = NaN;
        intercept = NaN;
    end
else
    slope = NaN;
    intercept = NaN;
end
latency = (pursuitOnset-motionOnset)*(1/sample_freq);
fprintf('PursuitOnset: latency: %.2f;\tslope: %.2f;\tintercept: %.2f;\tR²: %.2f\n',latency,slope,intercept,rmax);

