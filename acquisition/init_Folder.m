function folder_name = init_Folder(Write)
	folder_name = [];
	if Write == 1
		c = clock;
		folder_name = [folder_name, ...
					   num2str(c(1)), ... % year
		               '_', ...
		               num2str(c(2)), ... % month
		               '_', ...
		               num2str(c(3)), ... % day
		               '_', ...
		               num2str(c(4)), ... % hour
		               '_', ...
		               num2str(c(5)), ... % minute
		               '_', ...
		               num2str(fix(c(6)))]; % second
		% for example, run this code at 2016-07-13 10:13:30s
		% folder_name, 2016_07_13_10_13_30
		mkdir(folder_name);
		mkdir([folder_name, '\EMG']);
		mkdir([folder_name, '\ACC']);
	end