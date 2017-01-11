classdef Controller < handle
	properties
		viewObj
		modelObj
	end

	methods
		function obj = Controller(viewObj0, modelObj0)
			obj.viewObj = viewObj0;
			obj.modelObj = modelObj0;
		end

		% --Callback of widgets in View
		function Callback_ButtonStart(obj, source, eventdata)
			disp('Start Button was pressed...');
			start(obj.viewObj.hTimerPictures);
		end

		function Callback_ButtonAnalyze(obj, source, eventdata)
			disp('Analyze Button was pressed...');
		end

		function TimerFcn_PicturesChanging(obj, source, eventdata)
			namePicture = obj.viewObj.hPicturesStack{obj.viewObj.nthPicture};
			hPicture = imread([namePicture, '.jpg']);
			imshow(hPicture, 'Parent', obj.viewObj.hAxesPictureBed);
			obj.viewObj.nthPicture = obj.viewObj.nthPicture + 1;
		end
	end
end