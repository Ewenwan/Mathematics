function yy=lagrange(x,y,xx)
% Lagrange 插值
% yy=lagrange(x,y,xx)求数据(x,y)所表达的函数在插值点xx处的插值
%    要求x,y为同维数向量
%例如 数据
%   x | 0.1  0.2  0.15 0.0  -0.2 0.3
%   --|------------------------------
%   y | 0.95 0.84 0.86 1.06 1.50 0.72
% 求解
%    clear;close;
%    x=[0.1,0.2,0.15,0,-0.2,0.3];
%    y=[0.95,0.84,0.86,1.06,1.50,0.72];
%    xi=-0.2:0.01:0.3;
%    yi=lagrange(x,y,xi);
%    plot(x,y,'o',xi,yi,'k');
%    title('lagrange');

% L.J. Hu 8-20-1998

m=length(x);n=length(y);
if m~=n, error('向量x与y的长度必须一致');end
s=0;
for i=1:n
   t=ones(1,length(xx));
   for j=1:n
      if j~=i, 
         t=t.*(xx-x(j))/(x(i)-x(j));
      end
   end
   s=s+t*y(i);
end
yy=s;

   