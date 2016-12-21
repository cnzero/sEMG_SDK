% function description
% Input: 
% 		Samples_Matrix, nx1-Cell, every cell is a supervised cluster.

% Output:
% 		ICA_centers, center of every conrresponding supervised cluster.
% 		ICA_matrix, the dimension-reduction matrix with Independent Component Analysis.
function [ICA_centers, ICA_matrix] = ICA_Reduction(Samples_Matrix)