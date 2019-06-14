% KM_DEMO_KRR_NYSTROM Kernel ridge regression (also known as kernel
% least-squares KLS) on data sampled from a sinc function, using Nystrom
% method kernel matrix decomposition.
%
% Author: Steven Van Vaerenbergh (steven.vanvaerenbergh at unican.es) 2016.
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

close all
clear
rng('default'); rng(1); % for reproducibility

%% PARAMETERS

n = 2500; % number of data points sampled from sinc
n2 = 100; % number of data points for testing the regression
nvar = 0.05; % noise variance factor

lambda = 1E-4; % regularization constant
kernel = 'gauss'; % kernel type
sigma = 1; % Gaussian kernel width

m = 50; % decomposition rank

%% PROGRAM
tic

X = randn(n,1); % sampled data
noise = nvar*randn(n,1); % noise
Y = sin(3*X)./X+noise; % noisy sinc data
X2 = linspace(-3,3,n2)'; % input data for testing the regression

[alpha,subset,Y2] = km_krr_nystrom(X,Y,kernel,sigma,m,X2);

Y2sinc = sin(3*X2)./X2; % true sinc output data corresponding to x2

toc
%% OUTPUT

figure; hold on
plot(X,Y,'x','Color',[0.7,0.7,0.7]);
plot(X2,Y2sinc,'b--','LineWidth',2)
plot(X2,Y2,'r');
plot(X(subset,:),Y(subset),'og')
legend('noisy data','true sinc function','regression','support points')
title('Kernel ridge regression demo')
