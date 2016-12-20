% [MAV-Mean Absolute Value] feature
function feature = MAV_feature(data_TimeWindow)
	feature = mean(abs(data_TimeWindow));
