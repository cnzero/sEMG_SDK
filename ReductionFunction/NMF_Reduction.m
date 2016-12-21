% function description
% Input: 
% 		Samples_Matrix, nx1-Cell, every cell is a supervised cluster.
% 		d, number of reduction dimension.

% Output:
% 		NMF_matrix, the dimension-reduction matrix with Principle Component Analysis.
function [NMF_centers, NMF_matrix, All_mean, All_var] = NMF_Reduction(Samples_Matrix, d)
	disp('NMF reduction is being conducted.');
	samples = [];
	for mv=1:5
		samples = [samples; ...
				   Samples_Matrix{mv}];
		center(mv,:) = mean(Samples_Matrix{mv}, 1);
	end

	[samples, All_mean, All_var] = PCA_normalization(samples);

	[~, H] = nnmf(samples, d);
	NMF_matrix = pinv(H);
	NMF_centers = center * NMF_matrix;