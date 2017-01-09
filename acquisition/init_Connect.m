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