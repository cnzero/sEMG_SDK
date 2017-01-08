function SSC_feature_CheckCallback(source, eventdata)
	handles = guidata(source);

		%Need a parameter for this feature.
		if get(handles.Check_Feature_SSC, 'Value')
			Cell_Input_Parameter = inputdlg('Please input the parameter:', ... %prompt
											  'SSC', ...%Dialog title
											  1, ... %only one input
											  {'0.0'}); % default value
			if ~isempty(Cell_Input_Parameter)
				handles.Parameter_SSC(1) = str2num(Cell_Input_Parameter{1});
				handles.Cell_Feature_SelectedName{end+1} = 'Feature_SSC';
			end
		else
			handles.Cell_Feature_SelectedName(find( ...
				strcmp(handles.Cell_Feature_SelectedName, ...
					'Feature_SSC')) ) ...
			= [];
		end
		guidata(source, handles);