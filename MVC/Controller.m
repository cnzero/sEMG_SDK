classdef Controller < handle
	properties
		viewObj
		modelObj

		% pictures changing
		nthPicture = 1
		hTimerPictures
		hPicturesStack = {'Snooze', ...
						  'Grasp', ...
						  'Snooze', ...
						  'Open', ...
						  'Snooze', ...
						  'Index', ...
						  'Snooze', ...
						  'Middle', ...
						  'End'}
	end

	methods
		function obj = Controller(viewObj0, modelObj0)
			obj.viewObj = viewObj0;
			obj.modelObj = modelObj0;
			obj.hTimerPictures = timer('Period', 2, ...
									   'ExecutionMode', 'fixedSpacing', ...
									   'TasksToExecute', length(obj.hPicturesStack), ...
									   'TimerFcn', {@obj.TimerFcn_PicturesChanging});
		end

		% --Callback of widgets in View
		function Callback_ButtonStart(obj, source, eventdata)
			disp('Start Button was pressed...');
			start(obj.hTimerPictures);
		end

		function Callback_ButtonAnalyze(obj, source, eventdata)
			disp('Analyze Button was pressed...');
		end

		function TimerFcn_PicturesChanging(obj, source, eventdata)
			namePicture = obj.hPicturesStack{obj.nthPicture};
			hPicture = imread([namePicture, '.jpg']);
			imshow(hPicture, 'Parent', obj.viewObj.hAxesPictureBed);
			obj.nthPicture = obj.nthPicture + 1;
		end
	end
end