%[SSC-Slope Sign Change] feature
function feature = SSC_feature(data_TimeWindow, DeadZone)
	data_size = length(data_TimeWindow);
	feature = 0;

	if data_size == 0
		feature = 0;
	else
		for j=3:data_size
			difference1 = data_TimeWindow(j-1) - data_TimeWindow(j-2);
			difference2 = data_TimeWindow(j-1) - data_TimeWindow(j);
			Sign = difference1 * difference2;
			if Sign > 0
				if abs(difference1)>DeadZone || abs(difference2)>DeadZone
					feature = feature + 1;
				end
			end
		end
		feature = feature/data_size;
	end