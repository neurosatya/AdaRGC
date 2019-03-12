function [detected_trial] = SupervisedRebiasAdaptationFgMDM(data,AdaptationParameter)

disp('Supervised Rebias Adaptation FgMDM')


unique_labels=unique(data.labels);
Nclass=size(unique_labels,2);

%% Rebiasing the TrainingStage
tic
unique_labels=unique(data.labels);
Nclass=size(unique_labels,2);
reference_training=riemann_mean(data.data(:,:,data.idxTraining));
data.data(:,:,data.idxTraining)=Affine_transformation(data.data(:,:,data.idxTraining),reference_training);
for i=1:Nclass
	cov_org{i}=data.data(:,:,data.labels(data.idxTraining)==unique_labels(i));
	C_org{i} = mean_covariances(data.data(:,:,data.labels(data.idxTraining)==unique_labels(i)),'riemann');
end
%%  Geodesic Filtering
training_set=data.data(:,:,data.idxTraining);
training_labels=data.labels(data.idxTraining);
tic
[W,Cg,Covclass,S,mutot,mu,~,Strain] = fgda_satyam_Rebiased(training_set,training_labels,'riemann',{},'shcov',{});
toc
% [W,C,Cg] = MyAdaptiveGeodesicFilter(training_set,training_labels);

training_set_temp = geodesic_filter(training_set,Cg,W(:,1:Nclass-1));
C = cell(Nclass,1);
% estimation of center of Geodesically Filtered transforemd data
for i=1:Nclass
	cov{i}=training_set_temp(:,:,training_labels(data.idxTraining)==unique_labels(i));
	C{i} = riemann_mean(cov{i});
end
toc
%% Testing Phase
cov_data_ref=[];
trueYtest  = data.labels(data.idxTest);
for i=1:size(data.idxTest,2)
	tic
	if(i==1)
		reference_testing=reference_training;
	elseif(i==2)
		cov_data_ref=cat(3,cov_data_ref,data.data(:,:,data.idxTest(i-1)));
		reference_testing=riemann_mean(cov_data_ref);
	elseif(i>=3)   
		if(nargin<2)
			AdaptationParameter=1/(i-1);
		end
		reference_testing_temp=riemann_geodesic(reference_testing,data.data(:,:,data.idxTest(i-1)),AdaptationParameter);
		reference_testing=reference_testing_temp;        
	end
	trial=Affine_transformation(data.data(:,:,data.idxTest(i)),reference_testing);
	% Geodesic Test Filtering
	Geodesic_Affine_transformed_trial = geodesic_filter(trial,Cg,W(:,1:Nclass-1));    
	for class=1:Nclass
		distance(i,class) = distance_riemann(Geodesic_Affine_transformed_trial,C{class});
	end
	[~,detected_trial(i)]=min(distance(i,:));
	%Adaptation
	training_labels=[training_labels,trueYtest(i)];


	[W,Strain,mu] = fgda_adaptationSameCgRETRAIN_W(eye(size(data.data,2)),trial,training_labels,Strain,mu,Covclass,'shcov',{});        
	for class=1:Nclass
		cov{class} = geodesic_filter(cov_org{class},Cg,W(:,1:Nclass-1));
		C{class}=riemann_mean(cov{class});
	end  
	toc;
end



for i=1:Nclass
disp(strcat('Class ',int2str(i)))
disp(C{i})
end



end

