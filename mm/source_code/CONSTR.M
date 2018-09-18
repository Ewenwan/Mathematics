function [x,OPTIONS,lambda,HESS]=constr(FUN,x,OPTIONS,VLB,VUB,GRADFUN,varargin)
%约束优化,非线性规划
%求解       min  f(x)
%           s.t. G(x)<=0
% 这里x是n维向量,G(x)是 的向量函数,f(x)是 的函 数,G(x)<=0中可含有的等式约束。
% 用法
%    x=constr('fun',x0)
%    x=constr('fun',x0,options)
%    x=constr('fun',x0,options,vlb,vub)
%    x=constr('fun',x0,options,vlb,vub,'grad')
%    x=constr('fun',x0,options,vlb,vub,'grad'.p1,p2,…)
%    [x,options]=constr('fun',x0,…)
% 这里fun是表示f(x)和G(x)的M函数
%               [f,g]=fun(x)
% x0为初值，options为优化参数，vlb为下界,vub为上界，
% grad是表示f(x)和G(x)的梯度的M函数。
%               [df,dg]=grad(x)
% 注意：方程变量必须拼成一个向量变量，即用x(1),x(2),...
%
%例题
%   max x*y*z
%   -x+y+2*z>=0
%   x+2*y+2*z<=72
%   10<=y<=20
%    x-y=10
%  先化为
%   min -x(1)*x(2)*x(3)
%   x(1)-x(2)-10=0
%   x(1)-x(2)-2*x(3)<=0
%   x(1)+2*x(2)+2*x(3)-72<=0
%   10<=x(2)<=20
%  写M函数optfun2.m
%          function  [f,g]=optfun2(x)
%          f=-x(1)*x(2)*x(3)
%          g(1)=x(1)-x(2)-10;
%          g(2)=x(1)-x(2)-2*x(3);
%          g(3)=x(1)+2*x(2)+2*x(3)-72
%  求解
%   x0=[10,10,10];
%   options(13)=1;
%   [x,options]=constr('fun',x0,options,[-inf,10,-inf]',[inf,20,inf]);
%   x,-options(8)
%
%CONSTR Finds the constrained minimum of a function of several variables.
%   CONSTR has been replaced with FMINCON.  CONSTR currently works but
%   will be removed in the future.  Use FMINCON instead.
%
%   X=CONSTR('FUN',X0) starts at X0 and finds a constrained minimum to 
%   the function which is described in FUN (usually an M-file: FUN.M).
%   The function 'FUN' should return two arguments: a scalar value of the 
%   function to be minimized, F, and a matrix of constraints, G: 
%   [F,G]=FUN(X). F is minimized such that G <= zeros(size(G)).
%
%   X=CONSTR('FUN',X,OPTIONS) allows a vector of optional parameters to 
%   be defined. For more information type HELP FOPTIONS.
%   
%   X=CONSTR('FUN',X,OPTIONS,VLB,VUB) defines a set of lower and upper
%   bounds on the design variables, X, so that the solution is always in 
%   the range VLB <= X <= VUB. 
%   
%   X=CONSTR('FUN',X,OPTIONS,VLB,VUB,'GRADFUN') allows a function 
%   'GRADFUN' to be entered which returns the partial derivatives of the 
%   function and the constraints at X:  [gf,GC] = GRADFUN(X).
%   Use OPTIONS(9)=1 to check analytic gradients in GRADFUN against
%   numeric gradients during the first iteration.
%
%   X=CONSTR('FUN',X,OPTIONS,VLB,VUB,'GRADFUN',P1,P2,...) passes the 
%   problem-dependent parameters P1,P2,... directly to the functions FUN 
%   and GRADFUN: FUN(X,P1,P2,...) and GRADFUN(X,P1,P2,...).  Pass
%   empty matrices for OPTIONS, VLB, VUB, and 'GRADFUN' to use the 
%   default values.
%
%   [X,OPTIONS]=CONSTR('FUN',X0,...) returns the parameters used in the 
%   optimization method.  For example, OPTIONS(10) contains the number 
%   of function evaluations used.
%
%   [X,OPTIONS,LAMBDA]=CONSTR('FUN',X0,...) returns the Lagrange multipliers
%   at the solution X in the vector LAMBDA.
%
%   [X,OPTIONS,LAMBDA,HESS]=CONSTR('FUN',X0,...) returns the quasi-Newton
%   approximation to the Hessian matrix at the solution X.
%
%   Copyright (c) 1990-98 by The MathWorks, Inc.
%   $Revision: 1.45 $  $Date: 1998/08/31 22:29:17 $

%
%   X=CONSTR('FUN',X,OPTIONS,VLB,VUB,GRADFUN,P1,P2,..) allows
%   extra parameters, P1, P2, ... to be passed directly to FUN:
%   [F,G]=FUN(X,P1,P2,...). Empty arguments ([]) are ignored.


if nargin < 2, error('constr requires two input arguments'); end
if nargin < 3, OPTIONS=[]; end
if nargin < 4, VLB=[]; end
if nargin < 5, VUB=[]; end
if nargin < 6, GRADFUN=[]; end

caller='constr';
lenVarIn = length(varargin);

% Convert to inline function as needed.
gradflag = 0;
[funfcn,msg] = prefcnchk(FUN,caller,lenVarIn,gradflag);
if ~isempty(msg)
  error(msg);
end

if ~isempty(GRADFUN)
  gradflag = 1;
  [gradfcn,msg] = prefcnchk(GRADFUN,caller,lenVarIn,gradflag);
  if ~isempty(msg)
    error(msg);
  end
else
  gradfcn = [];
end

[x,OPTIONS,lambda,HESS]=nlconstold(funfcn,x,OPTIONS,VLB,VUB,gradfcn,varargin{:});

