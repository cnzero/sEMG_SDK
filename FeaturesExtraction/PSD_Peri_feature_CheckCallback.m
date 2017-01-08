function PSD_Peri_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_PSD_Peri, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_PSD_Peri';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_PSD_Peri')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);