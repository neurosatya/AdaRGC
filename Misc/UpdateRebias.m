function [reference] = UpdateRebias(i,sample, reference, AdaptationParameter)
% This function is used for geodesic adaptation of the reference covariance in
% rebias adaptation schemes  For the mathematics of geodesic adaptation
% scheme check equation (2) and rebias adaptation, check equation (7) and  in [1]
% 
% inputs:
% i: The number of trials used for adaptation | the adaptation stage 
% sample: Covariance matrix  of incoming trial
% reference: the reference covariance matrix used for adaptation
% AdaptationParameter: Integer value [0,1]
% outputs:
% C: Updated cell array of covariance matrices | corresponding class
%    prototypes
% Ntrials: Updated number of trials in each class

% 
% [1]:Kumar, S., Yger, F. and Lotte, F., 2019, February. Towards Adaptive 
% Classification using Riemannian Geometry approaches in Brain-Computer Interfaces. 
% In IEEE International Winter Conference on Brain-Computer Interfaces.
	if(i==2)
		reference=sample;
	elseif(i>=3)
		if(nargin<4)
			AdaptationParameter=1/(i-1);
		end
		reference = riemann_geodesic(reference,  sample,  AdaptationParameter);
	end
end

