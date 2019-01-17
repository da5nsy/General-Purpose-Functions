
clc, clear, close all

%%

base = 'C:\Users\cege-user\Documents\Large data\Foster Images\';
load([base,'2004\scene1\ref_crown3bb_reg1_lax.mat']);
% "Edited versions (labelled "_lax") have also been included for Scenes 1, 2, 3, and 5.  
% These edited versions have been corrected for some nonlinear chromatic artefacts arising 
% from movement of foliage within the scene during image acquisition."
load([base,'2004\scene1\radiance_by_reflectance_crown3.mat']);

reflectances = reflectances(401:800,401:800,:); %temporary(?) crop for speed

%%

radiances = reflectances; %preallocate

for i = 1:size(reflectances,1)
    for j = 1:size(reflectances,2)
        radiances(i,j,:) = squeeze(reflectances(i,j,:)).*radiance(:,2);
    end
    if ~mod(i,10) %progress bar
        disp(i)
    end
end
 
%figure, imagesc(reflectances(:,:,17))
%figure, imagesc(radiances(:,:,17))
% max(max(reflectances(:,:,17)))
% max(max(radiances(:,:,17)))

%%

r = reshape(radiances,size(radiances,1)*size(radiances,2),size(radiances,3));

%plot(radiance(:,1),mean(r))

[p.coeff, p.score, p.latent, p.tsquared, p.explained, p.mu] = pca(r);

%%

t = reshape(p.score(:,1:3)*p.coeff(:,1:3)',400,400,33); %!!!!!!!!!!!!!!!

for i=1:33
figure,imagesc(t(:,:,i)); colormap('gray'); colorbar
end


%%

figure, 
plot(p.coeff(:,1:5))
legend



