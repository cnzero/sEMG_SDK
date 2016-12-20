clear,close all,clc
a = [1 2 2 2 4 4 4];
b = a(find(a ~=0));
c = sort(b, 'ascend'); % ascend(default), descend

L = length(c);
L2 = int16(fix(L/2));
if mod(L,2)==1
    disp('even');
    median_value = c(L2+1)
    c_logic = c==median_value;
    find(c_logic);
else
    disp('odd');
%     median_value = mean([c(L2), c(L2+1)])
    median_value = median(c)
    median_index = find(c, median_value)
    if isempty(median_index)
        median_index = L2
    end
end