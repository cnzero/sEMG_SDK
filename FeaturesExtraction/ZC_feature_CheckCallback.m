function ZC_feature_CheckCallback(source, eventdata)
	handles = guidata(source);
	%Need a parameter for this feature.
	if get(handles.Check_Feature_ZC, 'Value')
		Cell_Input_Parameter = inputdlg('Please input the parameter:', ... %prompt
										  'ZC', ...%Dialog title
										  1, ... %only one input
										  {'0.0'}); % default value
		if ~isempty(Cell_Input_Parameter)
			handles.Cell_Feature_SelectedName{end+1} = 'Feature_ZC';
			handles.Parameter_ZC = str2num(Cell_Input_Parameter{1});
		end
	else
		handles.Cell_Feature_SelectedName(find( ...
			strcmp(handles.Cell_Feature_SelectedName, ...
				'Feature_ZC')) ) ...
		= [];
	end
	guidata(source, handles);	