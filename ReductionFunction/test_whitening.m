% Test purpose:
% 1. which method will lead the covariance to EYE 
% Status: completed. 
% Conclusion: 
% 2. give a plotting-understanding of two similar methods.

% preparing
clear,close all, clc;

% generating Gaussian random Sample.
mu = [2 3];
SIGMA = [2   1.5; ...
         1.5 5];
rng('default');  % For reproducibility
Sample = mvnrnd(mu,SIGMA,500);
% 100x2

% plot Sample
subplot(2,2,1)
plot(Sample(:,1), Sample(:,2), '.')
axis equal

% --------------------method one: raw and simple method.
mean_value = mean(Sample, 1);
Sample_centering = Sample - repmat(mean_value, size(Sample, 1), 1);
std_var_value = var(Sample_centering, 1); 
% 1x3

% every row of Sample matrix is normalized by [its own variance]
new_Sample = Sample_centering./repmat(sqrt(std_var_value), size(Sample, 1), 1);
cov(new_Sample)
% NOT EQUAL TO EYE

% plot Sample
subplot(2,2,2)
plot(new_Sample(:,1), new_Sample(:,2), '.')
axis equal




% --------------------method two.
cov_var_value = cov(Sample_centering);
[V,D] = eig(cov_var_value);
New_Dsqrt = zeros(size(Sample,2));
for i=1:size(Sample, 2)
	New_Dsqrt(i,i) = D(i,i)^(-0.5); 
end
New_Sample = Sample_centering*V*New_Dsqrt*V';
cov(New_Sample)
% DO EQUAL TO EYE

% plot Sample
subplot(2,2,3)
plot(New_Sample(:,1), New_Sample(:,2), '.')
axis equal

% --------------Comparison Summary
% Conclusion:
% 			1. PCA pre-processing
% 				method one should be conducted in PCA pre-processing.
% 				method two must not be conducted.
% 				Because, can you image eigvalue-eigvector decomposition of EYE?
% 				Easy, all eigvalues are real number one, how could you sort them.
% 				So, it is wrong.
% 		   2. ICA and other algorithms pre-processing
% 				whitening with method two.