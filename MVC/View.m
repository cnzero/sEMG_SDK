classdef View < handle
	
	properties
		% -- basic parameters on device
		hChannels = [1 2 3 5];
		hPartSelection = {'Upper'}

		hFigure
		% --EMG
		hPanelEMG
		hAxesEMG
		hPlotsEMG

		% --ACC
		% hPanelACC
		% hAxesACC
		% hPlotsACC
		% --guiding pictures to display
		% hPictureReady
		hAxesPictureBed

		% --Buttons
		hButtonStart
		hButtonAnalyze

		modelObj
		controllerObj
	end

	methods
		% --Construct
		function obj = View(modelObj)
			% ===================basic & static figure displays=================
			addpath('..\MaxFigure');addpath('..\pictures');
			obj.hFigure = figure();maximize(obj.hFigure);
			obj.hPanelEMG = uipanel('Parent', obj.hFigure, ...
								  'Units', 'normalized', ...
								  'Position', [0 0 0.5 0.96]);
			% --hAxesEMG, hPlotsEMG
			for ch=1:4
				obj.hAxesEMG(ch) = axes('Parent', obj.hPanelEMG, ...
										'Units', 'normalized', ...
										'Position', [0.04 1-0.23*ch, 0.9 0.18]); 
				obj.hPlotsEMG(ch) = plot(obj.hPanelEMG, 0, '-y', 'LineWidth', 1);
				title(['Channel', num2str(ch)]);
			end

			% --hAxesPictureBed
			obj.hAxesPictureBed = axes('Parent', obj.hFigure, ...
									   'Units', 'normalized', ...
									   'Position', [0.51 0.45 0.48 0.5]);
			hPictureReady = imread('Ready.jpg');
			imshow(hPictureReady, 'Parent', obj.hAxesPictureBed);

			%  --- part selection
			% namePartSelection = {'Body', 'Upper'};
			% hPopupPartSelection = uicontrol('Parent', obj.hFigure, ...
			% 								'Style', 'popupmenu', ...
			% 								'Units', 'normalized', ...
			% 								'Position', [0.52 0.4 0.04 0.02], ...
			% 								'String', namePartSelection);
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
			% --===Model===--subscribe to the event
			obj.modelObj = modelObj;
			obj.modelObj.addlistener('dataEMGChanged', @obj.UpdateAxesEMG);
			obj.modelObj.addlistener('dataEMGChanged', @obj.Write2FilesEMG);

			% --===Controller===--controller to responde
			obj.controllerObj = obj.makeController(); % to new a Controller object

			% --register controller responde functions as view callback functions
			obj.attachToController(obj.controllerObj); 
		end
        
        % -- event [dataEMGChanged] responde function
        function UpdateAxesEMG(obj, source, event)
        	disp('UpdateAxesEMG');

        end
        % -- event [dataEMGChanged] responde function
        function Write2FilesEMG(obj, source, event)
        	disp('Write2FilesEMG...');
        end

        function controllerObj = makeController(obj)
        	controllerObj = [];
        end

        function attachToController(obj, controller)
        end

	end
end

% ---===local functions===---
function data = ReadTCPIPdata(interface)
	bytesReady = interface.BytesAvailable;