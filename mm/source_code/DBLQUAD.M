function result=dblquad(intfcn,inmin,inmax,outmin,outmax,tol,method) 
%矩形区域二重积分.
%z=dblquad('Fun',a,b,c,d)
%   其中：Fun-表示被积函数f的M函数名.
%         a,b-变量x的上﹑下限.
%         c,d-变量y的上﹑下限.
%
%DBLQUAD Numerically evaluate double integral. 
%   RESULT = DBLQUAD('FUN',INMIN,INMAX,OUTMIN,OUTMAX) evaluates the
%   double integral FUN(INNER,OUTER) using the QUAD quadrature function,
%   where INNER is the inner variable ranging from INMIN to INMAX, and
%   OUTER is the outer variable ranging from OUTMIN to OUTMAX. The first
%   argument 'FUN' is a string, or inline object, representing the integrand
%   function.  This function must be a function of two variables of the form
%   FOUT=FUN(INNER,OUTER).  The function must take a vector INNER and a
%   scalar OUTER and return a vector FOUT that is the function evaluated
%   at OUTER and each value of INNER.
%
%   RESULT = DBLQUAD('FUN',INMIN,INMAX,OUTMIN,OUTMAX,TOL) passes
%   TOL to the QUAD function. See the help entry for QUAD for a
%   description of the parameter TOL.
%
%   RESULT = DBLQUAD('FUN',INMIN,INMAX,OUTMIN,OUTMAX,TOL,METHOD)
%   passes TOL to the QUAD or QUAD8 function depending on the value
%   of the string METHOD.  Valid values for METHOD are 'quad' and
%   'quad8', or the name of any user-defined quadrature method with the
%   same calling and return arguments as QUAD or QUAD8.
%
%   Example:
%       result = dblquad('integrnd', pi, 2*pi, 0, pi) integrates
%       the function y*sin(x)+x*cos(y), where x ranges from 
%       pi to 2*pi and y ranges from 0 to pi, assuming x is the 
%       inner variable and y is the outer variable in the 
%       integration, and assuming the M-file integrnd.m is 
%       defined as:
%           function out = integrnd(x, y)
%           out = y*sin(x)+x*cos(y);  
%       Note that integrnd.m is valid when x is a vector and y is 
%       a scalar. Also, x must be the first argument to integrnd.m
%       since it is the inner variable.
%
%   See also QUAD,QUAD2, QUAD8, INLINE. 

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1997/11/21 23:30:41 $

% Determine input arguments. 
if nargin < 5 
  error('Requires at least five inputs'); 
elseif ~isstr(intfcn) & ~isa(intfcn,'inline')
  error(sprintf(['First argument must be a string, or inline object,'...
        ' representing\n the integrand function.'])); 
end

if nargin < 7, method = 'quad'; end
if nargin < 6, tol = []; end 

% Pass the necessary information to INNERLP. INNERLP 
% evaluates the inner loop. Note that we pass TOL 
% twice; once to QUAD (QUAD8) directly, and once indirectly to 
% INNERLP so that INNERLP can again pass it to QUAD (QUAD8) 
% directly. We have to pass a placeholder to QUAD (QUAD8) for trace,
% but not to INNERLP.

trace = [];
result= feval(method,'innerlp', outmin, outmax, tol, trace, intfcn, ...
           inmin, inmax, tol, method); 
