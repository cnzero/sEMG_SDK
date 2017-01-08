function PSD_Burg_feature_CheckCallback(source, eventdata)
	handles = guidata(source);
	%Need a parameter for this feature.
	if get(handles.Check_Feature_PSD_Burg, 'value')
		Cell_Input_Parameter = inputdlg('Please input the parameter:', ... %prompt
										  'PSD_Burg', ...%Dialog title
										  1, ... %only one input
										  {'0.0'}); % default value
		if ~isempty(Cell_Input_Parameter)
			handles.Parameter_PSD_Burg = str2num(Cell_Input_Parameter{1});
			handles.Cell_Feature_SelectedName{end+1} = 'Feature_PSD_Burg';
		end
	else
		handles.Cell_Feature_SelectedName(find( ...
			strcmp(handles.Cell_Feature_SelectedName, ...
				'Feature_PSD_Burg')) ) ...
		= [];
	end
	guidata(source, handles);