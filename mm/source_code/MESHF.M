function [x,y,z]=meshf(f_name,xa,xb,y_lower,y_upper,m,n)
%二元函数z=f(x,y)非矩形网格图
%用法：[x,y,z]=meshf('f_name',xa,xb,'y_lower','y_upper',m,n)
%     f_name: 表示二元函数z=f(x,y)的M函数名
%     xa,xb: x下端与上端
%     y_lower,y_upper:  y用x表示的上端函数与下端函数
%     m,n: 网格数（默认m=n=20）
%     [x,y,z]: 返回网格数据，可用mesh(x,y,z)作图，若无输出变量则自动作图
%例题 画z=exp(-x^2/2-y^2/2)/2/pi在x^2+y^2<=9内的图。
%先写三个M函数top_f.m, low_f.m, upp_f.m
%                    M函数top_f.m
%                 function z=f(x,y)
%                 z=exp(-x.^2/2-y.^2/2)/2/pi; 
%                    M函数low_f.m
%                 function y=f(x)
%                 y=-sqrt(9-x.^2);
%                    M函数upp_f.m
%                 function y=f(x)
%                 y=sqrt(9-x.^2);
%现在用命令
%     meshf('top_f',-3,3,'low_f','upp_f')
%
% Purpose: Generate mesh of z=f(x,y)
% Synopsis: [x,y,z]=meshf('f_name',xa,xb,'y_lower','y_upper',m,n)
%		f_name: file name of 2-D function f(x,y)
%		xa,xb: lower and upper limit of x
%		y_lower,y_upper: file names of lower and upper 
%                                limit of y (1-D function of x)
%		m,n: number of meshgrid (Default: m=n=20)
%		[x,y,z]: return mesh data used by MESH of SURF

% L.J.Hu 8-8-1998

if nargin<7,n=20;end
if nargin<6,m=20;end

x=linspace(xa,xb,m);
yc=feval(y_lower,x);yd=feval(y_upper,x);

x=ones(n,1)*x;
y=zeros(n,m);
for i=1:m
  y(:,i)=linspace(yc(i),yd(i),n)';
end
z=feval(f_name,x,y);

if nargout==0,mesh(x,y,z);xlabel('X');ylabel('Y');end
