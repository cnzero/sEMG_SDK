function MeaFq_Burg_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_MeaFq_Burg, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_MeaFq_Burg';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_MeaFq_Burg')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);