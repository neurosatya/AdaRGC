function [Accuracy] = RebiasAdaptationMDM(data, AdaptationParameter)

% A function to predict the label according to Sequential Rebias strategy
% proposed in the paper
%
%Input:
%data: A structure with following fields (In accordance to Barachant toolobox)
%     data.data: The covariance matrices of each EEG trial as [Nc*NC*Nt]
%                Nc: Number of Channels Nt: Number of trials
%   data.labels: True labels corresponding to each trial | shape: [1*Nt]
%   data.idxTraining: Indexes corrsponding to training samples in data
%   data.idxTest: Indexes corresponding to testing samples in data
%Output:
%detected_trial: The labels predicted corresponding to evaluation trials
%
%by Satyam Kumar
%   satyamjuve@gmail.com
%

disp('Rebias Adaptation MDM')
%% Init
[Nclass, NTests ,distances ,detected_trial ,trueYtest] = InitializeVar(data);

% Compute Reference Rebias
reference = riemann_mean(data.data(:, :, data.idxTraining)); % Estimation of riemannian mean of training data
% Shifting the training covariance matrices
data.data(:, :, data.idxTraining) = Affine_transformation(data.data(:, :, data.idxTraining), reference);

[C,~] = ClassPrototypeEstimation(data);	% Estimation of class prototypes of transformed data

%% Testing
disp('Testing...')
for i=1:NTests
	% Estimation of transformation matrix using geodesic adaptation
	if(i>1)
		if(nargin<2)
			reference = UpdateRebias(i, data.data(:, :, data.idxTest(i-1)), reference);
		else
			reference = UpdateRebias(i, data.data(:, :, data.idxTest(i-1)), reference, AdaptationParameter);
		end
	end
	% Affine transformation of the trial
	Affine_transformed_trial = Affine_transformation(data.data(:, :, data.idxTest(i)), reference);
	% classifiaction
	[distances(i,:), detected_trial(i)] = Classification(C,Affine_transformed_trial);
end

Accuracy = 100*numel(find(trueYtest-detected_trial==0))/size(detected_trial,2);


%% Displays
for i=1:Nclass
	disp(strcat('Class ', int2str(i)))
	disp(C{i})
end

disp('detected_trial');
disp(detected_trial);
disp('distances');
disp(distances);
disp('Rebias Final')
disp(reference)
%disp('Rebias Final test one iteration more')
%disp(riemann_geodesic(reference,  data.data(:, :, data.idxTest(size(data.idxTest, 2))),  1/size(data.idxTest, 2)));



end

