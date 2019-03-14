function [distances,detected_trial] = Classification(Classes,sample)
%CLASSIFICATION Summary of this function goes here
%   Detailed explanation goes here
distances = zeros(1,size(Classes,1));
for i=1:size(Classes,1)
	distances(i) = distance_riemann(sample, Classes{i});
end
[~, detected_trial] = min(distances);

end

