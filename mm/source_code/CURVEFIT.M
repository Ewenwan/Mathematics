function [x,OPTIONS,CostFunction,JACOB] = curvefit(FUN,x0,XDATA,YDATA,OPTIONS,GRADFUN,varargin)
%曲线拟合
%   C=CURVEFIT('拟合模型',参数C初值,X数据,Y数据)
%求参数C使得 sum {(FUN(C,X数据)-Y数据).^2}最小化
%例
%   x | 0.1  0.2  0.15 0.0  -0.2 0.3
%   --|------------------------------
%   y | 0.95 0.84 0.86 1.06 1.50 0.72
%拟合 y=a*exp(b*x).先写M-函数fitfun2.m
%                   function   f=fitfun2(c,x) 
%                   f=c(1)*exp(c(2)*x);
%  解法
%  x=[0.1,0.2,0.15,0,-0.2,0.3];
%  y=[0.95,0.84,0.86,1.06,1.50,0.72];
%  c=curvefit('fitfun2',[1,1]',x,y);
%  a=c(1),b=c(2)
%  f='a*exp(b*xi)';
%  xi=-0.2:0.01:0.3;
%  yi=eval(f);
%  plot(x,y,'o',xi,yi,'k')
%  title('CURVEFIT');    

%CURVEFIT Solves non-linear least squares problems.
%   CURVEFIT solves problems of the form:
%   min  sum {(FUN(X,XDATA)-YDATA).^2}  where FUN, XDATA and YDATA are
%    X                                  matrices.   
%
%   X=CURVEFIT('FUN',X0,XDATA,YDATA) starts at X0 and finds
%   coefficients X to best fit the nonlinear function FUN(X,XDATA) 
%   to the data YDATA (in the least-squares sense). FUN is an M-file 
%   that computes a function of X and XDATA and returns a matrix of 
%   the objective function values: F=FUN(X,XDATA). 
%   NOTE: YDATA must be the same size as the matrix F returned by FUN. 
%
%   X=CURVEFIT('FUN',X0,XDATA,YDATA,OPTIONS) allows a vector of optional 
%   parameters to be defined. OPTIONS(2) is a measure of the precision 
%   required for the values of X at the solution. OPTIONS(3) is a measure 
%   of the precision required of the objective function at the solution. 
%   See HELP FOPTIONS. 
%
%   X=CURVEFIT('FUN',X0,XDATA,YDATA,OPTIONS,'GRADFUN') enables a 
%   function 'GRADFUN' to be entered which returns the partial derivatives 
%   of the functions, dF/dX, (stored in columns) at the point X: 
%   gf = GRADFUN(X,XDATA).
%
%   X=CURVEFIT('FUN',X,XDATA,YDATA,OPTIONS,'GRADFUN',P1,P2,..) passes the 
%   problem-dependent parameters P1,P2,... directly to the functions FUN 
%   and GRADFUN: FUN(X,XDATA,P1,P2,...) and GRADFUN(X,XDATA,P1,P2,...).  
%   Pass empty matrices for OPTIONS and 'GRADFUN' to use the default values.
%
%   [X,OPTIONS,F,J]=CURVEFIT('FUN',X0,XDATA,YDATA,...) returns, F, 
%   the value of FUN(X,XDATA)-YDATA at the solution X, and J the Jacobian 
%   of the function FUN at the solution. 
%
%   FUN must be an M-file and not an inline object or expression. Use LEASTSQ 
%   instead on inline objects or expressions.

%   Copyright (c) 1990-98 by The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 1997/11/29 01:23:03 $
%   Mary Ann Branch 8-22-96.

%   The default algorithm is the Levenberg-Marquardt method with a 
%   mixed quadratic and cubic line search procedure.  A Gauss-Newton
%   method is selected by setting  OPTIONS(5)=1. 
%

% ------------Initialization----------------

if nargin < 4, error('curvefit requires four input arguments');end 
if nargin < 5, OPTIONS=[]; end
if nargin < 6, GRADFUN=[]; end

% Need extra argname for XDATA
curvefitarg = 1;
lenVarIn = length(varargin);

% Convert to inline function as needed.
if isempty(FUN) 
   error('FUN must be a function name.');
elseif isa(FUN,'inline')
   error('FUN must be a function name, not an inline object. Use LEASTSQ instead.');
elseif isstr(FUN)
   % Make sure FUN isn't an expression via fcnchk
   fun0 = fcnchk(FUN);
   if isa(fun0,'inline')
      error('FUN must be a function name, not a string expression. Use LEASTSQ instead.');
   else
      % Momentarily turn FUN into an inline to get at the argnames and formula
      fun1 = inline(FUN,lenVarIn+1);
      fun1args = argnames(fun1);
      % Compute the inline function that is the difference with YDATA      
      arglist = sprintf('%s(', formula(fun1));
      for k = 1:(nargin(fun1)-1);
         arglist = sprintf('%s%s,', arglist, deblank(fun1args{k,:}));
      end
      arglist = sprintf('%s%s)',arglist, deblank(fun1args{nargin(fun1),:}));
      funfcn = inline([arglist, ...
            '-P',int2str(lenVarIn+2)],lenVarIn+2);
   end
else
   error('FUN is an unrecognized data type.')
end

if ~isempty(GRADFUN)
   if isa(GRADFUN,'inline')
      error('GRADFUN must be a function name and not an inline object.');
   elseif isstr(GRADFUN)
      % Make sure FUN isn't an expression via fcnchk
      fun0 = fcnchk(GRADFUN);
      if isa(fun0,'inline')
         error('GRADFUN must be a function name, not a string expression.');
      else
         % Momentarily turn GRADFUN into an inline to get at the argnames and formula
         fun1 = inline(GRADFUN,lenVarIn+1);
         fun1args = argnames(fun1);
         % Compute the inline function that is the difference with YDATA
         arglist = sprintf('%s(', formula(fun1));
         for k = 1:(nargin(fun1)-1);
            arglist = sprintf('%s%s,', arglist, deblank(fun1args{k,:}));
         end
         arglist = sprintf('%s%s)',arglist, deblank(fun1args{nargin(fun1),:}));
         gradfcn = inline(arglist,lenVarIn+2);
      end   
   else
      error('GRADFUN is an unrecognized data type.')
   end
else
   gradfcn = [];
end


% Check the size of f and YDATA
try 
   f = feval(FUN,x0,XDATA,varargin{:});
catch
   error(['Error in evaluating user supplied function: ',FUN])
end

if ~isequal(size(f), size(YDATA))
   error('Function value and YDATA sizes are incommensurate.')
end 

% The order YDATA, XDATA is relevant: match P2 to YDATA
[x,OPTIONS,CostFunction,JACOB] = ...
   nlsqold(funfcn,x0,OPTIONS,gradfcn,XDATA,varargin{:},YDATA);

%--end of curvefit--

