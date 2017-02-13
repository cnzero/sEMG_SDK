classdef Model <  handle
	properties
		interfaceObjects = {}
		dataEMG = []

		% Classification modelling parameters
		lastRealtimeData = []
		featuresCell = {'SSC', 'ZC', 'WAMP', 'IAV', 'MAV'}
		LW = 128  % Length of sliding Window
		LI = 64   % Length of increasing Window
		LDA_centers
		LDA_matrix
	end

	events
		eventEMGChanged
	end

	methods
		% Construct
		function obj = Model()
			HOST_IP = '127.0.0.1';
			obj.interfaceObjects ={...
								   tcpip(HOST_IP, 50040), ...   % common
					   			   tcpip(HOST_IP, 50041, ...    % EMG
								   'InputBufferSize', 64000, ...
								   'BytesAvailableFcnMode', 'byte', ...
								   'BytesAvailableFcnCount', 1728*5, ...
								   'BytesAvailableFcn', {@obj.NotifyEMG}) ...
								   };
			
		end
		
		% -- events trigger
		function NotifyEMG(obj, source, event)
			% --acquire [dataEMG] from tcpip cache 
			% ---===EMG
			bytesReady = obj.interfaceObjects{2}.BytesAvailable;
			bytesReady = bytesReady - mod(bytesReady, obj.interfaceObjects{2}.BytesAvailableFcnCount);
			if (bytesReady == 0)
				return
			end
			data = cast(fread(obj.interfaceObjects{2}, bytesReady), 'uint8');
			obj.dataEMG = typecast(data, 'single');

			% ---=== notify to save 
			obj.notify('eventEMGChanged');
		end

		% ---=== Start() & Stop()
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
			disp('try to stop tcpip Connection');
		end
	end
end