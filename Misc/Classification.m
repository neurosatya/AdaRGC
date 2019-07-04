function [distances,detected_trial] = Classification(Classes,sample)
% This function estimates the riemannian distances from different class
% prototypes and it's predicted class, given the class prototypes. This
% uses the concept of MDM classification
% Input: 
% Classes: class prototypes i.e riemannian means of different classes. cell array
%          shape [1*N_classes]
% sample: covariance matrix of the incoming trial: shape [N_channel*N_channel]
% Output:
% distances: The riemannian distances from each class prototype 
%            | shape array [1*N_classes]
% detected_trial : label of the detected trial

% Note: This script is used for classification using riemannian distances
distances = zeros(1,max(size(Classes)));
for i=1:max(size(Classes))
	distances(i) = distance_riemann(sample, Classes{i});
end
[~, detected_trial] = min(distances);
end

