function MAV_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_MAV, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_MAV';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_MAV')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);