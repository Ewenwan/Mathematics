function [xf,options] = fmin(funfcn,ax,bx,options,varargin)
%x=fmin('fun',a,b) 求一元函数y=f(x)在[a,b]内的局部极小值点。
%   这里fun 可直接用字符串表示，也可以是m函数名。
%x=fmin('fun',a,b,options)输入options是优化中算法参数向量设置,
%          用help foptions可看到各分量的含义。
%x=fmin('fun',a,b,options,p1,p2,…) p1,p2,..是表示fun的M函数中的参数。
%[x,options]=fmin('fun',a,b,…)输出options显示算法参数。
%例题  求f(x)=x^3-x-1在[-1,1]内的极大值点。
% 先写M函数optfun.m  
%         function  f=optfun(x)
%         f=-(x.^3-x-1);
% 求解
%  clear; 
%  [x,options]=fmin('optfun',-1,1);
%  x,-options(8)

%FMIN   Minimize function of one variable.
%   X = FMIN('F',x1,x2) attempts to return a value of x which is a local 
%   minimizer of F(x) in the interval x1 < x < x2.  'F' is a string 
%   containing the name of the objective function to be minimized.
%
%   X = FMIN('F',x1,x2,OPTIONS) uses a vector of control parameters.
%   If OPTIONS(1) is positive, intermediate steps in the solution are
%   displayed; the default is OPTIONS(1) = 0.  OPTIONS(2) is the termination
%   tolerance for x; the default is 1.e-4.  OPTIONS(14) is the maximum
%   number of function evaluations; the default is OPTIONS(14) = 500.  
%   The other components of OPTIONS are not used as input control 
%   parameters by FMIN.  For more information, see FOPTIONS.
%
%   X = FMIN('F',x1,x2,OPTIONS,P1,P2,...) provides for additional
%   arguments which are passed to the objective function, F(X,P1,P2,...)
%
%   [X,OPTIONS] = FMIN(...) returns a count of the number of steps
%   taken in OPTIONS(10).
%
%   Examples
%       fmin('cos',3,4) computes pi to a few decimal places.
%       fmin('cos',3,4,[1,1.e-12]) displays the steps taken
%       to compute pi to about 12 decimal places.
%
%   See also FMINS.

%   Reference: "Computer Methods for Mathematical Computations",
%   Forsythe, Malcolm, and Moler, Prentice-Hall, 1976.

%   Original coding by Duane Hanselman, University of Maine.
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.14 $  $Date: 1997/11/21 23:30:43 $

% initialization
if nargin<4, options = []; end
options = foptions(options);
print = options(1);
tol = options(2);
if (~options(14))
    options(14) = 500; 
  end
if nargin < 3
  error('fmin requires three input arguments.')
end

header = ' Func evals     x           f(x)         Procedure';
step='       initial';

% Convert to inline function as needed.
funfcn = fcnchk(funfcn,length(varargin));

num = 1;
seps = sqrt(eps);
c = 0.5*(3.0 - sqrt(5.0));
a = ax; b = bx;
v = a + c*(b-a);
w = v; xf = v;
d = 0.0; e = 0.0;
x= xf; fx = feval(funfcn,x,varargin{:});  
fmin_data = [ 1 xf fx ];
if print > 0
    disp(header)
    disp([sprintf('%5.0f   %12.6g %12.6g ',fmin_data), step]) 
end
fv = fx; fw = fx;
xm = 0.5*(a+b);
tol1 = seps*abs(xf) + tol/3.0;   tol2 = 2.0*tol1;

% Main loop

options(10) = 0; 
while ( abs(xf-xm) > (tol2 - 0.5*(b-a)) )

    num = num+1;
    gs = 1;

    % Is a parabolic fit possible
    if abs(e) > tol1
        % Yes, so fit parabola
        gs = 0;
        r = (xf-w)*(fx-fv);
        q = (xf-v)*(fx-fw);
        p = (xf-v)*q-(xf-w)*r;
        q = 2.0*(q-r);
        if q > 0.0,  p = -p; end
        q = abs(q);
        r = e;  e = d;

        % Is the parabola acceptable
        if ( (abs(p)<abs(0.5*q*r)) & (p>q*(a-xf)) & (p<q*(b-xf)) )

            % Yes, parabolic interpolation step
            d = p/q;
            x = xf+d;
            step = '       parabolic';
     
            % f must not be evaluated too close to ax or bx
            if ((x-a) < tol2) | ((b-x) < tol2)
                si = sign(xm-xf) + ((xm-xf) == 0);
                d = tol1*si;
            end
        else
            % Not acceptable, must do a golden section step
            gs=1;
        end
    end
    if gs
        % A golden-section step is required
        if xf >= xm, e = a-xf;    else, e = b-xf;  end
            d = c*e;
            step = '       golden';
    end

    % The function must not be evaluated too close to xf
    si = sign(d) + (d == 0);
    x = xf + si * max( abs(d), tol1 );
    fu = feval(funfcn,x,varargin{:});  
    fmin_data = [num x fu];
    if print > 0
        disp([sprintf('%5.0f   %12.6g %12.6g ',fmin_data), step]) 
    end

    % Update a, b, v, w, x, xm, tol1, tol2
    if fu <= fx
        if x >= xf, a = xf; else, b = xf; end
        v = w; fv = fw;
        w = xf; fw = fx;
        xf = x; fx = fu;
    else % fu > fx
        if x < xf, a = x; else,b = x; end
        if ( (fu <= fw) | (w == xf) )
            v = w; fv = fw;
            w = x; fw = fu;
        elseif ( (fu <= fv) | (v == xf) | (v == w) )
            v = x; fv = fu;
        end
    end
    xm = 0.5*(a+b);
    tol1 = seps*abs(xf) + tol/3.0; tol2 = 2.0*tol1;
    if num > options(14)
        if options(1) >= 0
        disp('Warning: Maximum number of function evaluations has been');
        disp('         exceeded - increase options(14).')
        options(10)=num;
        return
        end
    end
end
options(8) = feval(funfcn,x,varargin{:});
options(10)=num;
