% function description
% 		whitening the centered samples.
% Input:	samples, 5x1-cell
% 			E, eigenvectors
% 			D, diagonal matrix of eigenvalues

% Output:	new_samples, 5x1-cell
% 			whiteningMatrix
% 			dewhiteningMatrix
function [new_samples, whiteningMatrix, dewhiteningMatrix] = whitening(samples, E,D)