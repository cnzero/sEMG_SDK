function PSD_Welch_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_PSD_Welch, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_PSD_Welch';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_PSD_Welch')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);