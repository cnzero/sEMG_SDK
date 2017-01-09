function Write2Files(data_ch_selected, typename, Channel, folder_name)
	switch typename
		case 'EMG'
			for index=1:length(Channel)
				data_ch_each = data_ch_selected(index, :);
				dlmwrite([folder_name, '\EMG', '\Channel', ...
					      num2str(Channel(index)), '.txt'], ...
					      data_ch_each, ...
					      'precision', '%.10f', 'delimiter', '\n', '-append');
			end
		case 'ACC'
			for index = 1:length(Channel)
				acc_str = {'x', 'y', 'z'};
				for xyz=1 : 3
					data_ch_each = data_ch_selected((index-1)*3 + xyz, :);
					% save to file
					dlmwrite([folder_name, '\ACC', '\Channel', ...
						      num2str(Channel(index)), acc_str{xyz}, '.txt'], ...
						      data_ch_each, ...
						      'precision', '%.10f', 'delimiter', '\n', '-append');
				end
				% Channel3x.txt
				% Channel3y.txt
				% Channel3z.txt
			end
	end