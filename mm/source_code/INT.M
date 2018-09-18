function r = int(f,x,a,b)
%符号积分法
%  int(s)符号表达式s的不定积分.
%  int(s,v)符号表达式s关于变量v的不定积分.
%  int(s,a,b)符号表达式s的定积分, a,b分别为上﹑下限.
%  int(s,v,a,b)符号表达式s关于变量v从 a到b的定积分.
%  当int求不出符号解,会自动转求数值解.
%例（ 求不出符号解,会自动转求数值解）
%    syms x;t=int(exp(-x^sin(x)),0,1),vpa(t,5)
%  结果为
%    Warning: Explicit integral could not be found.
%    > In D:\MATLAB5\toolbox\symbolic\@sym\int.m at line 58
%    t =
%    int(exp(-x^sin(x)),x = 0 .. 1)%表示无解析解
%    ans =
%      .45491                      %数值解
%更多的例子见下列英文部分
%
%INT    Integrate.
%   INT(S) is the indefinite integral of S with respect to its symbolic
%     variable as defined by FINDSYM. S is a SYM (matrix or scalar).
%     If S is a constant, the integral is with respect to 'x'.
%   INT(S,v) is the indefinite integral of S with respect to v. v is a
%     scalar SYM.
%   INT(S,a,b) is the definite integral of S with respect to its
%     symbolic variable from a to b. a and b are each double or
%     symbolic scalars.
%   INT(S,v,a,b) is the definite integral of S with respect to v
%     from a to b.
%
%   Examples:
%     syms x x1 alpha u t;
%     A = [cos(x*t),sin(x*t);-sin(x*t),cos(x*t)];
%     int(1/(1+x^2))           returns     atan(x)
%     int(sin(alpha*u),alpha)  returns     -cos(alpha*u)/u
%     int(besselj(1,x),x)      returns     -besselj(0,x)
%     int(x1*log(1+x1),0,1)    returns      1/4
%     int(4*x*t,x,2,sin(t))    returns      2*sin(t)^2*t-8*t
%     int([exp(t),exp(alpha*t)])  returns  [exp(t), 1/alpha*exp(alpha*t)]
%     int(A,t)                 returns      [sin(x*t)/x, -cos(x*t)/x]
%                                           [cos(x*t)/x,  sin(x*t)/x]

%   Copyright (c) 1993-98 by The MathWorks, Inc.
%   $Revision: 1.15 $  $Date: 1997/11/29 01:05:44 $pj costa

f = sym(f);

if nargin <= 2
   % Indefinite integral
   if nargin < 2
      x = findsym(f,1);
      if isempty(x), x = 'x'; end
   else
      x = char(sym(x));
   end
   r = maple('map','int',f,x);
else
   % Definite integral
   if nargin < 4
      b = a;
      a = x;
      x = findsym(f,1);
      if isempty(x), x = 'x'; end
   end
   x = sym(x);
   b = sym(b);
   a = sym(a);
   r = maple('map','int',f,[x.s '=' a.s '..' b.s]);
end

if ~isempty(findstr('int(',char(r)))
   for k = 1:prod(size(r));
      rc = char(r(k));
      if length(rc) >= 4 & isequal(rc(1:4),'int(')
         warning('Explicit integral could not be found.')
      end
   end
end
