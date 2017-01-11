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
			% ===================basic & static figure displays=================

			%  --== including handles
			obj.modelObj = modelObj;
			% --===Controller===--controller to responde
			obj.controllerObj = Controller(obj, obj.modelObj);

			% --===Model===--subscribe to the event
			obj.modelObj.addlistener('dataEMGChanged', @obj.UpdateAxesEMG);
			obj.modelObj.addlistener('dataEMGChanged', @obj.Write2FilesEMG);

			% --register controller responde functions as view Callback functions
			obj.attachToController(obj.controllerObj); 
		end
        

        function attachToController(obj, controller)
        	set(obj.hButtonStart, 'Callback', @controller.Callback_ButtonStart);
        	set(obj.hButtonAnalyze, 'Callback', @controller.Callback_ButtonAnalyze);
        end

        function Init_Folder(obj)
        	c = clock;
        	folder_name	= [];
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
			mkdir(['..\Users\',folder_name]);
			mkdir(['..\Users\',folder_name, '\EMG']);
			mkdir(['..\Users\',folder_name, '\ACC']);
			obj.folder_name = ['..\Users\',folder_name];
        end
        % -- event [dataEMGChanged] responde function
        function UpdateAxesEMG(obj, source, event)
        	disp('UpdateAxesEMG...');
        	% if(length(obj.dataAxesEMG) < 32832)
        	% 	obj.dataAxesEMG = [obj.dataAxesEMG; ...
        	% 					   obj.modelObj.dataEMG];
        	% else
        	% 	obj.dataAxesEMG = [obj.dataAxesEMG(length(obj.modelObj.dataEMG)+1:end); ...
        	% 					   obj.modelObj.dataEMG];
        	% end
        	% % --==seperate [obj.dataAxesEMG] into 16-Channel-Axes
        	% for ch=1:length(obj.hPlotsEMG)
        	% 	data_ch = obj.dataAxesEMG(ch:16:end);
        	% 	% set(obj.hPlotsEMG(ch), 'Ydata', data_ch);
        	% 	plot(obj.hAxesEMG(ch), data_ch);
        	% 	drawnow;
        	% end
        	% ---=== It costs much time to refresh axes in this way.
        end
        % -- event [dataEMGChanged] responde function
        function Write2FilesEMG(obj, source, event)
        	% disp('Write2FilesEMG...');
        	% --==write [obj.modelObj.dataEMG] into txt file with appending format.
        	for index=1:length(obj.hChannels)
        		data_index = obj.modelObj(obj.hChannels(index):16:end);
        		% --save to .txt file
        		dlmwrite([obj.folder_name, '\EMG', ...
        				  '\Channel', num2str(obj.hChannels(index), '.txt')], ...
        				  data_index, ...
        				  'precision', '%.10f', 'delimiter', '\n', '-append');	
        	end
        end

	end
end
