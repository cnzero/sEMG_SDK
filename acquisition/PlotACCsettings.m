% function descriptions:
% 
% Input:
% 		interfaceObject, a 1x3 cell of tcpip handles
% Output:
% 		figureHandleEMG
% 		plotHandlesEMG
function [figureHandleACC, plotHandlesACC] = PlotACCsettings(interfaceObject, timerRefreshData)

	% initiate the ACC figure
	figureHandleACC = figure('Name', 'ACC Data', ...
	                         'Numbertitle', 'off', ...
	                         'CloseRequestFcn', ...
	                         {@LocalCloseFunction, interfaceObject, ...
	                         					   timerRefreshData});
	                        %Function_Name,      Function input parameters.
	% overwrite the default CloseRequestionFcn to close necessary thread.
	set(figureHandleACC, 'position', [850 200 750 700]);

	%setup ACC plots properties.
	for i = 1:16
	    axesHandlesACC(i) = subplot(4, 4, i);
	    hold on
	    plotHandlesACC(i*3-2) = plot(axesHandlesACC(i), 0, '-y', 'LineWidth', 1);    
	    plotHandlesACC(i*3-1) = plot(axesHandlesACC(i), 0, '-y', 'LineWidth', 1);   
	    plotHandlesACC(i*3) = plot(axesHandlesACC(i), 0, '-y', 'LineWidth', 1);
	    hold off 
	    
	    set(plotHandlesACC(i*3-2), 'Color', 'r')
	    set(plotHandlesACC(i*3-1), 'Color', 'b')
	    set(plotHandlesACC(i*3), 'Color', 'g')    
	    set(axesHandlesACC(i),'YGrid','on');
	    %set(axesHandlesACC(i),'YColor',[0.9725 0.9725 0.9725]);
	    set(axesHandlesACC(i),'XGrid','on');
	    %set(axesHandlesACC(i),'XColor',[0.9725 0.9725 0.9725]);
	    set(axesHandlesACC(i),'Color',[.15 .15 .15]);
	    set(axesHandlesACC(i),'YLim', [-8 8]);
	    set(axesHandlesACC(i),'YLimMode', 'manual');
	    set(axesHandlesACC(i),'XLim', [0 2000/13.5]);
	    set(axesHandlesACC(i),'XLimMode', 'manual');
	    
	    if(i > 12)
	        xlabel(axesHandlesACC(i),'Samples');
	    else
	        set(axesHandlesACC(i), 'XTickLabel', '');
	    end
	    
	    if(mod(i, 4) == 1)
	        ylabel(axesHandlesACC(i),'g');
	    else
	        set(axesHandlesACC(i) ,'YTickLabel', '')
	    end
	    
	    title(sprintf('ACC %i', i)) 
	end
