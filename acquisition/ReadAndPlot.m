function ReadAndPlot(obj, event, Tinfo, RPinfo)
	switch RPinfo.Sensor
		case 1 % both
			data_ch_selected_EMG = UpdateData(obj, RPinfo, 'EMG');
			data_ch_selected_ACC = UpdateData(obj, RPinfo, 'ACC');
		case 2 % EMG
			data_ch_selected_EMG = UpdateData(obj, RPinfo, 'EMG');
		case 3 % ACC
			data_ch_selected_ACC = UpdateData(obj, RPinfo, 'ACC');
	end
	% the latest samples are exposed here...
	% modelling code start from here...