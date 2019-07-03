function [C, Ntrials] = UpdateClass(C,Ntrials,id,sample, AdaptationParameter)
% This function is used for geodesic adaptation of the class prototype with
% the incoming trial sample. For the mathematics of geodesic adaptation
% scheme check equation (2) in [1]
% 
% inputs:
% C: Cell array of covariance matrices | class prototypes
% Ntrials: Array of number of trials in each class 
% id: The label given to the incoming sample
% sample: Covariance matrix  of incoming trial
% AdaptationParameter: Integer value [0,1]
% outputs:
% C: Updated cell array of covariance matrices | corresponding class
%    prototypes
% Ntrials: Updated number of trials in each class

% 
% [1]:Kumar, S., Yger, F. and Lotte, F., 2019, February. Towards Adaptive 
% Classification using Riemannian Geometry approaches in Brain-Computer Interfaces. 
% In IEEE International Winter Conference on Brain-Computer Interfaces.
	Ntrials(id) = Ntrials(id) + 1;
	if(nargin<5)
		AdaptationParameter = 1/Ntrials(id);
	end
	C{id} = riemann_geodesic(C{id}, sample, AdaptationParameter);
end

