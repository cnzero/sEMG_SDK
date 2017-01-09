function UpdatePlots(obj, event, RPinfo)
		global data_EMG;
		global data_ACC;
		Channel = RPinfo.Channel;
		plotHandlesEMG = RPinfo.plotHandles{1};
		plotHandlesACC = RPinfo.plotHandles{2};

		% EMG plot refresh
		if (~isempty(data_EMG))
			for index = 1 : length(Channel)
				data_ch_plot = data_EMG(index:16:end);
				set(plotHandlesEMG(index), 'Ydata', data_ch_plot);
			end
			drawnow;
		end
		% ACC plot refresh 
		if (~isempty(data_ACC))
			for index = 1 : length(Channel)
				for seq = 1 : 3
					data_ch_plot = data_ACC(Channel(index)*3 - 3 + seq : 48 : end);
					set(plotHandlesACC(Channel(index)*3 - 3 + seq), ...
						'Ydata', data_ch_plot);
				end
			end
			drawnow;
		end
		% You should test how long this procedure cost.