function [C, Ntrials] = Class_MDM_Prototype_Estimation(data)
%CLASSPROTOTYPEESTIMATION Summary of this function goes here
%   Detailed explanation goes here
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

