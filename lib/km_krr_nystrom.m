function [alpha,subset,Y2] = km_krr_nystrom(X,Y,ktype,kpar,m,X2)
% KM_KRR_NYSTROM performs kernel ridge regression (KRR) on a data set by
% using the Nystrom decomposition and returns the regressor weights.
% Input:  - X, Y: input and output data matrices for learning the
%         regression. Each data point is stored as a row.
%         - ktype: string representing kernel type.
%         - kpar: vector containing the kernel parameters.
%         - m: rank of decomposition
%         - X2 (optional): additional input data set for which regression
%         outputs are returned.
% Output: - alpha: regression weights
%         - subset: indices of data selected for low-rank approximation
%         - Y2: outputs of the regression corresponding to inputs X2. If
%         X2 is not provided, Y2 is the regressor output of input data X.
% Dependencies: km_kernel.
% USAGE: [alpha,Y2,subset] = km_krr_nystrom(X,Y,ktype,kpar,m,X2)
%
% Author: Steven Van Vaerenbergh (steven.vanvaerenbergh at unican.es) 2016
%
% This file is part of the Kernel Methods Toolbox for MATLAB.
% https://github.com/steven2358/kmbox

jitter = 1E-6;

if (nargin<6)
    X2 = X;
end

n = size(X,1);
np = randperm(n);

subset = np(1:m);
Xm = X(subset,:);
Kmm = km_kernel(Xm, Xm, ktype, kpar);
Knm = km_kernel(X, Xm, ktype, kpar);

[U,L] = eig(Kmm);
l = diag(L);
lind = find(l>1E-8);
m_true = length(lind);

lt = n/m_true*l(lind); % Eq. (8)
Lt = diag(lt);
Ut = sqrt(m_true/n)*Knm*U(:,lind)*diag(1./l(lind)); % Eq. (9)

I = eye(m_true);
alpha = 1/jitter*(Y-Ut/(jitter*I+Lt*(Ut'*Ut))*Lt*Ut'*Y); % Eq. (11)

I = eye(m);
K2 = km_kernel(X2,Xm,ktype,kpar);
Y2 = (K2/(Kmm+jitter*I))*(Knm'*alpha);
