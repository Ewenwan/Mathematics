function [tout, yout] = rk4(ypfun, tspan, y0, h)
%定步长四阶Runge-Kutta法求常微分方程数值解
%[tout,yout] = rk4('ypfun', tspan, y0,h)
%    这里字符串ypfun是用以表示f(t, y)的M文件名,
%    tspan=[t0, tfinal]表示自变量初值t0和终值tf
%    y0表示初值向量y0，h是步长。 
%    输出列向量tout表示节点 (t0 , t1 , … , tn)'
%    输出矩阵yout 表示数值解，每一列对应y的一个分量
%例 解微分方程
%							y' = y-2t/y, y(0)=1, 0<t<1	(步长0.1)			
%  先写M函数quadeg5fun.m
%             function f=quadeg5fun(t,y)
%             f=y-2*t./y;
%             f=f(:);			%保证f为一个列向量
%  再用
%   [t,y]=rk4('quadeg5fun',[0,1],1,0.1)
%   plot(t,y); 
%
%Purpose: Solve differential equations by 4 order Runge_Kutta method.
% Synopsis:	[tout,yout] = rk4('ypfun', [t0, tfinal], y0,h) 
%	INPUT:
%	ypfun - String containing name of M-file user-supplied problem description.
%	        Call: f = ypfun(t,y) 
%	        t      - Time (scalar).
%	        y      - Solution column-vector.
%	        f      - Returned derivative column-vector; f(i) = dy(i)/dt.
%	t0    - Initial value of t.
%	tfinal- Final value of t.
%	y0    - Initial value vector.
%	h     - Step size
%	OUTPUT:
%	tout     - Returned integration time points (column-vector).
%	yout     - Returned solution, one solution column-vector per tout-value.
%
%	The result can be displayed by: plot(t, y).
%
%	See also EULER, ODE23, ODE45, ODEDEMO.

%	L.J.Hu  8-20-98

t=tspan(1):h:tspan(2);
y(:,1)=y0(:);

for i=1:length(t)-1,
   k1=feval(ypfun,t(i),y(:,i));
   k2=feval(ypfun,t(i)+h/2,y(:,i)+h*k1/2);
   k3=feval(ypfun,t(i)+h/2,y(:,i)+h*k2/2);
   k4=feval(ypfun,t(i)+h,y(:,i)+h*k3);
   y(:,i+1)=y(:,i)+h*(k1+2*k2+2*k3+k4)/6;
end

tout=t';yout=y';