function IAV_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_IAV, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_IAV';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_IAV')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);