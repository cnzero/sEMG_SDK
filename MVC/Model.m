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
			% HOST_IP = '127.0.0.1';
			% obj.interfaceObjects ={tcpip(HOST_IP, 50040), ...   % common
			% 		   			   tcpip(HOST_IP, 50041, ...    % EMG
			% 					   'InputBufferSize', 6400, ...
			% 					   'BytesAvailableFcnMode', 'byte', ...
			% 					   'BytesAvailableFcnCount', 1728, ...
			% 					   'BytesAvailableFcn', @obj.NotifyEMG)};
			% try
			% 	fopen(obj.interfaceObjects{1});
			% 	fopen(obj.interfaceObjects{2});
			% 	fopen(obj.interfaceObjects{3});
			% catch
			% 	error('Connection error.');
			% end

		end
		function StartAcquisition(obj)
			fprintf(obj.interfaceObjects{1}, sprintf(['START\r\n\r']));
		end

		% -- events trigger
		function NotifyEMG(obj)
			% --acquire [dataEMG] from tcpip cache 
			obj.notify('dataEMGChanged');
		end
	end
end