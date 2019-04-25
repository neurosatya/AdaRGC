function [W, C, Cg, Ntrials, training_set, training_labels] = UpdateFgMDMClass(Cg, Ntrials, id, sample, training_set, training_labels, AdaptationParameter)
%UPDATECLASS Summary of this function goes here
%   Detailed explanation goes here

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

