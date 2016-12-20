% ARC, Auto Regression Model coefficients.
% the first coefficient of ARC with order four.
function feature = ARC_feature(x)  
	order = 4;              
	cur_xlpc = real(lpc(x,order)');
	feature = -cur_xlpc(order+1,:);
   