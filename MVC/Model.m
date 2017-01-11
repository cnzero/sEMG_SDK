classdef Model <  handle
	properties
		interfaceObjects = {}
		dataEMG = []
		dataACC = []
	end

	events
		dataEMGChanged
		dataACCChanged
		picturesChanged
	end

	methods
		% Construct
		function obj = Model()
			HOST_IP = '127.0.0.1';
			obj.interfaceObjects ={...
								   tcpip(HOST_IP, 50040), ...   % common
					   			   tcpip(HOST_IP, 50041, ...    % EMG
								   'InputBufferSize', 6400, ...
								   'BytesAvailableFcnMode', 'byte', ...
								   'BytesAvailableFcnCount', 1728, ...
								   'BytesAvailableFcn', {@obj.NotifyEMG}) ...
								   };


		end
		function Start(obj)
			try
				fopen(obj.interfaceObjects{1});
				fopen(obj.interfaceObjects{2});
				fprintf(obj.interfaceObjects{1}, sprintf(['START\r\n\r']));
			catch
				error('Connection error.');
			end
		end
		function Stop(obj)
			try
				fclose(obj.interfaceObjects{1});  % common
				fclose(obj.interfaceObjects{2});  % EMG
			catch
				error('Dis-connection error');
			end
		end
		% -- events trigger
		function NotifyEMG(obj, source, event)
			% --acquire [dataEMG] from tcpip cache 
			% ---===EMG
			% --interfaceObjects{2}
			% --InputBufferSize = 6400
			% --BytesAvailableFcnMode, byte
			% --BytesAvailableFcnCount, 1728
			% --BytesAvailableFcn, model.NotifyEMG
			% --debug what's the number of [BytesAvailable]
			bytesReady = obj.interfaceObjects{2}.BytesAvailable;
			bytesReady = bytesReady - mod(bytesReady, obj.interfaceObjects{2}.BytesAvailableFcnCount);
			if (bytesReady == 0)
				return
			end
			data = cast(fread(obj.interfaceObjects{2}, bytesReady), 'uint8');
			obj.dataEMG = typecast(data, 'single');

			% ---=== notify
			obj.notify('dataEMGChanged');
		end
		% function NotifyACC(obj)
		% 	% --acquire [dataACC] from tcpip cache 
		% 	% ---===ACC
		% 	% --interfaceObjects{3}
		% 	% --InputBufferSize = 6400
		% 	% --BytesAvailableFcnMode, byte
		% 	% --BytesAvailableFcnCount, 384
		% 	% --BytesAvailableFcn, model.NotifyACC
		% 	% --debug what's the number of [BytesAvailable]
		% 	bytesReady = obj.interfaceObjects{3}.BytesAvailable
		% 	bytesReady = bytesReady - mod(bytesReady, obj.interfaceObjects{3}.BytesAvailableFcnCount);
		% 	if (bytesReady == 0)
		% 		return
		% 	end
		% 	data = cast(fread(obj.interfaceObjects{3}, bytesReady), 'uint8');
		% 	dataACC = typecast(data, 'single');

		% 	% ---=== notify
		% 	obj.notify('dataACCChanged');
		% end
	end
end