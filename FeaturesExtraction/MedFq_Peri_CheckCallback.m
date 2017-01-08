function MedFq_Peri_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_MedFq_Peri, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_MedFq_Peri';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_MedFq_Peri')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);