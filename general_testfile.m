% This is a general test script file.

% add necessary path to be available.
path(path, [pwd, '\acquisition']);
path(path, [pwd, '\controlAPI']);
path(path, [pwd, '\models']);

% parameters settings
Tinfo.InputBufferSize = 6400;
Tinfo.BytesAvailableFcnCountEMG = 1728;
Tinfo.BytesAvailableFcnCountACC = 384;

RPinfo.folder_name 
RPinfo.DebugPlot = 1;
RPinfo.Sensor = 1;
RPinfo.Channel = [1, 2];
RPinfo.Write = 1;

commonObject = Initiate(Tinfo, RPinfo);
fprintf(commonObject, sprintf(['START\r\n\r']));
