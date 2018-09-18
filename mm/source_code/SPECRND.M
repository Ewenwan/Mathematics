function r=specrnd(x,p,m,n)
% 生成给定分布律的随机数
%    r=specrnd(x,p)返回一个来自分布律P(x)=p的随机数
%    r=specrnd(x,p,m,n)返回m*n随机数矩阵
%    p的默认值为等概率
% 例如 分布律
%       ξ 	7      8      9     10
%        p 	0.1   0.2   0.4    0.3
%  命令    specrnd([7 8 9 10],[0.1 0.2 0.4 0.3],10,10)
%  产生100个模拟数据  
    
% L. J. HU 9-10-1999

if nargin<4, n=1;end
if nargin<3, m=1;end
if nargin<2|isempty(p), p=1/length(x)*ones(size(x)); end;

[mx,nx]=size(x);[mp,np]=size(p);
sx=min(mx,nx);sp=min(mp,np);
if (mx~=mp)|(nx~=np), 
   error('size must agree');
end;
if (sx~=1)&(sx~=1),error('should be vector'); end;
x=x(:);
if any(x~=sort(x)), error('x should be acsend'); end;
if any((p<0)|(p>1)),error('p should be between 0 and 1'); end;
if abs(sum(p)-1)>1e-3,error('sum of p should be 1'); end;

r=zeros(m,n);lx=max(mx,nx);
s=rand(m,n);
cp=cumsum(p);
k=find(s<cp(1));r(k)=x(1);
k=find(s>=cp(lx-1));r(k)=x(lx);
for i=2:(lx-1),
   k=find((s>=cp(i-1))&(s<cp(i)));
   r(k)=x(i);
end

