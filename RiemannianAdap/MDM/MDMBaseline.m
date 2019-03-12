function [detected_trial] = MDMBaseline(data)

% A function to predict the label using to MDM classifier
%
%Input:
%data: A structure with following fields (In accordance with covariance toolobox by Barachant)
%   data.data: The covariance matrices of each EEG trial as [Nc*NC*Nt]
%              Nc: Number of Channels Nt: Number of trials                           
%   data.labels: True labels corresponding to each trial | shape: [1*Nt]
%   data.idxTraining: Indexes corrsponding to training samples in data
%   data.idxTest: Indexes corresponding to testing samples in data
%Output:
%detected_trial: The labels predicted corresponding to evaluation/test trials
%
%by Satyam Kumar
%   satyamjuve@gmail.com
%
disp('Baseline MDM');
%% Init
unique_labels=unique(data.labels);
Nclass=size(unique_labels, 2);
NTests = size(data.idxTest, 2);
distances = zeros(NTests, Nclass);	% Preallocation
detected_trial = zeros(1, NTests);	% Preallocation

[C,~] = ClassPrototypeEstimation(data);	% Estimation of class prototypes

%% Testing
disp('Testing...')
for i=1:NTests	
	% classifiaction	
	[distances(i,:), detected_trial(i)] = Classification(C,data.data(:,:,data.idxTest(i)));
end

%% Displays
for i=1:Nclass
	disp(strcat('Class ',int2str(i)));
	disp(C{i});
end

disp('detected_trial');
disp(detected_trial);
disp('distances');
disp(distances);

end

