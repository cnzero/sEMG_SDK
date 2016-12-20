%[WL-Waveform Length] feature
function feature = WL_feature(data_TimeWindow)
	feature = sum(abs(diff(data_TimeWindow)))/length(data_TimeWindow);
