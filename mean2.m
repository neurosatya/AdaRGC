function [A] = mean2(B)
%MEAN2 Summary of this function goes here
%   Detailed explanation goes here

ITER_MAX = 50;
EPSILON = 0.0001;

k = size(B,3);
n = size(B,1);
nu = 1.0;
tau = 10000;
crit = 10000;
niter = 0;

A = mean(B,3);

while (niter < ITER_MAX && EPSILON < crit && EPSILON < nu)
	niter = niter +1;
	sC = inv(sqrtm(A));
	mJ = zeros(n,n);
	for i=1:k
		mJ = mJ + B(:,:,i);
	end
	mJ = (1/k) * mJ;
	crit = norm(mJ);
	A = sC * expm(nu * mJ) * sC;
	h = nu * crit;
	if (h < tau)
		nu = nu * 0.95;
		tau = h;
	else
		nu = nu * 0.5;
	end
end
end

