% Index of NonZeroMed (Ind)

function f = NonZeroMedIndex_feature(data)
    data_nonzero = data(find(data ~=0));
    data_sorted = sort(data_nonzero, 'ascend');
    
    L = length(data_sorted);
    L2 = (fix(L/2));
    
    if mod(L, 2)==1
        median_value = median(data_sorted);
        f_logic = data_sorted==median_value;
        median_index = find(f_logic);
    else
        median_value = median(data_sorted);
        median_index = L2;
        % Explanation
        % Need more modification on such an extracted feature.
    end
    
    f = median_index;