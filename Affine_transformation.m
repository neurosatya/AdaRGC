function [transformed_data] = Affine_transformation(data,reference)
% A function to shift covariance matrices on Riemannian manifold
% For detailed visualisation check Figure 5:
%           Yger F, Sugiyama M., Supervised logeuclidean metric learning for symmetric positive definite matrices. 
%           arXiv preprint arXiv:1502.03505. 2015 Feb 12. 
% Input:
%     data: The covariance matrices of each EEG trial as [Nc*NC*Nt]
%                Nc: Number of Channels Nt: Number of trials
%   refernce: The Affine transformation of size [Nc*Nc]
% Output:
%     transformed_data: The covariance matrices transfored according to affine transform 'reference'
%                      (transformed_data)=reference*data*reference';     
    for i=1:size(data,3)
        transformed_data(:,:,i)=inv(sqrtm(reference))*data(:,:,i)*inv(sqrtm(reference))';
    end

end

