function [C, Ntrials] = UpdateClass(C,Ntrials,id,sample, AdaptationParameter)
%UPDATECLASS Summary of this function goes here
%   Detailed explanation goes here
	Ntrials(id) = Ntrials(id) + 1;
	if(nargin<5)
		AdaptationParameter=1/Ntrials(id);
	end
	C{id}=riemann_geodesic(C{id}, sample, AdaptationParameter);
end

