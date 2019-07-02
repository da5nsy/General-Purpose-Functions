% PCA variable weights mess around

% Testing whether variable weights in pca works the way I think it does.
% Interim conclusion: it does not.

clear, clc, close all

%pc1 =  

x = [-3:.1:3];
pc1 = normpdf(x,0,0.2);
pc2 = normpdf(x,0.5,0.5);
pc3 = normpdf(x,-3,0.5);

VariableWeights = double(x > -1) + realmin;

figure,
plot(x,pc1,x,pc2,x,pc3,x,VariableWeights,'k--')

%% Generate data

%rng(1); 

data = [pc1',pc2',pc3']*rand(3,100);

figure, 
plot(x,data)

dataVW = data.*VariableWeights';

figure, 
plot(x,dataVW)

%%

[p.coeff, p.score, p.latent] = pca(data');
[pv.coeff, pv.score, pv.latent] = pca(data','VariableWeights',VariableWeights);
[pvw.coeff, pvw.score, pvw.latent] = pca(dataVW');

figure,
plot(x,p.coeff(:,1:5))
legend

figure,
plot(x,pv.coeff(:,1:5))
legend

figure,
plot(x,pvw.coeff(:,1:5))
legend


