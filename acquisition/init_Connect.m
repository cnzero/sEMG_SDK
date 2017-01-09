% function descriptions:
% basic settings on the device, and acquire handles
% Input:
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
% 			[folder_name]
% 			[plotHandles]
function [interfaceObject, timerRefreshData, RPinfo] = init_Connect(Tinfo, RPinfo)
	global data_EMG, data_ACC;

	data_EMG = [];
	data_ACC = [];

	HOST_IP = '127.0.0.1';
	% common, EMG, ACC, 
	interfaceObject = {tcpip(HOST_IP, 50040), ...
					   tcpip(HOST_IP, 50041, ...    % EMG
						   'InputBufferSize', Tinfo.InputBufferSize, ...
						   'BytesAvailableFcnMode', 'byte', ...
						   'BytesAvailableFcnCount', Tinfo.BytesAvailableFcnCountEMG, ...
						   'BytesAvailableFcn', {@ReadAndPlot, Tinfo, RPinfo}), ...
					   tcpip(HOST_IP, 50042, ...    % ACC
						   'InputBufferSize', Tinfo.InputBufferSize, ...
						   'BytesAvailableFcnMode', 'byte', ...
						   'BytesAvailableFcnCount', Tinfo.BytesAvailableFcnCountACC, ...
						   'BytesAvailableFcn', {@ReadAndPlot, Tinfo, RPinfo}))}; % common
	timerRefreshData = [];
	if RPinfo.DebugPlot == 1
		% timer to refresh the data displaying
		timerRefreshData = timer('Period', .1, ...
				  				 'ExecutionMode', 'fixedSpacing', ...
				  				 'TimerFcn', {@UpdatePlots, RPinfo});

		[figureHandleEMG, plotHandlesEMG] = PlotEMGsettings(interfaceObject, timerRefreshData);
		[figureHandleACC, plotHandlesACC] = PlotACCsettings(interfaceObject, timerRefreshData);
		% both
		% RPinfo.Channel = Channel;
		plotHandles = {plotHandlesEMG, plotHandlesACC};
		RPinfo.plotHandles = plotHandles;

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
							 timerRefreshData); 
		error('Connection error.');
	end