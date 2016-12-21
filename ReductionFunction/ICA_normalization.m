% function description
% let the covariance of Sample be EYE
function new_samples = ICA_normalization(Sample)
	% centering
	mean_value = mean(Sample, 1);
	% 1xn
	Sample_centering = Sample - repmat(mean_value, size(Sample, 1), 1);

	% whitening
	cov_var_value = cov(Sample_centering);
	% nxn
	[V, D] = eig(cov_var_value);
	New_Dsqrt = zeros(size(Sample,2));
	for i=1:size(Sample, 2)
		New_Dsqrt(i,i) = D(i,i)^(-0.5); 
	end
	new_samples = Sample_centering*V*New_Dsqrt*V';