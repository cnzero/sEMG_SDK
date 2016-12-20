% Cepstrum coefficients, Ceps
% Equation(1-11) in Xiong's Ph.D article.
function feature = Ceps_feature(data_TimeWindow, order)
	arc = getar_lpcfeat(data_TimeWindow, order);
	%size: orderx1
	
	feature(1, 1) = -arc(1);
	for l=2:order
		total = 0;
		for j=1:l-1
			total = total + (1 - j/l)*arc(j)*feature(1, l-j);
			feature(1, l) = -arc(l) - total;
		end
	end


function feat = getar_lpcfeat(x,order)                %其中feat中参数的排列顺序是：[a1; a2; a3; a4]
	cur_xlpc = real(lpc(x,order)');
	feat = -cur_xlpc(2:(order+1),:);
%size: orderx1
	   