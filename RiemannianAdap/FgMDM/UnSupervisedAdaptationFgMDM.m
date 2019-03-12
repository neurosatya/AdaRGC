function [detected_trial] = UnSupervisedAdaptationFgMDM(data,AdaptationParameter)

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




unique_labels=unique(data.labels);
Nclass=size(unique_labels,2);
trueYtest  = data.labels(data.idxTest); % true lable of the test data
% Separating each chunk for specific class covariances
for i=1:Nclass
    cov_org{i}=data.data(:,:,data.labels(data.idxTraining)==unique_labels(i));
end

%% Geodesic Filter Transformation

training_set=data.data(:,:,data.idxTraining);
training_labels=data.labels(data.idxTraining);


[W,C,Cg] = MyAdaptiveGeodesicFilter(training_set,training_labels);
% toc


cov_rest_ref=[];
cov_data_ref=[];
testing_set=[];


for i=1:size(data.idxTest,2)%size(data.idxTest,2)
%     tic
    Current_trial=data.data(:,:,data.idxTest(i));
    Geodesic_Affine_transformed_trial = geodesic_filter(Current_trial,Cg,W(:,1:Nclass-1));    
    % distance_calculation from geodesically filtered class prototypes
    for class=1:Nclass
        distance(i,class) = distance_riemann(Geodesic_Affine_transformed_trial,C{class});
    end
    [~,detected_trial(i)]=min(distance(i,:));

    % update the training set with current class trial
    training_set=cat(3,training_set,Current_trial);
    training_labels=[training_labels,detected_trial(i)];
    % Updating the class specific chunks with current trial in a supervised adaptation framework 
    cov_org{detected_trial(i)}=cat(3,cov_org{detected_trial(i)},Current_trial);
    % Geodesic interpolation of the Barycentre of all the trials :
    % train_set+incoming trial
    if(nargin<2)
        AdaptationParameter=1/(size(training_set,3));
    end
    Cg=riemann_geodesic(Cg,Current_trial,AdaptationParameter);
    clear W C  % removing the past filter matrix and class prototypes 
    % Re-estimatiom of geodesic Filters
    [W] = fgda_Cspecifed(training_set,training_labels,Cg,'shcov',{});
    
    % Refiltering each class specific chunks and hence re-estimation of
    % class prototypes
    for class=1:Nclass
        cov{class} = geodesic_filter(cov_org{class},Cg,W(:,1:Nclass-1));
        C{class}=riemann_mean(cov{class});
    end

    
    
    fprintf('Accuracy till %d trial: %f\n',i,100*numel(find(trueYtest(1:i)-detected_trial==0))/size(detected_trial,2));

%     toc
end
% 
% Accuracy=100*numel(find(trueYtest-detected_trial==0))/size(detected_trial,2);

% confusionMatrix=confusionmat(trueYtest,detected_trial);
% 
% KappaValue=kappa(confusionMatrix);
% 
% clear detected_trial
% toc

end



