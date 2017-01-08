function MeaFq_Peri_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_MeaFq_Peri, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_MeaFq_Peri';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_MeaFq_Peri')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);