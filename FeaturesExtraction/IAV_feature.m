% $x^2+e^{\pi i}$ 
%[IAV-Integrated Absolute Value] feature
function feature = IAV_feature(data)
	feature = sum(abs(data))/length(data);
