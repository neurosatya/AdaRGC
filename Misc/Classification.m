function [distances,detected_trial] = Classification(Classes,sample)
%CLASSIFICATION Summary of this function goes here
%   Detailed explanation goes here
distances = zeros(1,max(size(Classes)));
for i=1:max(size(Classes))
	distances(i) = distance_riemann(sample, Classes{i});
end
[~, detected_trial] = min(distances);
end

