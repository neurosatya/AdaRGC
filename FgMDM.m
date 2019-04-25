function [Accuracy, Detected, Distances] = FgMDM(data, type, display)

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
			disp('Baseline FgMDM');
		case 'Rebias'
			disp('Rebias Adaptation FgMDM');
		case 'Supervised Rebias'
			disp('Supervised Rebias Adaptation FgMDM');
		case 'Unsupervised Rebias'
			disp('Unsupervised Rebias Adaptation FgMDM');
		case 'Supervised'
			disp('Supervised Adaptation FgMDM');
		case 'Unsupervised'
			disp('Unsupervised Adaptation FgMDM');
		otherwise
			disp('Unkknown Method classical used');
			type = 'normal';
	end
end

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

%% Init
[Nclass, NTests ,Distances ,Detected ,trueYtest] = InitializeVar(data);

% Geodesic Filter Transformation
training_set = data.data(:,:,data.idxTraining);
training_labels = data.labels(data.idxTraining);
[W, Cg, C, Ntrials] = Class_FgMDM_Prototype_Estimation(training_set, training_labels);

%% Testing
if display
	disp('Testing...')
end

for i=1:NTests
	trial=data.data(:,:,data.idxTest(i));
	Transformed_trial = geodesic_filter(trial,Cg,W(:,1:Nclass-1));
	% Classification
	[Distances(i,:), Detected(i)] = Classification(C,Transformed_trial);
	
	% Udpade
	if (Supervised)
		[W, C, Cg, Ntrials, training_set, training_labels] = UpdateFgMDMClass(Cg, Ntrials, trueYtest(i), trial, training_set, training_labels);
	elseif (Unsupervised)
		[W, C, Cg, Ntrials, training_set, training_labels] = UpdateFgMDMClass(Cg, Ntrials, Detected(i), trial, training_set, training_labels);
	end

end

Accuracy = 100*numel(find(trueYtest-Detected==0))/size(Detected,2);
%% Displays
if display
	disp('Reference Matrix');
	disp(Cg);
	disp('LDA Weight');
	disp(W);	
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
%
% Rebias = false;
% Supervised = false;
% Unsupervised = false;
% if (strcmp(type, 'Rebias') || strcmp(type, 'Supervised Rebias') || strcmp(type, 'Unsupervised Rebias'))
% 	Rebias = true;
% end
% if (strcmp(type, 'Supervised Rebias') || strcmp(type, 'Supervised'))
% 	Supervised = true;
% end
% if (strcmp(type, 'Unsupervised Rebias') || strcmp(type, 'Unsupervised'))
% 	Unsupervised = true;
% end
%
% if (Rebias)
% 	% Compute Reference Rebias
% 	reference=riemann_mean(data.data(:, :, data.idxTraining)); % Estimation of riemannian mean of training data
% 	% Shifting the training covariance matrices
% 	data.data(:, :, data.idxTraining)=Affine_transformation(data.data(:, :, data.idxTraining), reference);
% end
%
% [C,Ntrials] = ClassPrototypeEstimation(data);	% Estimation of class prototypes
%
% %% Testing
% for i=1:NTests
% 	trial=data.data(:,:,data.idxTest(i));
%
% 	% Estimation of transformation matrix using geodesic adaptation
% 	if(Rebias)
% 		if(i>1)
% 			reference = UpdateRebias(i, data.data(:, :, data.idxTest(i-1)), reference);
% 		end
% 		% Affine transformation of the trial
% 		trial = Affine_transformation(trial, reference);
% 	end
%
% 	% Classification
% 	[Distances(i,:), Detected(i)] = Classification(C,trial);
%
% 	% Udpade
% 	if (Supervised)
% 		[C, Ntrials] = UpdateClass(C, Ntrials, trueYtest(i), trial);
% 	elseif (Unsupervised)
% 		[C, Ntrials] = UpdateClass(C, Ntrials, Detected(i), trial);
% 	end
% end
%
