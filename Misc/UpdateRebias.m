function [reference] = UpdateRebias(i,sample, reference, AdaptationParameter)
%UPDATEREBIAS Summary of this function goes here
%   Detailed explanation goes here
	if(i==2)
		reference=sample;
	elseif(i>=3)
		if(nargin<4)
			AdaptationParameter=1/(i-1);
		end
		reference = riemann_geodesic(reference,  sample,  AdaptationParameter);
	end
end

