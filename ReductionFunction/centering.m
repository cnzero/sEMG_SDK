% function description
% remove the whole meanValue from every cluster.

% Input:	samples: 5x1-cell
% Output:	new_samples: 5x1-cell,
% 			meanValue: the whole center, 1xn
function [new_samples, meanValue] = centering(samples)
	Samples_Matrix = [samples{1}; ...
					  samples{2}; ...
					  samples{3}; ...
					  samples{4}; ...
					  samples{5}];
	meanValue = mean(Samples_Matrix);

	for mv=1:5
		L = size(samples{mv},1);
		new_samples{mv} = samples{mv} - repmat(meanValue, L, 1);
	end