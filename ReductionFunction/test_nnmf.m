% NMF, Nonnegative Matrix Factorization

% pre-processing
clear, close all,clc

% ----------------Example One
load fisheriris;
[W, H] = nnmf(meas, 2);
%150x2, 2x4   150x4 

New_W = meas * pinv(H);
% how to get the reducted sample matrix
% this equation give a solution. 
% New_sample = sample *pinv(H)
% Also, pinv(H), is the reduction matrix


% biplot(H','scores',W,'varlabels',{'1','2','3','4'});
% -----About biplot
% A biplot allows you to visualize the magnitude and sign of each variable's
% contribution to the first two or three pricipal components.
% And each observation is represented in terms of those components. 
% axis([0 1.1 0 1.1])
% xlabel('Column 1');
% ylabel('Column 2');


% --------------Example Two
% X = rand(100, 20) * rand(20, 50);
% opt = statset('MaxIter', 5, ...
% 	          'Display', 'final');
% [W0, H0] = nnmf(X, 5, 'replicates', 10, ...
% 	                  'options', opt, ...
% 	                  'algorithm', 'mult');