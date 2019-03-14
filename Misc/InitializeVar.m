function [Nclass, NTests ,distances ,detected_trial ,trueYtest] = InitializeVar(data)
%INITIALIZEVAR Summary of this function goes here
%   Detailed explanation goes here
unique_labels=unique(data.labels);
Nclass=size(unique_labels, 2);
NTests = size(data.idxTest, 2);
distances = zeros(NTests, Nclass);	% Preallocation
detected_trial = zeros(1, NTests);	% Preallocation
trueYtest = data.labels(data.idxTest); % true label of the test data
end

