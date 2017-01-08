function WAMP_feature_CheckCallback(source, eventdata)
	handles = guidata(source);
	%Need a parameter for this feature.
	if get(handles.Check_Feature_WAMP, 'Value')
		Cell_Input_Parameter = inputdlg('Please input the parameter:', ... %prompt
										  'WAMP', ...%Dialog title
										  1, ... %only one input
										  {'0.0'}); % default value
		if ~isempty(Cell_Input_Parameter)
			handles.Cell_Feature_SelectedName{end+1} = 'Feature_WAMP';
			handles.Parameter_WAMP = str2num(Cell_Input_Parameter{1});
		end
	else
		handles.Cell_Feature_SelectedName(find( ...
			strcmp(handles.Cell_Feature_SelectedName, ...
				'Feature_WAMP')) ) ...
		= [];
	end
	guidata(source, handles);