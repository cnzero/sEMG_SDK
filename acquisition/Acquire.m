% function description
% 			get the acquiring data online and some parameters settings

% parameters settings
% 			DEBUG:
% 				 1: True, the origin result of Official SDK.
% 				 0: No figures
% 			Sensor:
% 				 1: EMG and ACC are both acquired.
% 				 2: only EMG
% 				 3: only ACC
% 			Channel:
% 				 1xn, row vector, 
% 				 the sequences of selected Channel number.
% 			Write:
% 				 Write the acquired data into a file or not.
% 				 1. Yes
% 				 0. No



function output = Acquire(DEBUG, Sensor, Channel, Write)

	% ----Preparation of Write data into a folder name.---
	if Write
		% newly build a folder with the name of current time
		c = clock;
		global folder_name;
		folder_name = [num2str(c(1)), ... % year
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
	end
	% ============connection to the Delsys device==========
	HOST_IP = '127.0.0.1';

	% connection initialization
	commonObject = tcpip(HOST_IP, 50040);

	switch Sensor
		case 1 % both EMG and ACC
			global data_EMG;
			data_EMG = [];
			global data_ACC;
			data_ACC = [];

			% EMG connection initialization
			interfaceObjectEMG = tcpip(HOST_IP, 50041, ...
									   'InputBufferSize', 6400, ...
									   'BytesAvailableFcnMode', 'byte', ...
									   'BytesAvailableFcnCount', 1728, ...
									   'BytesAvailableFcn', @ReadAndPlotEMG);
			% ACC connection initialization
			interfaceObjectACC = tcpip(HOST_IP, 50042, ...
									   'InputBufferSize', 6400, ...
									   'BytesAvailableFcnMode', 'byte', ...
									   'BytesAvailableFcnCount', 1728, ...
									   'BytesAvailableFcn', @ReadAndPlotACC);	
			% if DEBUG, 
			% figure of data displaying settings
			if DEBUG
				[figureHandleEMG, plotHandlesEMG] = PlotEMGsettings();
				[figureHandleACC, plotHandlesACC] = PlotACCsettings();
				% both
				plotinfo.typename = 'both';
				plotinfo.handles = {plotHandlesEMG, plotHandlesACC};
				% timer to refresh the data displaying
				t = timer('Period', .1, ...
						  'ExecutionMode', 'fixedSpacing', ...
						  'TimerFcn', {@UpdatePlots, plotHandlesEMG});
				start(t);
			end

			% try to connect
			try
				fopen(interfaceObjectEMG);
				fopen(interfaceObjectACC);
				fopen(commonObject);
			catch
				% close communication
				clearHandle(interfaceObjectEMG);
				clearHandle(interfaceObjectACC);
				clearHandle(commonObject);
				% close figure EMG/ACC and timer t
				if DEBUG
					delete(figureHandleEMG);
					delete(figureHandleACC);
					if isvalid(t)
						stop(t);
						delete(t);
					end
				end
				error('connection error: ...
					   please start the Delsys Trigno Control Utility. ...
					   And Try Again.');
		case 2 % only EMG
			global data_EMG;
			data_EMG = [];

			% EMG connection initialization
			interfaceObjectEMG = tcpip(HOST_IP, 50041, ...
									   'InputBufferSize', 6400, ...
									   'BytesAvailableFcnMode', 'byte', ...
									   'BytesAvailableFcnCount', 1728, ...
									   'BytesAvailableFcn', @ReadAndPlotEMG);
			% if DEBUG, 
			% figure of data displaying settings
			if DEBUG
				[figureHandleEMG, plotHandlesEMG] = PlotEMGsettings();
				% EMG
				plotinfo.Channel = Channel;
				plotinfo.typename = 'EMG';
				plotinfo.handles = {plotHandlesEMG};
				% timer to refresh the data displaying
				t = timer('Period', .1, ...
						  'ExecutionMode', 'fixedSpacing', ...
						  'TimerFcn', {@UpdatePlots, plotHandlesEMG});
				start(t);
			end

			% try to connect
			try
				fopen(interfaceObjectEMG);
				fopen(commonObject);
			catch
				% close communication
				clearHandle(interfaceObjectEMG)
				clearHandle(commonObject);
				% close figure EMG and timer t;
				if DEBUG
					delete(figureHandleEMG);
					if isvalid(t)
						stop(t);
						delete(t);
					end
				end
				error('connection error: ...
					   please start the Delsys Trigno Control Utility. ...
					   And Try Again.');
		case 3 % only ACC
			global data_ACC;
			data_ACC = [];

			% ACC connection initialization
			interfaceObjectACC = tcpip(HOST_IP, 50042, ...
									   'InputBufferSize', 6400, ...
									   'BytesAvailableFcnMode', 'byte', ...
									   'BytesAvailableFcnCount', 1728, ...
									   'BytesAvailableFcn', @ReadAndPlotACC);
			% if DEBUG, 
			% figure of data displaying settings
			if DEBUG
				[figureHandleACC, plotHandlesACC] = PlotACCsettings();
				% ACC
				plotinfo.Channel = Channel;
				plotinfo.typename = 'ACC';
				plotinfo.handles = {plotHandlesACC};
				% timer to refresh the data displaying
				t = timer('Period', .1, ...
						  'ExecutionMode', 'fixedSpacing', ...
						  'TimerFcn', {@UpdatePlots, plotinfo});
				start(t);
			end
			% try to connect
			try
				fopen(interfaceObjectACC);
				fopen(commonObject);
			catch
				% close communication
				clearHandle(interfaceObjectACC);
				clearHandle(commonObject);
				% close figure ACC and timer t
				if DEBUG
					delete(figureHandleACC);
					if isvalid(t)
						stop(t);
						delete(t);
					end
				end
				error('connection error: ...
					   please start the Delsys Trigno Control Utility. ...
					   And Try Again.');
	end

	% send commands to start data acquiring streaming...
	fprintf(commonObject, sprintf(['START\r\n\r']));


function ReadAndPlotEMG(interfaceObjectEMG)
	% if less than 27 samples for one channel, wait and check next time.
	% 1728bytes = 27samples x 4bytes/sample x 16channels  
	bytesReady = interfaceObjectEMG.BytesAvailable;
	bytesReady = bytesReady - mod(bytesReady, 1728);
	if (bytesReady == 0)
		return
	end

	% get data from tcpip cache
	data = cast(fread(interfaceObjectEMG, bytesReady), 'uint8');
	data = typecast(data, 'single'); % single == 4 bytes.
	% length must be multi-16channel

	% DEBUG -- plot on 4x4 axes of EMG plot figures.
	if DEBUG
		global data_EMG;
		% global data_EMG is prepared for plot.
		% there is overlap in data_EMG for smothing displaying.
		if(size(data_EMG, 1) < 32832) %32832 = 19 * 1728
			data_EMG = [data_EMG; data];
		else
			data_EMG = [data_EMG(size(data, 1)+1 : size(data_EMG, 1)); data];
		end
	end

	% take samples apart with selected Channel sequences.
	data_ch_all = reshape(data, 16, []); 
	data_ch_selected = data_ch_all(Channel, :);
	% Channel, input parameter, [3, 7, 9, 15] for example
	% data_cha_selected,
	% 4xn
	% data_ch_selected(1, :), for channel 3
	% data_ch_selected(2, :), for channel 7
	% data_ch_selected(3, :), for channel 9
	% data_ch_selected(4, :), for channel 15
	% Just an understandable example. 

	% Write == 1 for Write acquired data in txt files with channel name.
	if Write
		% newly build a folder with the name of EMG
		global folder_name;
		mkdir([folder_name, '\EMG'])
		% there is a text file with name of channel3.txt for example.
		for index = 1:length(Channel)
			data_ch_each = data_ch_selected(index, :);
			% save to file
			dlmwrite([folder_name, '\EMG', '\Channel', ...
				      num2str(Channel(index)), '.txt'], ...
				      data_ch_each, ...
				      'precision', '%.10f', ...
					  'delimiter', '\n', ...
					  '-append');
	end



function ReadAndPlotACC(interfaceObjectACC)
	% if less than 2 samples for one channel, wait and check next time.
	% 384bytes = 2samples x 4bytes/sample x 48channels  
	bytesReady = interfaceObjectACC.BytesAvailable;
	bytesReady = bytesReady - mod(bytesReady, 384);
	if (bytesReady == 0)
		return
	end

	% get data from tcpip cache
	data = cast(fread(interfaceObjectACC, bytesReady), 'uint8');
	data = typecast(data, 'single'); % single == 4 bytes.
	% length must be multi-48channel

	% DEBUG -- plot on 4x4 axes of ACC plot figures.
	if DEBUG
		global data_ACC;
		% global data_ACC is prepared for plot.
		% there is overlap in data_ACC for smothing displaying.
		if(size(data_ACC, 1) < 7296) %7296 = 19 * 384 
			data_ACC = [data_ACC; data];
		else
			data_ACC = [data_ACC(size(data, 1)+1 : size(data_ACC, 1)); data];
		end
	end

	% take samples apart with selected Channel sequences.
	% data  multi-48
	data_ch_all = reshape(data, 48, []); 
	% 48xn
	Channel_transfer = [];
	for index = 1: length(Channel)
		Channel_transfer = [Channel_transfer, ...
							Channel(index)*3 - 2, ...
							Channel(index)*3 - 1, ...
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

	% Write == 1 for Write acquired data in txt files with channel name.
	if Write
		% newly build a folder with the name of ACC
		global folder_name;
		mkdir([folder_name, '\ACC'])
		% ==================================================wrong==========
		% do not need newly-build a folder every time a cache is available.

		% there is a text file with name of channel3.txt for example.
		for index = 1:length(Channel)
			acc_str = {'x', 'y', 'z'};
			for xyz=1 : 3
				data_ch_each = data_ch_selected((index-1)*3 + xyz, :);
				% save to file
				dlmwrite([folder_name, '\ACC', '\Channel', ...
					      num2str(Channel(index)), acc_str{xyz}, '.txt'], ...
					      data_ch_each, ...
					      'precision', '%.10f', ...
						  'delimiter', '\n', ...
						  '-append');
			end
			% Channel3x.txt
			% Channel3y.txt
			% Channel3z.txt
	end


% still need modification with varying input parameters. 
function UpdatePlots(obj, event, plotinfo)
	% structure -- plotinfo
				   % plotinfo.typename = 'both'/'EMG'/'ACC'
				   % plotinfo.handles = {plotHandlesEMG, plotHandlesACC}
				   % 					{plotHandlesEMG}
				   % 					{plotHandlesACC}
	switch plotinfo.typename
	case 'both'
		% EMG plot
		global data_EMG;
		Channel = plotinfo.Channel;
		plotHandlesEMG = plotinfo.handles{1};
		% only update selected Channel responding axes and plot.
		for index = 1 : length(Channel)
			data_ch_plot = data_EMG(index:16:end);
			set(plotHandlesEMG(index), 'Ydata', data_ch_plot);
		end

		% ACC plot
		global data_ACC;
		plotHandlesACC = plotinfo.handles{2};
		% only update selected Channel responding axes and plot
		for index 1 : length(Channel)
			for seq = 1 : 3
				data_ch_plot = data_ACC(Channel(index)*3 - 3 + seq : 48 : end);
				set(plotHandlesACC(Channel(index)*3 - 3 + seq), ...
					'Ydata', data_ch_plot);
			end
		end
	case 'EMG'
		% EMG plot
		global data_EMG;
		Channel = plotinfo.Channel;
		plotHandlesEMG = plotinfo.handles{1};
		% only update selected Channel responding axes and plot.
		for index = 1 : length(Channel)
			data_ch_plot = data_EMG(index:16:end);
			set(plotHandlesEMG(index), 'Ydata', data_ch_plot);
		end
	case 'ACC'
		% ACC plot
		global data_ACC;
		plotHandlesACC = plotinfo.handles{2};
		% only update selected Channel responding axes and plot
		for index 1 : length(Channel)
			for seq = 1 : 3
				data_ch_plot = data_ACC(Channel(index)*3 - 3 + seq : 48 : end);
				set(plotHandlesACC(Channel(index)*3 - 3 + seq), ...
					'Ydata', data_ch_plot);
			end
		end
	end

function clearHandle(a_handle)
	if isvalid(a_handle)
		fclose(a_handle);
		delete(a_handle);
		clear a_handle;
	end
