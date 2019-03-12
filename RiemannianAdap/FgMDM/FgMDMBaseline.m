function [ detected_trial ] = FgMDMBaseline( data )

%% Rebias with changing refernce
unique_labels=unique(data.labels);
Nclass=size(unique_labels,2);
%% Geodesic Filter Transformation
[W,C,Cg] = FilterAndPrototype(data.data(:,:,data.idxTraining),data.labels(data.idxTraining));
for i=1:size(data.idxTest,2) %size(data.idxTest,2)
    Geodesic_transformed_trial = geodesic_filter(data.data(:,:,data.idxTest(i)),Cg,W(:,1:Nclass-1));    

    for class=1:Nclass
        distance(class) = distance_riemann(Geodesic_transformed_trial,C{class});
    end
    [~,detected_trial(i)]=min(distance);
    % 
end


end

