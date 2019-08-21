clear, close, clc

%%

load T_xyz1931.mat T_xyz1931 S_xyz1931


CCT = 1000:10:12000;

SPD = GenerateBlackBody(CCT,SToWls(S_xyz1931));

%%

XYZ = T_xyz1931 * SPD;
XYZ = XYZ./XYZ(2,:)*100;
sRGB = XYZToSRGBPrimary(XYZ);

%%

for i = 1:100
im1(:,:,i) = sRGB(:,:,1);
end
im2 = permute(im1,[3,2,1]);
%im = repmat(sRGB,100,1);

%
figure,
%plot(CCT,sRGB')
%legend

imshow(im2/255)