% function description
% Input: 
% 		Samples_Cell, nx1-Cell, every cell is a supervised cluster.
% 					  n, number of clusters or movement.
% 		d, number of reduction dimension.

% Output:
% 		centers, center of every conrresponding supervised cluster.
% 			nxd
% 		LDA_matrix, the dimension-reduction matrix with Principle Component Analysis.
% 			(n_ch x n_f) x d
% 			Width x d
% Attention:
% 		LDA algorithm do not need pre-processing.
function [LDA_centers, LDA_matrix] = LDA_Reduction(Samples_Cell, d)
	disp('LDA reduction is being conducted.');
	% xSw
	Width = size(Samples_Cell{1}, 2);
	xSw = zeros(Width);
	SUM = zeros(1, Width);
	n_mv = length(Samples_Cell);
	Specimen_Counts = 0;
	for mv=1:
		Specimen_Counts = Specimen_Counts + size(Samples_Cell{mv}, 1);
		center(mv, :) = mean(Samples_Cell{mv}, 1);
		temp = Samples_Cell{mv} - repmat(center(mv, :), Specimen_Counts, 1);
		xSw = xSw + temp'*temp;
		SUM = SUM + sum(Samples_Cell{mv}, 1);
	end
	Xmeans = SUM/Specimen_Counts;

	% xSb
	xSb = zeros(Width);
	for mv=1:n_mv
		temp = center(mv, :) - Xmeans;
		xSb = xSb + temp'*temp;
	end

	% reduction matrix in LDA algorithm
	[old_Vector, old_Value] = eig(xSb, xSw);
	% sorting eigenvectors with eigenvalues descending.
	[Vector, Value] = sortVectorValue(old_Vector, old_Value);
	LDA_matrix = Vector(:, 1:d);

	LDA_centers = center * LDA_matrix;