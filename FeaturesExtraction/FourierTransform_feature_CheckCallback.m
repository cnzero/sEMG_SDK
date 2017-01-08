function FourierTransform_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

	if get(handles.Check_Feature_FourierTransf, 'Value')
		handles.Cell_Feature_SelectedName{end+1} = 'Feature_FourierTransf';
	else
		handles.Cell_Feature_SelectedName( ...
			find( strcmp(handles.Cell_Feature_SelectedName, ...
			'Feature_FourierTransf')) ) ...
		= [];
	end
	%Update handles.
	guidata(source, handles);