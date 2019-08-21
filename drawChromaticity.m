function drawChromaticity(type,lineOrDots)

% 20190810 Written by DG, off the back of the demos written for his thesis

load T_xyz1931 T_xyz1931 S_xyz1931  % CMF: 1931 2deg
sRGBSpectralLocus = XYZToSRGBPrimary(T_xyz1931);
sRGBSpectralLocus(sRGBSpectralLocus>1) = 1;
sRGBSpectralLocus(sRGBSpectralLocus<0) = 0;

if ~exist('type','var')
    type = '1931';
end

if ~exist('lineOrDots','var')
    lineOrDots = 'line';
end

if strcmp(lineOrDots,'line')
    for i=1:3
        for j=1:size(sRGBSpectralLocus,2)-1
            sRGBLine(i,j) = (sRGBSpectralLocus(i,j)+sRGBSpectralLocus(i,j+1))/2;
        end
    end
end

if strcmp(type,'1931')
    spectralLocusxy = [T_xyz1931(1,:)./sum(T_xyz1931);T_xyz1931(2,:)./sum(T_xyz1931)];
    if strcmp(lineOrDots,'dots')
        scatter(spectralLocusxy(1,1:70),spectralLocusxy(2,1:70),[],sRGBSpectralLocus(:,1:70)','filled')
    else
        for i = 1:70%size(sRGBSpectralLocus,2)-1 %curtailed to decrease the size of the black line area
            plot([spectralLocusxy(1,i),spectralLocusxy(1,i+1)],[spectralLocusxy(2,i),spectralLocusxy(2,i+1)],...
                'Color',sRGBLine(:,i),...
                'HandleVisibility','off'); % This means that it won't show up on legends
            hold on
        end
    end
    xlabel('x'), ylabel('y')
elseif strcmp(type,'upvp')
    spectralLocus_upvp = xyTouv([T_xyz1931(1,:)./sum(T_xyz1931);T_xyz1931(2,:)./sum(T_xyz1931)]);
    if strcmp(lineOrDots,'dots')
        scatter(spectralLocus_upvp(1,:),spectralLocus_upvp(2,:),[],sRGBSpectralLocus','filled')
    else
        for i = 1:70%size(sRGBSpectralLocus,2)-1
            plot([spectralLocus_upvp(1,i),spectralLocus_upvp(1,i+1)],[spectralLocus_upvp(2,i),spectralLocus_upvp(2,i+1)],'Color',sRGBLine(:,i),'HandleVisibility','off');
            hold on
        end
    end
    xlabel('u'''),ylabel('v''')
elseif strcmp(type,'MB2')
    load T_cones_ss2.mat T_cones_ss2 S_cones_ss2
    load T_CIE_Y2.mat T_CIE_Y2 S_CIE_Y2
    T_c = SplineCmf(S_cones_ss2,T_cones_ss2,S_xyz1931); %resampling so that I can use the old sRGBs that I already calculated, and keep the appearance comparable accross diagrams
    T_C = SplineCmf(S_CIE_Y2,T_CIE_Y2,S_xyz1931);
    spectralLocus_MB = LMSToMacBoyn(T_c,T_c,T_C);
    if strcmp(lineOrDots,'dots')
        scatter(spectralLocus_MB(1,:),spectralLocus_MB(2,:),[],sRGBSpectralLocus','filled')
    else
        for i = 1:size(sRGBSpectralLocus,2)-1
            plot([spectralLocus_MB(1,i),spectralLocus_MB(1,i+1)],[spectralLocus_MB(2,i),spectralLocus_MB(2,i+1)],'Color',sRGBLine(:,i),'HandleVisibility','off');
            hold on
        end
    end
    xlabel('{\itl}_{MB} (2deg)'),ylabel('{\its}_{MB} (2 deg)')
elseif strcmp(type,'MB10')
    load T_cones_ss10.mat T_cones_ss10 S_cones_ss10
    load T_CIE_Y10.mat T_CIE_Y10 S_CIE_Y10
    T_c = SplineCmf(S_cones_ss10,T_cones_ss10,S_xyz1931); %resampling so that I can use the old sRGBs that I already calculated, and keep the appearance comparable accross diagrams
    T_C = SplineCmf(S_CIE_Y10,T_CIE_Y10,S_xyz1931);
    spectralLocus_MB = LMSToMacBoyn(T_c,T_c,T_C);
    if strcmp(lineOrDots,'dots')
        scatter(spectralLocus_MB(1,:),spectralLocus_MB(2,:),[],sRGBSpectralLocus','filled')
    else
        for i = 1:size(sRGBSpectralLocus,2)-1
            plot([spectralLocus_MB(1,i),spectralLocus_MB(1,i+1)],[spectralLocus_MB(2,i),spectralLocus_MB(2,i+1)],'Color',sRGBLine(:,i),'HandleVisibility','off');
            hold on
        end
    end
    xlabel('{\itl}_{MB} (10deg)'),ylabel('{\its}_{MB} (10deg)')
else
    error('input not recognised')
end

if or(strcmp(type,'1931'),strcmp(type,'upvp'))
    axis equal
    axis([0 1 0 1])
    %xticks([0 1])
    %yticks([0 1])
elseif or(strcmp(type,'MB2'),strcmp(type,'MB10'))
    axis([0.5 1 0 1])
end

end