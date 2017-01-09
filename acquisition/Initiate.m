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
% 			[folder_name]
% 			[plotHandles]
function [interfaceObject, timerRefreshData, RPinfo] = Initiate(Tinfo, RPinfo)
	% newly build a folder with the name of current time
	RPinfo.folder_name = init_Folder(RPinfo.Write);
	 
	% ============connection to the Delsys device==========
	[interfaceObject, timerRefreshData, RPinfo] = init_Connect(Tinfo, RPinfo);











		

	
				
