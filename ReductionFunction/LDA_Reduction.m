% function description
% Input: 
% 		Samples_Matrix, nx1-Cell, every cell is a supervised cluster.
% 		d, number of reduction dimension.

% Output:
% 		centers, center of every conrresponding supervised cluster.
% 		LDA_matrix, the dimension-reduction matrix with Principle Component Analysis.
% Attention:
% 		LDA algorithm do not need pre-processing.
function [LDA_centers, LDA_matrix] = LDA_Reduction(Samples_Matrix, d)
	disp('LDA reduction is being conducted.');
	% xSw
	Width = size(Samples_Matrix{1}, 2);
	xSw = zeros(Width);
	SUM = zeros(1, Width);
	for mv=1:5
		Specimen_Counts = size(Samples_Matrix{mv}, 1);
		center(mv, :) = mean(Samples_Matrix{mv}, 1);
		temp = Samples_Matrix{mv} - repmat(center(mv, :), Specimen_Counts, 1);
		xSw = xSw + temp'*temp;
		SUM = SUM + sum(Samples_Matrix{mv}, 1);
	end
	Xmeans = SUM/5/Specimen_Counts;

	% xSb
	xSb = zeros(Width);
	for mv=1:5
		temp = center(mv, :) - Xmeans;
		xSb = xSb + temp'*temp;
	end

	% reduction matrix in LDA algorithm
	[old_Vector, old_Value] = eig(xSb, xSw);
	% sorting eigenvectors with eigenvalues descending.
	[Vector, Value] = sortVectorValue(old_Vector, old_Value);
	LDA_matrix = Vector(:, 1:d);

	LDA_centers = center * LDA_matrix;