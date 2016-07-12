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
				[figureHandleEMG, ~] = PlotEMGsettings();
				[figureHandleACC, ~] = PlotACCsettings();
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
				[figureHandleEMG, ~] = PlotEMGsettings();
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
				[figureHandleACC, ~] = PlotACCsettings();
				% timer to refresh the data displaying
				t = timer('Period', .1, ...
						  'ExecutionMode', 'fixedSpacing', ...
						  'TimerFcn', {@UpdatePlots, plotHandlesACC});
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
		% newly build a folder with the name of current time
		c = clock;
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
		mkdir(folder_name);
		% newly build a folder with the name of EMG/ACC
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

























function clearHandle(a_handle)
	if isvalid(a_handle)
		fclose(a_handle);
		delete(a_handle);
		clear a_handle;
	end
