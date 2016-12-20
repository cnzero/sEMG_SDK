function feature = MDF_feature(data_TimeWindow)
	Window_L = length(data_TimeWindow);
	power_spectral = abs(fft(data_TimeWindow, Window_L).^2)/Window_L;
	L = length(power_spectral);
	Fs = 2000; % Sampling frequency
	f = Fs/2*linspace(0, 1, L/2)';
	feature = medianfrequency(f, power_spectral(1:L/2));


% bisection search for increased speed.
function mnf = medianfrequency(f,p)
	N = length(f);
	low = 1;
	high = N;
	mid = ceil((low+high)/2);
	while ~( sum(p(1:mid)) >= sum(p((mid+1):N)) && sum(p(1:(mid-1))) < sum(p(mid:N)) )
	    if sum(p(1:mid)) < sum(p((mid+1):N))
	        low = mid;
	    else
	        high = mid;
	    end
%         fixed the original bug here.
        if p(1) == max(p)
            mid = floor((low+high)/2);
        else
            mid = ceil((low+high)/2);
        end
    end
	mnf = f(mid);
% There are some bugs in this biosection search.