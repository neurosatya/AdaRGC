function [Accuracy] = MDMBaseline(data)

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
[Nclass, NTests ,distances ,detected_trial ,trueYtest] = InitializeVar(data);

[C,~] = ClassPrototypeEstimation(data);	% Estimation of class prototypes

%% Testing
disp('Testing...')
for i=1:NTests	
	% classification	
	[distances(i,:), detected_trial(i)] = Classification(C,data.data(:,:,data.idxTest(i)));
end

Accuracy = 100*numel(find(trueYtest-detected_trial==0))/size(detected_trial,2);

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

