function [b,bint,r,rint,stats] = regress(y,X,alpha)
% 多元线性回归  y = b1*x1+b2*x2+…+bp*xp
%[b,bint,r,rint,stats] = regress(y,x,alpha)
%   其中
%		y：y的数据n*1向量
%		x：x的数据n*p矩阵
%		b：b的估计值
%		bint：b的置信区间
%		r：残差r =Y-X 
%		rint：r的置信区间
%		stats：检验统计量，第一值是回归方程的置信度,
%           第二值是F统计量值，第三值是与F统计量相应的p值,
%           F很大而p很小说明回归方程系数不为0。
%例如 
%   load moore   %Matlab一个内部数据,前5列是5个因素x1~x5,
%                %第6列是响 应 y=a0+a1*x1+a2*x2+…+a5*x5+epsilon
%   x=[ones(size(moore,1),1),moore(:,1:5)];
%   y=moore(:,6);
%   [b,bint,r,rint,stats]=regress(y,x);
%   b                 % 结果依次为a0,a1,...,a5
%
%REGRESS Multiple linear regression using least squares.
%   b = REGRESS(y,X) returns the vector of regression coefficients, B.
%   Given the linear model: y = Xb, 
%   (X is an nxp matrix, y is the nx1 vector of observations.) 
%   [B,BINT,R,RINT,STATS] = REGRESS(y,X,alpha) uses the input, ALPHA
%   to calculate 100(1 - ALPHA) confidence intervals for B and the 
%   residual vector, R, in BINT and RINT respectively. 
%   The vector STATS contains the R-square statistic along with the F 
%   and p values for the regression.

%   References:
%      [1] Samprit Chatterjee and Ali S. Hadi, "Influential Observations,
%      High Leverage Points, and Outliers in Linear Regression",
%      Statistical Science 1986 Vol. 1 No. 3 pp. 379-416. 
%      [2] N. Draper and H. Smith, "Applied Regression Analysis, Second
%      Edition", Wiley, 1981.

%   B.A. Jones 3-04-93
%   Copyright (c) 1993-98 by The MathWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:38 $

if  nargin < 2,              
    error('REGRESS requires at least two input arguments.');      
end 

if nargin == 2, 
    alpha = 0.05; 
end

% Check that matrix (X) and left hand side (y) have compatible dimensions
[n,p] = size(X);
[n1,collhs] = size(y);
if n ~= n1, 
    error('The number of rows in Y must equal the number of rows in X.'); 
end 

if collhs ~= 1, 
    error('Y must be a vector, not a matrix'); 
end

% Find the least squares solution.
[Q, R]=qr(X,0);
b = R\(Q'*y);

% Find a confidence interval for each component of x
% Draper and Smith, equation 2.6.15, page 94

RI = R\eye(p);
xdiag=sqrt(sum((RI .* RI)'))';
nu = n-p;                       % Regression degrees of freedom
yhat = X*b;                     % Predicted responses at each data point.
r = y-yhat;                     % Residuals.
if nu ~= 0
   rmse = norm(r)/sqrt(nu);        % Root mean square error.
else
   rmse = Inf;
end
s2 = rmse^2;                    % Estimator of error variance.
tval = tinv((1-alpha/2),nu);
bint = [b-tval*xdiag*rmse, b+tval*xdiag*rmse];

% Calculate R-squared.
if nargout==5,
   RSS = norm(yhat-mean(y))^2;  % Residual sum of squares.
   TSS = norm(y-mean(y))^2;     % Total sum of squares.
   r2 = RSS/TSS;                % R-square statistic.
   F = (RSS/(p-1))/s2;          % F statistic for regression
   prob = 1 - fcdf(F,p-1,nu);   % Significance probability for regression
   stats = [r2 F prob];
end

% Find the standard errors of the residuals.
% Get the diagonal elements of the "Hat" matrix.
% Calculate the variance estimate obtained by removing each case (i.e. sigmai)
% see Chatterjee and Hadi p. 380 equation 14.
T = X*RI;
hatdiag=sum((T .* T)')';
if nu < 1, 
  ser=rmse*ones(length(y),1);
elseif nu > 1
  sigmai = sqrt((nu*s2/(nu-1)) - (r .^2 ./ ((nu-1) .* (1-hatdiag))));
  ser = sqrt(1-hatdiag) .* sigmai;
elseif nu == 1
  ser = sqrt(1-hatdiag) .* rmse;
end

ti= r ./ ser;

% Create confidence intervals for residuals.
Z=[(r-tval*ser) (r+tval*ser)]';
rint=Z';
