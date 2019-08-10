function drawChromaticity(type)

% 20190810 Written by DG, off the back of the demos written for his thesis

load T_xyz1931 T_xyz1931 S_xyz1931  % CMF: 1931 2deg 
sRGBSpectralLocus = XYZToSRGBPrimary(T_xyz1931);

if strcmp(type,'1931')    
    spectralLocusxy = [T_xyz1931(1,:)./sum(T_xyz1931);T_xyz1931(2,:)./sum(T_xyz1931)];
    scatter(spectralLocusxy(1,1:70),spectralLocusxy(2,1:70),[],sRGBSpectralLocus(:,1:70)','filled')       
    xlabel('x'), ylabel('y')    
elseif strcmp(type,'upvp')
    spectralLocus_upvp = xyTouv([T_xyz1931(1,:)./sum(T_xyz1931);T_xyz1931(2,:)./sum(T_xyz1931)]);
    scatter(spectralLocus_upvp(1,:),spectralLocus_upvp(2,:),[],sRGBSpectralLocus','filled')
    xlabel('u'''),ylabel('v''')
elseif strcmp(type,'MB2')
    load T_cones_ss2.mat T_cones_ss2 S_cones_ss2
    load T_CIE_Y2.mat T_CIE_Y2 S_CIE_Y2
    T_c = SplineCmf(S_cones_ss2,T_cones_ss2,S_xyz1931); %resampling so that I can use the old sRGBs that I already calculated, and keep the appearance comparable accross diagrams
    T_C = SplineCmf(S_CIE_Y2,T_CIE_Y2,S_xyz1931);
    spectralLocus_MB = LMSToMacBoyn(T_c,T_c,T_C);
    scatter(spectralLocus_MB(1,:),spectralLocus_MB(2,:),[],sRGBSpectralLocus','filled')
    xlabel('{\itl}_{MB}'),ylabel('{\its}_{MB}')
end

if or(strcmp(type,'1931'),strcmp(type,'upvp'))
    axis equal
    axis([0 1 0 1])
    %xticks([0 1])
    %yticks([0 1
elseif strcmp(type,'MB2')
    axis([0.5 1 0 1])
end

end