function [x,f]=L01p_ie(c,A,b,N)
% [x,f]= L01p_ie(c,A,b,N)用隐枚举法求解下列0-1线性规划问题
%       min f=c'*x, s.t. A*x<=b，  x的分量全为整数0或1，
%  其中N表示约束条件 Ax ≤ b中的前N个是等式，N= 0时可以省略。%  程序中用到命令B = de2bi(D)，其作用是将10进制数向量D转换
%  为相应二进制数按位构成的以0，1为元素的矩阵B。
%  此命令在toolbox communication中。
%  返回结果x是最优解，f是最优解处的函数值。
%例 max f=3x1+5x2+2x3+4x4+2x5+3x6
%   s.t. 8x1+13x2+6x3+9x4+5x5+7x6<=24, x1,…,x6均为0或1
%求解
%  c=-[3,5,2,4,2,3];a=[8,13,6,9,5,7];b=24;
%  x=1p_ie(c,a,b)

% By X.D. Ding, June 2000

if nargin<4,N=0;end
c=c(:);b=b(:);
A=[-A(1:N,:);A];b=[-b(1:N);b];
[m,n]=size(A);x=[];f=abs(c')*ones(n,1);
A=[c';A];b=[f;b];i=1;
while i<=2^n
   B=de2bi(i-1,n)';
   j=1;t1=A(j,:)*B-b(j);
   while(t1<=0&j<m+1)
      j=j+1;t1=A(j,:)*B-b(j);
      if t1>0,j=1;end
   end
   if j==m+1
      x=B;f=c'*B;
      b(1)=min([b(1),f]);
   end
   i=i+1;
end

