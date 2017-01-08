function LogD_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_LogDetect, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_LogDetect';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_LogDetect')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);