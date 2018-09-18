function [h,sig]=chi2test(n,x,p,alpha)
%[h,sig]=chi2test(n,x,p,alpha)
% 分布拟合度检验
% n: 数据总数
% x: 实际组频数向量
% p: 理论组频数向量
% h：返回1表示拒绝H0，返回0表示接受H0。 
% sig：返回检验统计量的值，sig< alpha 时h=1

% L.J. Hu 8-19-1999

if nargin<4,alpha=0.05;end
if min(size(x))~=1|min(size(p))~=1,
   error('X,P must be vectors');
end
kx=length(x);kp=length(p);
if kx~=kp,
   error('Dimension of vectors must be agree');
end

chi2=sum((x-p).^2./p);
h=0;
sig=1-chi2cdf(chi2,kx-1);
if sig<alpha, h=1;end
