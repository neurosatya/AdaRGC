function [ Accuracy ] = FgMDMBaseline( data )

disp('Baseline FgMDM');
%% Init
[Nclass, NTests ,distances ,detected_trial ,trueYtest] = InitializeVar(data);

% Geodesic Filter Transformation
[W,C,Cg] = FilterAndPrototype(data.data(:,:,data.idxTraining),data.labels(data.idxTraining));

%% Testing
disp('Testing...')
for i=1:NTests
    Geodesic_transformed_trial = geodesic_filter(data.data(:,:,data.idxTest(i)),Cg,W(:,1:Nclass-1));    
	% classification	
	[distances(i,:), detected_trial(i)] = Classification(C,Geodesic_transformed_trial);
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

