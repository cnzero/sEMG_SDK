function [figureHandleEMG, plotHandlesEMG] = PlotEMGsettings()

	% initiate the EMG figure
	figureHandleEMG = figure('Name', 'EMG Data', ...
	                         'Numbertitle', 'off', ...
	                         'CloseRequestFcn', ...
	                         {@localCloseFigure, ...
	                         interfaceObjectEMG, ...
	                         interfaceObjectACC, ...
	                         commObject, ...
	                         t});
	                        %Function_Name,      Function input parameters.
	% overwrite the default CloseRequestionFcn to close necessary thread.
	set(figureHandleEMG, 'position', [50 200 750 750]);

	%setup EMG plots properties.
	for i = 1:16
	    axesHandlesEMG(i) = subplot(4,4,i);

	    plotHandlesEMG(i) = plot(axesHandlesEMG(i),0,'-y','LineWidth',1);

	    set(axesHandlesEMG(i),'YGrid','off');
	    %set(axesHandlesEMG(i),'YColor',[0.9725 0.9725 0.9725]);
	    set(axesHandlesEMG(i),'XGrid','off');
	    %set(axesHandlesEMG(i),'XColor',[0.9725 0.9725 0.9725]);
	    set(axesHandlesEMG(i),'Color',[.15 .15 .15]);
	    set(axesHandlesEMG(i),'YLim', [-.005 .005]);
	    set(axesHandlesEMG(i),'YLimMode', 'manual');
	    set(axesHandlesEMG(i),'XLim', [0 2000]);
	    set(axesHandlesEMG(i),'XLimMode', 'manual');
	    
	    if(mod(i, 4) == 1)
	        ylabel(axesHandlesEMG(i),'V');
	    else
	        set(axesHandlesEMG(i), 'YTickLabel', '')
	    end
	    
	    if(i >12)
	        xlabel(axesHandlesEMG(i),'Samples');
	    else
	        set(axesHandlesEMG(i), 'XTickLabel', '')
	    end
	    
	    title(sprintf('EMG %i', i)) 
	end