function [W, Cg, C, Ntrials] = Class_FgMDM_Prototype_Estimation(training_set, training_labels)
% This function is used to estimate the different parameters for FgMDM
% classifier
% Input:
% training_set: The covariance matrices of each trial as [Nc*NC*Nt]
%              Nc: Number of Channels Nt: Number of trials 
% training_labels: The corresponding labels of covariance matrices present in training set
%              shape [1*Nt] 
% Output:
% W: Geodesic filters which is estimated after discriminant analysis in
%    tangent space
% Cg: The riemannian mean (barycentre) of the covariances present in the training set
% C: Class prototypes after geodesic filtering corresponding to each class
% Ntrials: number of trials corresponding to each class

unique_labels=unique(training_labels);
Nclass=size(unique_labels, 2);
Ntrials = zeros(1, Nclass);

%% Estimation of W and Cg: Covariance toolbox dependency
[W, Cg] = fgda(training_set, training_labels, 'riemann', {}, 'shcov', {});
%% Geodesic filtering of the training set from the filters W
training_set = geodesic_filter(training_set, Cg, W(:,1:Nclass-1));
%% Estimation of class prototypes
C = cell(Nclass,1);
for i=1:Nclass
	Ntrials(i) = size(training_set(:, :, training_labels==unique_labels(i)),3);
    C{i} = riemann_mean(training_set(:, :, training_labels==unique_labels(i)));
end
end
