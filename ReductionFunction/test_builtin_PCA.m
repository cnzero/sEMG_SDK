function test_builtin_PCA()
	load hald;
	coeff1 = pca(ingredients)

	coeff2 = pca(Normalizing(ingredients))


	coeff1/coeff2

function new_samples = Normalizing(samples)
	% samples
	% nxm
	[n, m] = size(samples);
	% n correspond to observations
	% m correspond to variables, components.

	% centering...
	mean_values = mean(samples);
	% 1xm
	mean_samples = samples - repmat(mean_values, n, 1)

	% whitning
	std_var_value = var(mean_samples, 1);
	% 1xm, standard variable
	new_samples = mean_samples./repmat(std_var_value, n,1);


