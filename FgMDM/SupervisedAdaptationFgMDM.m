function [Accuracy] = SupervisedAdaptationFgMDM(data,AdaptationParameter)

% A function to perdict the label according to Sequential Supervised Adaptation strategy
% for FgMDM classifier proposed in the paper
%
%Input:
%data: A structure with following fields (In accordance to Barachant toolobox)
%     data.data: The covariance matrices of each EEG trial as [Nc*NC*Nt]
%                Nc: Number of Channels Nt: Number of trials
%   data.labels: True labels corresponding to each trial | shape: [1*Nt]
%   data.idxTraining: Indexes corrsponding to training samples in data
%   data.idxTest: Indexes corresponding to testing samples in data
%   Adaptation Parameter: The geodesic interpolation coefficient used for
%   adaptation of covariance Matrices
%Output:
%detected_trial: The labels predicted corresponding to evaluation trials

disp('Supervised Adaptation FgMDM')
%% Init
[Nclass, NTests ,distances ,detected_trial ,trueYtest] = InitializeVar(data);

% Separating each chunk for specific class covariances
unique_labels=unique(data.labels);
cov_org = cell(Nclass,1);
for i=1:Nclass
	cov_org{i}=data.data(:,:,data.labels(data.idxTraining)==unique_labels(i));
end

%% Geodesic Filter Transformation
training_set = data.data(:,:,data.idxTraining);
training_labels = data.labels(data.idxTraining);

[W,C,Cg] = FilterAndPrototype(training_set,training_labels);

%% Testing
disp('Testing...')
for i=1:NTests
	Current_trial=data.data(:,:,data.idxTest(i));
	Geodesic_transformed_trial = geodesic_filter(Current_trial,Cg,W(:,1:Nclass-1));

	% distance_calculation from geodesically filtered class prototypes
	for class=1:Nclass
		distances(i,class) = distance_riemann(Geodesic_transformed_trial,C{class});
	end
	[~,detected_trial(i)]=min(distances(i,:));
	
	% classification	
	%[distances(i,:), detected_trial(i)] = Classification(C,Geodesic_transformed_trial);

	% update the training set with current class trial
	training_set = cat(3,training_set,Current_trial);
	training_labels = [training_labels,trueYtest(i)];
	% Updating the class specific chunks with current trial in a supervised adaptation framework
	cov_org{trueYtest(i)}=cat(3,cov_org{trueYtest(i)},Current_trial);

	% Geodesic interpolation of the Barycentre of all the trials :
	% train_set+incoming trial
	if(nargin<2)
		AdaptationParameter = 1/(size(training_set,3));
	end
	Cg=riemann_geodesic(Cg,Current_trial,AdaptationParameter);

	clear W C  % removing the past filter matrix and class prototypes
	
	[W] = fgda_Cspecifed(training_set,training_labels,Cg,'shcov',{});
	
	% Refiltering each class specific chunks and hence re-estimation of class prototypes
	cov = cell(Nclass,1);
	for class=1:Nclass
		cov{class} = geodesic_filter(cov_org{class},Cg,W(:,1:Nclass-1));
		C{class}=riemann_mean(cov{class});
	end
end

Accuracy = 100*numel(find(trueYtest-detected_trial==0))/size(detected_trial,2);

%% Displays
disp('Reference Matrix');
disp(Cg);
disp('LDA Weight');
disp(W);

for i=1:Nclass
	disp(strcat('Class ',int2str(i)));
	disp(C{i});
end

disp('detected_trial');
disp(detected_trial);
disp('distances');
disp(distances);

end



