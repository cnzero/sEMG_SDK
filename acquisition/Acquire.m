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

	
function clearHandle(a_handle)
	if isvalid(a_handle)
		fclose(a_handle);
		delete(a_handle);
		clear a_handle;
	end
