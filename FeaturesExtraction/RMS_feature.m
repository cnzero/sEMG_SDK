% [RMS-Root Mean Square]
function feature = RMS_feature(data_TimeWindow)
	feature = sqrt(mean(data_TimeWindow.^2));
