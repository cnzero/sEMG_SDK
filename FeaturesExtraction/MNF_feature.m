% Mean Frequency, MNF
function feature = MNF_feature(data_TimeWindow)
	Window_L = length(data_TimeWindow);
	power_spectral = abs(fft(data_TimeWindow, Window_L).^2)/Window_L;
	L = length(power_spectral);
	Fs = 2000; % Sampling frequency
	f = Fs/2*linspace(0, 1, L/2)';
	feature = meanfrequency(f, power_spectral(1:L/2));

function mnf = meanfrequency(f, p)
	mnf = sum(p.*f)/sum(p);