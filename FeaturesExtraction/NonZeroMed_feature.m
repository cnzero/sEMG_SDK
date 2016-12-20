% Median value of non-zero value
% -- [NonZeroMed]
function f = NonZeroMed_feature(data)
    data_nonzero = data(find(data ~= 0));
    
    f = median(data_nonzero);