% function description
% 			get the acquiring data online and some parameters settings

% parameters settings
% -----Tinfo---
    %			InputBufferSize = 6400; [default]
    %			BytesAvailableFcnCountEMG = 1728; [default]
    %			BytesAvailableFcnCountACC = 384; [default]

% -----RPinfo---
	% 			DebugPlot:
	% 				 1: True, the origin result of Official SDK.
	% 				 0: No figures
	% 			Sensor:
	% 				 1: EMG and ACC are both acquired.
	% 				 2: only EMG
	% 				 3: only ACC
	% 			Channel:
	% 				 1xn, row vector, 
	% 				 	the sequences of selected Channel number.
	% 			Write:
	% 				 	Write the acquired data into a file or not.
	% 				 1. Yes
	% 				 0. No
	%  parameters get value during running.
	% 			folder_name
	% 			plotHandles
function [commonObject, t, RPinfo] = Initiate(Tinfo, RPinfo)
	% check of input parameter
	% struct - Tinfo
	% 				InputBufferSize
	% 				BytesAvailableFcnCountEMG
	% 				BytesAvailableFcnCountACC

	% struct - RPinfo
	% 				folder_name
	% 				DebugPlot
	% 				Sensor
	% 				Channel
	% 				Write
	% 				plotHandles
	% 							{1} = plotHandlesEMG
	% 							{2} = plotHandlesACC
	% newly build a folder with the name of current time
	folder_name = init_Foler(RPinfo.Write);
	RPinfo.folder_name = folder_name;

	% ============connection to the Delsys device==========
	[interfaceObject, t, RPinfo] = init_Connect(Tinfo, RPinfo);

	% send commands to start data acquiring streaming...
	commonObject = interfaceObject{3};


function folder_name = init_Foler(Write)
	folder_name = [];
	if Write == 1
		c = clock;
		folder_name = [folder_name, ...
					   num2str(c(1)), ... % year
		               '_', ...
		               num2str(c(2)), ... % month
		               '_', ...
		               num2str(c(3)), ... % day
		               '_', ...
		               num2str(c(4)), ... % hour
		               '_', ...
		               num2str(c(5)), ... % minute
		               '_', ...
		               num2str(fix(c(6)))]; % second
		% for example, run this code at 2016-07-13 10:13:30s
		% folder_name, 2016_07_13_10_13_30
		mkdir(folder_name);
		mkdir([folder_name, '\EMG']);
		mkdir([folder_name, '\ACC']);
	end
function [interfaceObject, t, RPinfo] = init_Connect(Tinfo, RPinfo)
	global data_EMG;
	global data_ACC;

	data_EMG = [];
	data_ACC = [];

	HOST_IP = '127.0.0.1';
	% EMG, ACC, common
	interfaceObject = {tcpip(HOST_IP, 50041, ...    % EMG
						   'InputBufferSize', Tinfo.InputBufferSize, ...
						   'BytesAvailableFcnMode', 'byte', ...
						   'BytesAvailableFcnCount', Tinfo.BytesAvailableFcnCountEMG, ...
						   'BytesAvailableFcn', {@ReadAndPlot, Tinfo, RPinfo}), ...
					   tcpip(HOST_IP, 50042, ...    % ACC
						   'InputBufferSize', Tinfo.InputBufferSize, ...
						   'BytesAvailableFcnMode', 'byte', ...
						   'BytesAvailableFcnCount', Tinfo.BytesAvailableFcnCountACC, ...
						   'BytesAvailableFcn', {@ReadAndPlot, Tinfo, RPinfo}), ...
					   tcpip(HOST_IP, 50040)};      % common
	% RPinfo.DebugPlot for data displaying in figures
	if RPinfo.DebugPlot == 1
		% timer to refresh the data displaying
		t = timer('Period', .1, ...
				  'ExecutionMode', 'fixedSpacing');

		[figureHandleEMG, plotHandlesEMG] = PlotEMGsettings(interfaceObject, t);
		[figureHandleACC, plotHandlesACC] = PlotACCsettings(interfaceObject, t);
		% both
		% RPinfo.Channel = Channel;
		plotHandles = {plotHandlesEMG, plotHandlesACC};
		RPinfo.plotHandles = plotHandles;

		% timer to refresh the data displaying
		% set(t, 'TimerFcn', {@UpdatePlots, RPinfo})
		t.TimerFcn = {@UpdatePlots, RPinfo};

		% start(t);
	end
	try
		fopen(interfaceObject{1});
		fopen(interfaceObject{2});
		fopen(interfaceObject{3});
	catch
		LocalCloseFunction(1, 1, ...
							{interfaceObject, ...
							 figureHandleEMG, ...
							 figureHandleACC}, ...
							 t); 
		error('Connection error.');
	end

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
	
				
function data_type = Overlap(data_type, width, data)
	if (size(data_type, 1) < width)
		data_type = [data_type; ...
					 data];
	else
		data_type = [data_type(size(data, 1)+1: ...
			         size(data_type,1)); ...
					 data];
	end	