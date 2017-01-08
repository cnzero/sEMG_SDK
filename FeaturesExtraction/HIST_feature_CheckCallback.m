function HIST_feature_CheckCallback(source, eventdata)
	handles = guidata(source);
	%Need two parameters for this feature.
	if get(handles.Check_Feature_HIST, 'value')
		Cell_Input_Parameter = inputdlg({'First parameter:', 'Second parameter:'}, ... %prompt
										  'HIST', ...%Dialog title
										  1, ... %only one input for each prompt
										  {'0.0', '0.0'}); % default value
		if ~isempty(Cell_Input_Parameter)
			handles.Parameter_HIST(1) = str2num(Cell_Input_Parameter{1});
			handles.Parameter_HIST(2) = str2num(Cell_Input_Parameter{2});
			handles.Cell_Feature_SelectedName{end+1} = 'Feature_HIST';
		end
	else
		handles.Cell_Feature_SelectedName(find( ...
			strcmp(handles.Cell_Feature_SelectedName, ...
				'Feature_HIST')) ) ...
		= [];
	end
	guidata(source, handles);