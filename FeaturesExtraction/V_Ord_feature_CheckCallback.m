function V_Ord_feature_CheckCallback(source, eventdata)
	handles = guidata(source);
	%Need a parameter for this feature.
	if get(handles.Check_Feature_V_Ord, 'Value')
		Cell_Input_Parameter = inputdlg('Please input the parameter:', ... %prompt
										  'V_Ord', ...%Dialog title
										  1, ... %only one input
										  {'1'}); % default value
		if ~isempty(Cell_Input_Parameter)
			handles.Cell_Feature_SelectedName{end+1} = 'Feature_V_Ord';
			handles.Parameter_V_Ord = str2num(Cell_Input_Parameter{1});
		end
	else
		handles.Cell_Feature_SelectedName(find( ...
			strcmp(handles.Cell_Feature_SelectedName, ...
				'Feature_V_Ord')) ) ...
		= [];
	end
	guidata(source, handles);