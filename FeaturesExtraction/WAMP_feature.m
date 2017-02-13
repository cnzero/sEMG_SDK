%-[WA-Willison Amplitude] feature
function feature = WAMP_feature(data_TimeWindow)
	Threshold = 0;
	data_size = length(data_TimeWindow);
	feature = 0;
	if data_size == 0
		feature = 0;
	else
		for i=2:data_size
			difference = data_TimeWindow(i) - data_TimeWindow(i-1);
			if abs(difference)>Threshold
				feature = feature + 1;
			end
		end
		feature = feature/data_size;
	end