function [Nclass, NTests ,distances ,detected_trial ,trueYtest] = InitializeVar(data)
% This function is used for copying the different field in the strucuture
% of the data to corresponding outputs. See the code below for self
% explanation
unique_labels=unique(data.labels);
Nclass=size(unique_labels, 2);
NTests = size(data.idxTest, 2);
distances = zeros(NTests, Nclass);	% Preallocation
detected_trial = zeros(1, NTests);	% Preallocation
trueYtest = data.labels(data.idxTest); % true label of the test data
end

