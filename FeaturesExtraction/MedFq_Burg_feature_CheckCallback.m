function MedFq_Burg_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_MedFq_Burg, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_MedFq_Burg';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_MedFq_Burg')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);