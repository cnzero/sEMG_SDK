classdef View < handle
	properties
		hChannels = [1 2]
		hPartSelection = {'Upper'}

		hFigure
		hAxesEMG = []
		hPlotsEMG = []
		hPanelEMG
		folder_name = []

		% --guiding pictures to display
		% hPictureReady
		hAxesPictureBed

		% --Buttons
		hButtonStart
		hButtonAnalyze

		modelObj
		controllerObj

		dataAxesEMG = []

		% flag 
		flagAxesRefreshing = 1
		flagEMGWrite2Files = 0
		% ratioAxesRefreshing = 0

		% Split lines
		hTextSplitLines
		hEditSplitLines
		hButtonSplitLines
		hSplitLines = []
		xSplitLines

		hButtonOnlineControl
	end
	methods
		% --Construct
		function obj = View(modelObj)
			% ===================basic & static figure displays=================
			addpath('..\MaxFigure');addpath('..\pictures');addpath('..\Users');
			obj.Init_Folder();
			obj.hFigure = figure();maximize(obj.hFigure);
			obj.hPanelEMG = uipanel('Parent', obj.hFigure, ...
								  'Units', 'normalized', ...
								  'Position', [0 0 0.5 0.96]);
			% --hAxesEMG, hPlotsEMG
			nChannels = length(obj.hChannels);
			dWidth= 0.95/nChannels;
			for ch=1:nChannels
				obj.hAxesEMG(ch) = axes('Parent', obj.hPanelEMG, ...
										'Units', 'normalized', ...
										'Position', [0.04 1- dWidth *ch, 0.98 dWidth*0.9]); 
				obj.hPlotsEMG(ch) = plot(obj.hPanelEMG, 0, '-y', 'LineWidth', 1);
				title(['Channel', num2str(ch)]);
			end

			% --hAxesPictureBed
			obj.hAxesPictureBed = axes('Parent', obj.hFigure, ...
									   'Units', 'normalized', ...
									   'Position', [0.51 0.45 0.48 0.5]);
			hPictureReady = imread('Ready.jpg');
			imshow(hPictureReady, 'Parent', obj.hAxesPictureBed);

			obj.hButtonStart = uicontrol('Parent', obj.hFigure, ...
									 	 'Style', 'pushbutton', ...
									 	 'Units', 'normalized', ...
									 	 'Position', [0.8 0.35 0.1 0.05], ...
									 	 'FontSize', 16, ...
									 	 'String', 'Start');
			obj.hButtonAnalyze = uicontrol('Parent', obj.hFigure, ...
										   'Style', 'pushbutton', ...
										   'Units', 'normalized', ...
										   'Position', [0.8 0.25 0.1 0.05], ...
										   'FontSize', 16, ...
										   'String', 'Analyze');
			% Split lines
			obj.hTextSplitLines = uicontrol('Parent', obj.hFigure, ....
											'Style', 'Text', ....
											'Units', 'normalized', ...
											'Position', [0.52, 0.4 0.13 0.04], ...
											'FontSize', 14, ...
											'String', 'Input Split Lines Positions', ...
											'Visible', 'off');
			obj.hEditSplitLines = uicontrol('Parent', obj.hFigure, ...
											'Style', 'Edit', ...
											'Units', 'normalized', ...
											'Position', [0.52 0.38 0.43 0.03], ...
											'FontSize', 14, ...
											'Visible', 'off');
			obj.hButtonSplitLines = uicontrol('Parent', obj.hFigure, ...
											  'Style', 'pushbutton', ...
											  'Units', 'normalized', ...
											  'Position', [0.52 0.33 0.05 0.04], ...
											  'String', 'Enter', ...
											  'FontSize', 16, ...
											  'Visible', 'off');
			obj.hButtonOnlineControl = uicontrol('Parent', obj.hFigure, ...
											     'Style', 'pushbutton', ...
											     'Units', 'normalized', ...
											     'Position', [0.52 0.28 0.05 0.04], ...
											     'String', 'OnlineControl', ...
											     'FontSize', 16);
			% ===================basic & static figure displays=================

			%  --== including handles
			obj.modelObj = modelObj;
			% --===Controller===--controller to responde
			obj.controllerObj = Controller(obj, obj.modelObj);

			% --===Model===--subscribe to the event
			obj.modelObj.addlistener('eventEMGChanged', @obj.UpdateAxesEMG);
			obj.modelObj.addlistener('eventEMGChanged', @obj.Write2FilesEMG);

			% --register controller responde functions as view Callback functions
			obj.attachToController(obj.controllerObj); 

			% --Start to open the hardware --Model Aquisition
			% debug to cancle start hardware acquisition
			obj.modelObj.Start();
		end
        

        function attachToController(obj, controller)
        	set(obj.hButtonStart, 'Callback', @controller.Callback_ButtonStart);
        	set(obj.hButtonAnalyze, 'Callback', @controller.Callback_ButtonAnalyze);
        	set(obj.hEditSplitLines, 'Callback', @controller.Callback_EditSplitLines);
        	set(obj.hButtonSplitLines, 'Callback', @controller.Callback_ButtonSplitLines);
        	set(obj.hButtonOnlineControl, 'Callback', @controller.Callback_ButtonOnlineControl);
        end

        function Init_Folder(obj)
        	c = clock;
        	folder_name	= [];
			folder_name = [folder_name, ...
						   num2str(c(1)), ... % year
			               num2str(c(2)), ... % month
			               num2str(c(3)), ... % day
			               num2str(c(4)), ... % hour
			               num2str(c(5)), ... % minute
			               num2str(fix(c(6)))]; % second
			% for example, run this code at 2016-07-13 10:13:30s
			% folder_name, 2016_07_13_10_13_30
			mkdir(['Users\',folder_name]);
			mkdir(['Users\',folder_name, '\EMG']);
			mkdir(['Users\',folder_name, '\ACC']);
			obj.folder_name = ['Users\',folder_name];
        end
        % -- event [dataEMGChanged] responde function
        function UpdateAxesEMG(obj, source, event)
        	if obj.flagAxesRefreshing == 1
        		% disp('UpdateAxesEMG...');
	        	if(length(obj.dataAxesEMG) < 32832)
	        		obj.dataAxesEMG = [obj.dataAxesEMG; ...
	        						   obj.modelObj.dataEMG];
	        	else
	        		obj.dataAxesEMG = [obj.dataAxesEMG(length(obj.modelObj.dataEMG)+1:end); ...
	        						   obj.modelObj.dataEMG];
	        	end
	        	% --==seperate [obj.dataAxesEMG] into 16-Channel-Axes
	        	for ch=1:length(obj.hPlotsEMG)
	        		data_ch = obj.dataAxesEMG(ch:16:end);
	        		% set(obj.hPlotsEMG(ch), 'Ydata', data_ch);
	        		plot(obj.hAxesEMG(ch), data_ch);
	        		drawnow;
	        	end
	        	% ---=== It costs much time to refresh axes in this way.
	        end
        end
        % -- event [dataEMGChanged] responde function
        function Write2FilesEMG(obj, source, event)
        	% disp('Write2FilesEMG...');
        	% --==write [obj.modelObj.dataEMG] into txt file with appending format.
        	if obj.flagEMGWrite2Files == 1
	        	for index=1:length(obj.hChannels)
	        		data_index = obj.modelObj.dataEMG(obj.hChannels(index):16:end);
	        		% --save to .txt file
	        		dlmwrite([obj.folder_name, '\EMG', ...
	        				  '\Channel', num2str(obj.hChannels(index)), '.txt'], ...
	        				  data_index, ...
	        				  'precision', '%.8f', 'delimiter', '\n', '-append');	
	        	end
	        end
        end % ---=== Write2FilesEMG()

	end
end
