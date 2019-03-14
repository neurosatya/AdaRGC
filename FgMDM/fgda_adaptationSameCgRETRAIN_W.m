function [W,Strain,mu] = fgda_adaptationSameCgRETRAIN_W(C,trial,Ytrain,Strain,mu,Covclass,METHOD_COV,ARG_COV)

% This code was used in the submitted paper
% Here I normally used IDENTITY Matrix as a fix covariance matrix to
% project the matrices to tangent space

Strain = [Strain,Tangent_space(trial,C)];  % The tangent space mapping of incoming trial is generated and concatenated

Nelec = size(Strain,1);

labels = unique(Ytrain);
Nclass = length(labels);


mu(:,Ytrain(end)) = mean(Strain(:,Ytrain==Ytrain(end)),2); % Mean is precisely updated according to the specified label of incoming trial
Covclass(:,:,Ytrain(end)) = covariances(Strain(:,Ytrain==Ytrain(end)),METHOD_COV,ARG_COV); % Covariance is also updated



%% Adding the new values to the mean
% 
% mutot=mean(mu,2);
% To check if mutot is zero 

% mutot is also updated in propotionate amount

mutot=zeros(size(mu(:,1)));
for i=1:Nclass
    mutot=mutot+(numel(find(Ytrain==i))/size(Ytrain,2))*mu(:,i);
end



Sb = zeros(Nelec,Nelec);    
for i=1:Nclass
    Sb = Sb+(mu(:,i) - mutot)*(mu(:,i)-mutot)';
end
    

S=mean(Covclass,3);

[W Lambda] = eig(Sb,S);
[~, Index] = sort(diag(Lambda),'descend');

W = W(:,Index);
