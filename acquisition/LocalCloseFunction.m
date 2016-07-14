function LocalCloseFunction(figureobj, event, interfaceObject, t)

	% clear up the network objects
	% EMG, ACC, commObject
	for index = 1 : 3
		if isvalid(interfaceObject{index})
			fclose(interfaceObject{index});
			delete(interfaceObject{index});
			clear interfaceObject{index};
		end
	end

	% timer - t
	if isvalid(t)
		stop(t);
		delete(t);
	end

	% close current figure window
	delete(figureobj);
	