function [W ] = fgda_Cspecifed(Ctrain,Ytrain,C,METHOD_COV,ARG_COV)

% This function is similar to the one ddescribed in Barachant et al. 
% However in this one we specify the Barycentre to project the covariance
% matrices on to th etangent space

labels = unique(Ytrain);
Nclass = length(labels);

Strain = Tangent_space(Ctrain,C);
Nelec = size(Strain,1);

mu = zeros(Nelec,Nclass);
Covclass = zeros(Nelec,Nelec,Nclass);

for i=1:Nclass
    mu(:,i) = mean(Strain(:,Ytrain==labels(i)),2);
    Covclass(:,:,i) = covariances(Strain(:,Ytrain==labels(i)),METHOD_COV,ARG_COV);
end


mutot = mean(mu,2);
    
Sb = zeros(Nelec,Nelec);    
for i=1:Nclass
    Sb = Sb+(mu(:,i) - mutot)*(mu(:,i)-mutot)';
end
    
S=mean(Covclass,3);


[W, Lambda] = eig(Sb,S);
[~, Index] = sort(diag(Lambda),'descend');

W = W(:,Index);
