function [C, Ntrials] = Class_MDM_Prototype_Estimation(data)
% This function is used to estimate the different parameters for MDM
% classifier
% Input:
% data: A structure with following fields 
%   data.data: The covariance matrices of each EEG trial as [Nc*NC*Nt]
%              Nc: Number of Channels Nt: Number of trials                           
%   data.labels: True labels corresponding to each trial | shape: [1*Nt]
%   data.idxTraining: Indexes corrsponding to training samples in data|
%                     shape [1*Ntraining]
%   data.idxTest: Indexes corresponding to testing samples in data |
%                     shape [1*Ntesting]
% Output:
% C: Class prototypes corresponding to each class
% Ntrials: number of trials corresponding to each class

% Note: This script is used in MDM classifiers

unique_labels=unique(data.labels);
Nclass=size(unique_labels, 2);
Ntrials = zeros(1, Nclass);

%% Estimation of class prototypes
C = cell(Nclass,1);
for i=1:Nclass
	Ntrials(i) = size(data.data(:, :, data.labels(data.idxTraining)==unique_labels(i)),3);
    C{i} = riemann_mean(data.data(:,:,data.labels(data.idxTraining)==unique_labels(i)));
end
end

