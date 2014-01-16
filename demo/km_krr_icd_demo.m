% KM_KRR_DEMO Kernel ridge regression (also known as kernel least-squares 
% (KLS) on data sampled from a sinc function.
%
% This program implements the example shown in Figure 2.1 of "Kernel
% Methods for Nonlinear Identification, Equalization and Separation of
% Signals", Ph.D. dissertation by S. Van Vaerenbergh.
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2010
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://sourceforge.net/projects/kmbox

close all
clear all

%% PARAMETERS

N = 2500;			% number of data points sampled from sinc
N2 = 100;		% number of data points for testing the regression
nvar = 0.05;	% noise variance factor

lambda = 1E-4;		% regularization constant
kernel = 'gauss';	% kernel type
sigma = 1;			% Gaussian kernel width

%% PROGRAM
tic

x = randn(N,1);	% sampled data
n = nvar*randn(N,1);	% noise
y = sin(3*x)./x+n;		% noisy sinc data
x2 = linspace(-3,3,N2)';	% input data for testing the regression

[G,subset] = km_kernel_icd(x,kernel,sigma,100,1E-6);
K = km_kernel(x,x(subset,:),kernel,sigma);
alpha = K\y;

K2 = km_kernel(x2,x(subset,:),kernel,sigma);
y2 = K2*alpha;

y2sinc = sin(3*x2)./x2;	% true sinc output data corresponding to x2

toc
%% OUTPUT

figure; hold on
plot(x,y,'x','Color',[0.7,0.7,0.7]);
plot(x2,y2sinc,'b--','LineWidth',2)
plot(x2,y2,'r');
plot(x(subset,:),y(subset),'og')
legend('noisy data','regression','true sinc function','support points')
title('Kernel ridge regression demo')