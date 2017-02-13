% function description:
% 		find the nearest samples label
% Inputs:
% 		[samepleMatrix], 1xn, a sample matrix
% 		[reductCenters], every row 1xd is a clustering center position
% 		[reductMatrix], dimension-reduction matrix, nxd
% Output:
% 		[nLabel], number of nth row of [reductCenters]
% 				  that is the nearest 2-norm result.
function nLabel = NearestDistance(sampleMatrix, reductCenters, reductMatrix)
	sample = sampleMatrix(1, :);
	reductSample = sample * reductMatrix;
	for j=1:size(reductCenters, 1)
		Distance(j) = norm(reductSample-reductCenters(j, :));
	end
	D_sort = sort(Distance, 'descend');
	nearest = D_sort(end);
	nLabel = find(Distance==nearest);
end