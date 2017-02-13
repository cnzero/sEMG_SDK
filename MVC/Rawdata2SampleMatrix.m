% function description:
% Input:
% 		[Rawdata], (2000t) X nCh, 
% 						rawdata from selected sensor channels
% 		[featuresCell], a cell of strings, which are the name of selected features
% 						and also transform them as their features extraction functions' name
% 		[LW], the length of a features-extraction window
% 		[LI], the increasing length of a features-extraction window

% Output:
%		[sampleMatrix], (nCh*nFe) X M, looks like
% 			(ch1f1)1, (ch1f2)1, (ch1f3)1, ..., (ch2f1)1, (ch2f2)1, (ch2f3)1
% 			(ch1f1)2, (ch1f2)2, (ch1f3)2, ..., (ch2f1)2, (ch2f2)2, (ch2f3)2
% 			. . . . . .
% 			. . . . . .
% 			(ch1f1)M, (ch1f2)M, (ch1f3)M, ..., (ch2f1)M, (ch2f2)M, (ch2f3)M
% 			Representation Explanation:
% 				nCh, the number of selected Channels
% 				nFe, the number of selected Features
% 				M,   the number of sliding windows
% 				nWindows, the number of sliding windows

function sampleMatrix = Rawdata2SampleMatrix(Rawdata, featuresCell, LW, LI)
	% features extraction functions path
	addpath('..\FeaturesExtraction');
	% sliding window algorithm
	[L, nCh] = size(Rawdata);
	nWindows = floor((L-LW)/LI);
	nFeatures = length(featuresCell);
	sampleMatrix = [];
	for wd=0:nWindows-1
		f_row = [];
		for ch=1:nCh
			f_ch_row = [];
			data_wd = Rawdata(wd*LI+1:wd*LI+LW, ch);
			for fe=1:nFeatures
				function_handle = str2func([featuresCell{fe}, '_feature']);
				f_ch_row= [f_ch_row, function_handle(data_wd)];
			end
			f_row = [f_row, f_ch_row];
		end
		sampleMatrix = [sampleMatrix; ...
						f_row];
	end
end