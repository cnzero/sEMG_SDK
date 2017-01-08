function RMS_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_WL, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_WL';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_WL')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);