function sample = Rawdata2Sample(raw, windows, FeatureName)
    L = length(raw);
    LI = windows.LI;
    LW = windows.LW;
    Nwindows = floor((L-LW)/LI);
    Nfeatures = length(FeatureName);
    
    sample = [];
    for wd=0:Nwindows-1
        data = raw(wd*LI+1:wd*LI+LW);
        sample_column = [];
        for nf = 1:length(FeatureName)
            function_handle = str2func([FeatureName{nf}, '_feature']);
            sample_column = [sample_column; ...
                             function_handle(data)];
        end
        sample = [sample, sample_column];
    end
    
    
    

    
    
    
% ---- Explanation -----

% {FeatureName}
% 'ARC'
% 'Ceps'
% 'IAV'
% 'MAV'
% 'MAX'
% 'MDF'
% 'MNF'
% 'NonZeroMed'
% 'NonZeroMedIndex'
% 'PSD'
% 'RMS'
% 'SSC'
% 'VAR'
% 'WA'
% 'WL'
% 'ZC'
            %|%
            %|%
            %|%
            %V%
            %V%
        % str2func %
% Features extraction functions
% 'ARC'_'feature'
% 'Ceps'_'feature'
% 'IAV'_'feature'
% 'MAV'_'feature'
% 'MAX'_'feature'
% 'MDF'_'feature'
% 'MNF'_'feature'
% 'NonZeroMed'_'feature'
% 'NonZeroMedIndex'_'feature'
% 'PSD'_'feature'
% 'RMS'_'feature'
% 'SSC'_'feature'
% 'VAR'_'feature'
% 'WA'_'feature'
% 'WL'_'feature'
% 'ZC'_'feature'
