% function description
% sorting eigenvectors with eigenvalues descending.

% Vector, matrix of eigenvectors
% Value, diagonal matrix of eigenvalues
function [new_Vector, new_Value] = sortVectorValue(Vector, Value)
	val = diag(Value);
	[new_val, idx] = sort(val, 'descend');
	for i=1:size(Vector,2)
		new_Vector(:, i) = Vector(:, idx(i));
	end
	new_Value = diag(new_val);