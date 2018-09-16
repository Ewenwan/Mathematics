function x=newton(f_name,x0,tol)
% Purpose: Solve a nonlinear equation by Newton iteration
% Synopsis:     x=newton('f_name',x0)      
%               x=newton('f_name',x0,tol)  
%
%            x: return a root of f(x)=0 near x0
%            f_name:name of the function f(x) that defines the equation
%            x0: initial guess
%            tol: tolerence(Default:1e-6)

% L.J.Hu 1-8-1998

h=0.0001;M=500;
if nargin<3, tol=1e-6;end
x=x0;xb=x-999;
n=0;
while abs(x-xb)>tol 
  xb=x;
  if n>M break;end
  y=feval(f_name, x);
  fprintf('  n=%3.0f,  x=%12.5e,  y=%12.5e, \n',n,x,y)
  y_driv=(feval(f_name,x+h)-y)/h;
  x=xb-y/y_driv;
  n=n+1;
end
fprintf('  n=%3.0f,  x=%12.5e,  y=%12.5e, ',n,x,y)
if n>500,
 fprintf('\n');disp('Warning: iterations exceeds the limitation, probable devergent');
end