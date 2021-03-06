function TestAcquire()
	% Basic settings
	% struct - Tinfo
	% 				InputBufferSize
	% 				BytesAvailableFcnCountEMG
	% 				BytesAvailableFcnCountACC
	Tinfo.InputBufferSize = 9600;
	Tinfo.BytesAvailableFcnCountEMG = 1728;
	Tinfo.BytesAvailableFcnCountACC = 384;
	% struct - RPinfo
	% 				folder_name
	% 				DebugPlot
	% 				Sensor
	% 				Channel
	% 				Write
	% 				plotHandles
	% 							{1} = plotHandlesEMG
	% 							{2} = plotHandlesACC
	RPinfo.DebugPlot = 1;
	RPinfo.Sensor = 1;
	RPinfo.Channel = [1, 2];
	RPinfo.Write = 1;

	[interfaceObject, timerRefreshData, RPinfo] = Initiate(Tinfo, RPinfo);
	% start
	% drawnow;
	start(timerRefreshData);
	fprintf(interfaceObject, sprintf(['START\r\n\r']));
