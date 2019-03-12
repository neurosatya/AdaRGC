function [W,C,Cg] = FilterAndPrototype(training_set,training_labels)
%Input:
%   training_set: The covariance matrices of each EEG trial as [Nc*NC*Nt]
%                Nc: Number of Channels Nt: Number of trials 
%   training_labels: The labels corresponding to each EEG trials as [1*Nt]
%Output:
%   W: Geodesic filters
%   C: Class prototypes of geodesically filtered covariance matrices
%  Cg: Barycentre/Centre of mass of all the covariance matrices in the
%  training set
    unique_labels=unique(training_labels);
    Nclass=size(unique_labels,2);
    % Estimation of W and Cg: Covariance toolbox dependency
    [W,Cg] = fgda(training_set,training_labels,'riemann',{},'shcov',{});
    % Geodesic filtering of the training set from the filters W
    training_set = geodesic_filter(training_set,Cg,W(:,1:Nclass-1));
    C = cell(Nclass,1);
    % estimation of center of transforemd data
    for i=1:Nclass
        cov{i}=training_set(:,:,training_labels==unique_labels(i));
        C{i}=mean_covariances(cov{i},'riemann');
    end

end

