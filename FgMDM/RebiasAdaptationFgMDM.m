function [detected_trial] = RebiasAdaptationFgMDM(data,AdaptationParameter)

% A function to perdict the label according to Sequential Rebias strategy
% for FgMDM classifier proposed in the paper
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



unique_labels=unique(data.labels);
Nclass=size(unique_labels,2);
reference_training=riemann_mean(data.data(:,:,data.idxTraining)); % Estimation of riemannian mean of training data
% Shifting the training covariance matrices
data.data(:,:,data.idxTraining)=Affine_transformation(data.data(:,:,data.idxTraining),reference_training);  

% Geodesic FIlter estimation on Affine transformed training data
[W,C,Cg] = FilterAndPrototype(data.data(:,:,data.idxTraining),data.labels(data.idxTraining));




cov_data_ref=[];

for i=1:size(data.idxTest,2) %size(data.idxTest,2)
    % Estimation of transformation matrix using geodesic adaptation
    if(i==1)
        reference_testing=reference_training;
    elseif(i==2)
        cov_data_ref=cat(3,cov_data_ref,data.data(:,:,data.idxTest(i-1)));
        reference_testing=cov_data_ref;
    elseif(i>=3)
        if(nargin<2)
            AdaptationParameter=1/(i-1);
        end
        reference_testing_temp=riemann_geodesic(reference_testing,data.data(:,:,data.idxTest(i-1)),AdaptationParameter);
        reference_testing=reference_testing_temp;        
    end
    %Affine Transformation od the trial
    Affine_transformed_trial=Affine_transformation(data.data(:,:,data.idxTest(i)),reference_testing);
    %Geodesic Filtering of the incoming trial
    Geodesic_Affine_transformed_trial = geodesic_filter(Affine_transformed_trial,Cg,W(:,1:Nclass-1));    

    % distance calculation for Minimum distance to Riemannian Mean
    % classifiaction
    
    for class=1:Nclass
        distance(class) = distance_riemann(Affine_transformed_trial,C{class});
    end
    [~,detected_trial(i)]=min(distance);
    % 
end

disp('Rebias Adaptation FgMDM')
for i=1:Nclass
	disp(strcat('Class ',int2str(i)))
	disp(C{i})
end


end

