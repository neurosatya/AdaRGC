function [Accuracy, Detected, Distances] = MDM(data, type, display)
% This function is used to compute the the classification performance using
% different adaptation schemes in MDM classifier. Moreover it also
% predicts the labels of detected class as well as riemannian distances
% from class prototypes at every stage of adaptation
% Input:
% data: A structure with following fields 
%   data.data: The covariance matrices of each EEG trial as [Nc*NC*Nt]
%              Nc: Number of Channels Nt: Number of trials                           
%   data.labels: True labels corresponding to each trial | shape: [1*Nt]
%   data.idxTraining: Indexes corrsponding to training samples in data|
%                     shape [1*Ntraining]
%   data.idxTest: Indexes corresponding to testing samples in data |
%                     shape [1*Ntesting]
% type: A string | Name of different adaptation schemes, pick one of the
%       following:
%       * 'normal'
%       * 'Rebias'
%       * 'Supervised Rebias'
%       * 'Unsupervised Rebias'
%       * 'Supervised'
%       * 'Unsupervised'
%
% display: logging the different outputs | Options , True or False


%% Argument
if (nargin<2)||(isempty(type))
	type = 'normal';
end
if (nargin<3)
	display = false;
end

%% Switch type
if display
	switch type
		case 'normal'
			disp('Baseline MDM');
		case 'Rebias'
			disp('Rebias Adaptation MDM');
		case 'Supervised Rebias'
			disp('Supervised Rebias Adaptation MDM');
		case 'Unsupervised Rebias'
			disp('Unsupervised Rebias Adaptation MDM');
		case 'Supervised'
			disp('Supervised Adaptation MDM');
		case 'Unsupervised'
			disp('Unsupervised Adaptation MDM');
		otherwise
			disp('Unkknown Method classical used');
			type = 'normal';
	end
end

%% Init
[Nclass, NTests ,Distances ,Detected ,trueYtest] = InitializeVar(data);

Rebias = false;
Supervised = false;
Unsupervised = false;
if (strcmp(type, 'Rebias') || strcmp(type, 'Supervised Rebias') || strcmp(type, 'Unsupervised Rebias'))
	Rebias = true;
end
if (strcmp(type, 'Supervised Rebias') || strcmp(type, 'Supervised'))
	Supervised = true;
end
if (strcmp(type, 'Unsupervised Rebias') || strcmp(type, 'Unsupervised'))
	Unsupervised = true;
end

if (Rebias)
	% Compute Reference Rebias
	reference=riemann_mean(data.data(:, :, data.idxTraining)); % Estimation of riemannian mean of training data
	% Shifting the training covariance matrices
	data.data(:, :, data.idxTraining)=Affine_transformation(data.data(:, :, data.idxTraining), reference);
end

[C,Ntrials] = Class_MDM_Prototype_Estimation(data);	% Estimation of class prototypes

%% Testing
if display
	disp('Testing...')
end
for i=1:NTests
	trial=data.data(:,:,data.idxTest(i));
	
	% Estimation of transformation matrix using geodesic adaptation
	if(Rebias)
		if(i>1)
			reference = UpdateRebias(i, data.data(:, :, data.idxTest(i-1)), reference);
		end
		% Affine transformation of the trial
		trial = Affine_transformation(trial, reference);
	end
	
	% Classification
	[Distances(i,:), Detected(i)] = Classification(C,trial);
	
	% Udpade
	if (Supervised)
		[C, Ntrials] = UpdateClass(C, Ntrials, trueYtest(i), trial);
	elseif (Unsupervised)
		[C, Ntrials] = UpdateClass(C, Ntrials, Detected(i), trial);
	end
end

Accuracy = 100*numel(find(trueYtest-Detected==0))/size(Detected,2);

%% Displays
if display
	for i=1:Nclass
		disp(strcat('Class ',int2str(i)));
		disp(C{i});
	end
	disp('Detected Trials');
	disp(Detected);
	disp('Distances');
	disp(Distances);
	if (Rebias)
		disp('Rebias Final')
		disp(reference)
	end
end

end

