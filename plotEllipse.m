function e = plotEllipse(dfe,plot)

% Source: amended from from http://stackoverflow.com/questions/3417028/ellipse-around-the-data-in-matlab

%# substract mean
Mu = mean(dfe');
X0 = bsxfun(@minus, dfe', Mu);

%%

%# eigen decomposition [sorted by eigen values]
STD = 1;                     %# 2 standard deviations
conf = 2*normcdf(STD)-1;     %# covers around 95% of population
scale = chi2inv(conf,2);     %# inverse chi-squared with dof=#dimensions

Cov = cov(X0) * scale;
[V D] = eig(Cov);
%[V D] = eig( X0'*X0 ./ (sum(idx)-1) );     %#' cov(X0)
[D order] = sort(diag(D), 'descend');
D = diag(D);
V = V(:, order);

t = linspace(0,2*pi,100);
e = [cos(t) ; sin(t)];        %# unit circle
VV = V*sqrt(D);               %# scale eigenvectors
e = bsxfun(@plus, VV*e, Mu'); %#' project circle back to orig space

%# plot cov and major/minor axes
if plot
    plot(e(1,:), e(2,:), 'Color','k');
end
%#quiver(Mu(1),Mu(2), VV(1,1),VV(2,1), 'Color','k')
%#quiver(Mu(1),Mu(2), VV(1,2),VV(2,2), 'Color','k')


end