function data_ch_selected = UpdateData(obj, RPinfo, typename)
	if ( obj.BytesAvailable < obj.BytesAvailableFcnCount)
		data_ch_selected = [];
	else
		% get data from tcpip cache
		data = cast(fread(obj, obj.BytesAvailable), 'uint8');
		data = typecast(data, 'single'); % single == 4 bytes.
		% EMG, multi-16
		% ACC, multi-48
			
		if (RPinfo.DebugPlot == 1) % update global data_EMG/ACC for plot
			switch typename
			case 'EMG'
				global data_EMG;
				% Overlap for smooth displaying
				data_EMG = Overlap(data_EMG, 19*obj.BytesAvailableFcnCount, data);

			case 'ACC'
				global data_ACC;
				% Overlap for smooth displaying
				data_ACC = Overlap(data_ACC, 19*obj.BytesAvailableFcnCount, data);
			end 
		end
		
		% Channel data extracted from data
		Channel = RPinfo.Channel;
		switch typename
			case 'EMG'
				data_ch_all = reshape(data, 16, []);
				data_ch_selected = data_ch_all(RPinfo.Channel, :);
				% Channel, input parameter, [3, 7, 9, 15] for example
				% data_ch_selected,
				% 4xn
				% data_ch_selected(1, :), for channel 3
				% data_ch_selected(2, :), for channel 7
				% data_ch_selected(3, :), for channel 9
				% data_ch_selected(4, :), for channel 15
				% Just an understandable example. 
				Write2Files(data_ch_selected, 'EMG', Channel, RPinfo.folder_name)
			case 'ACC'
				data_ch_all = reshape(data, 48, []);
				Channel_transfer = [];
				for index = 1:length(Channel)
					Channel_transfer = [Channel_transfer, ...
										Channel(index)*3-2, ...
										Channel(index)*3-1, ...
										Channel(index)*3];
				end
				% Channel, 		   [3,        7]
				% Channel_transfer [7, 8, 9,  19, 20, 21]
				data_ch_selected = data_ch_all(Channel_transfer, :);
				% Channel, input parameter, [3, 7] for example
				% channel 3
				% data_ch_selected(1, :), for channel 3_x
				% data_ch_selected(2, :), for channel 3_y
				% data_ch_selected(3, :), for channel 3_z
				% channel 7
				% data_ch_selected(4, :), for channel 7_x
				% data_ch_selected(5, :), for channel 7_y
				% data_ch_selected(6, :), for channel 7_z
				% Just an understandable example. 
				if RPinfo.Write
					Write2Files(data_ch_selected, 'ACC', Channel, RPinfo.folder_name);
				end
		end
	end