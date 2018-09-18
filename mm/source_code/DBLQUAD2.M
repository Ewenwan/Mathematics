function I=dblquad2(f_name,a,b,c_lo,d_hi,m,n)
%非矩形区域二重积分
%I=dblquad2('fname',a,b,'c_low','d_up',m,n)
%  其中'fname'为被积函数f(x,y)字符串,
%  'c_low'和'd_up'是y的上下限函数c(x),d(x)；
%  a,b分别为x的上下限; m,n分别为x和y方向的等分数(确省值100)。
%
% Purpose: Double integration of a 2-D function f(x,y)
% Synopsis: I=quad2('f_name',a,b,'c_lo','d_hi',m,n)
%		f_name: function M-file name of the integrand f(x,y)
%		a,b: lower and upper limit of x
%		c_lo: M-file name of lower limit of y, c(x)
%		d_hi: M-file name of upper limit of y, d(x)
%		m,n: number of intervals in x and y directions,
%		     resp.(Default: m=n=100)
% See also TRAPZ, QUAD, QUAD8,INT.

% L.J.Hu 8-10-98

if nargin<7, n=100;end
if nargin<6, m=100;end
if m<2|n<2
   error('Number of intervals invalid\n');
end
mpt=m+1;hx=(b-a)/m;x=a+(0:m)*hx;
for i=1:mpt
  ylo=feval(c_lo,x(i));yhi=feval(d_hi,x(i));
  hy=(yhi-ylo)/n; y(i,:)=ylo+(0:n)*hy;
  f(i,:)=feval(f_name,x(i),y(i,:));
  G(i)=trapz(y(i,:),f(i,:));
end
I=trapz(x,G);
