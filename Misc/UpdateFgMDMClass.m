function [W, C, Cg, Ntrials, training_set, training_labels] = UpdateFgMDMClass(Cg, Ntrials, id, sample, training_set, training_labels, AdaptationParameter)
% This function is used for updation of parameter in FgMDM adaptation scheme where
% class prototypes are updated
% inputs:
% Cg: The reference matrix where tangent space is estimated
% Ntrials: Array of number of trials in each class 
% id: The label given to the incoming sample
% sample: Covariance matrix  of incoming trial
% training_set: The covariance matrices of each trial as [Nc*NC*Nt]
%              Nc: Number of Channels Nt: Number of trials 
% training_labels: The corresponding labels of covariance matrices present in training set
%              shape [1*Nt] 
% AdaptationParameter: Integer value [0,1]
% Outputs:
% W: Geodesic filters which is estimated after adaptation of incoming trial followed by  discriminant analysis in
%    tangent space
% Cg: The updated riemannian mean (barycentre) of the covariances present in the training set
% C: Updated Class prototypes after geodesic filtering corresponding to each class
% Ntrials: Updated number of trials corresponding to each class
% training_set: updated training set after adaptation, The covariance matrices of each trial as [Nc*NC*(Nt+1)]
% training_labels: updated training label set after adaptation, The labels of each trial as [1*(Nt+1)]



% Note: Used for complete adaptation in Supervised, unsupervised FgMDM
% adaptation. 


unique_labels=unique(training_labels);
Nclass=size(unique_labels, 2);
Ntrials(id) = Ntrials(id) + 1;
if(nargin<7)
	AdaptationParameter=1/sum(Ntrials);
end

Cg = riemann_geodesic(Cg, sample, AdaptationParameter);

% update the training set with current class trial
training_set = cat(3,training_set, sample);
training_labels = [training_labels, id];

[W] = fgda_Cspecifed(training_set, training_labels, Cg, 'shcov', {});

filter_set = geodesic_filter(training_set, Cg, W(:,1:Nclass-1));

for i=1:Nclass
	C{i} = riemann_mean(filter_set(:, :, training_labels==unique_labels(i)));
end

end

