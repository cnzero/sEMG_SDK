% function description
% every row of Sample matrix is normalized by [its own variance]
function [new_samples, mean_value, std_var_value] = PCA_normalization(Sample)
	% centering
	mean_value = mean(Sample, 1);
	% 1xn
	Sample_centering = Sample - repmat(mean_value, size(Sample, 1), 1);

	% whitening
	std_var_value = sqrt(var(Sample_centering, 1));
	% 1xn
	new_samples = Sample_centering./repmat(std_var_value, size(Sample, 1), 1);

