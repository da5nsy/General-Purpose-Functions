clear, clc, close all

%%
load T_xyz1931.mat

T_xyz1931 = SplineCmf(S_xyz1931,T_xyz1931,[375,0.17,1920]);

RGB = ((XYZToSRGBPrimary(T_xyz1931)+1)/3.5)';

im = repmat(RGB,1,1,1080);

im = permute(im,[3,1,2]);

imshow(im)

%figure, plot(RGB)

%%

imwrite(im,'rainbow.tif')
