function feature = LogD_feature(data_TimeWindow)
	feature = exp(mean(log(abs(data_TimeWindow))));