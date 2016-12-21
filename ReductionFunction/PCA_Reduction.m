% function description
% Input: 
% 		Samples_Matrix, nx1-Cell, every cell is a supervised cluster.
% 		d, number of reduction dimension.

% Output:
% 		PCA_matrix, the dimension-reduction matrix with Principle Component Analysis.
function [PCA_centers, PCA_matrix, All_mean, All_var] = PCA_Reduction(Samples_Matrix, d)
	disp('PCA reduction is being conducted.');
	samples = [];
	for mv=1:5
		samples = [samples; ...
				   Samples_Matrix{mv}];
		center(mv,:) = mean(Samples_Matrix{mv}, 1);
	end

	[samples, All_mean, All_var] = PCA_normalization(samples);

	covarianceMatrix = cov(samples);
	[old_Vector, old_Value] = eig(covarianceMatrix);
	[Vector, Value] = sortVectorValue(old_Vector, old_Value);

	PCA_matrix = Vector(:, 1:d);
	PCA_centers = center * PCA_matrix;