function [x, options] = fmins(funfcn,x,options,grad,varargin)
%¶àÔªº¯Êı¼«ÖµËü²ÉÓÃµ¥´¿ĞÔËÑË÷·¨£¬ÊÊÓÃÓÚ·Ç¹â»¬º¯ÊıÓÅ»¯¡£
%x=fmins('fun',x0)Å£¶Ù·¨Çó¶àÔªº¯Êıy=f(x)ÔÚx0³ö·¢µÄ¾Ö²¿¼«Ğ¡Öµµã£
%   ÕâÀï x,x0¾ùÎªÏòÁ¿¡£ 
%x=fmins('fun',x0,options)ÊäÈëoptionsÊÇÓÅ»¯ÖĞËã·¨²ÎÊıÏòÁ¿ÉèÖÃ,
%          ÓÃhelp foptions¿É¿´µ½¸÷·ÖÁ¿µÄº¬Òå¡£
%x=fmins('fun',x0,options,'grad') grad¸ø¶¨f(x)µÄÌİ¶Èº¯Êı±í´ïÊ½¼Ó¿ì¼ÆËãËÙ¶È¡£
%x=fmins('fun',x0,options,'grad',p1,p2¡­)p1,p2,..ÊÇ±íÊ¾funµÄMº¯ÊıÖĞµÄ²ÎÊı¡£
% ×¢Òâ£º·½³Ì±äÁ¿±ØĞëÆ´³ÉÒ»¸öÏòÁ¿±äÁ¿£¬¼´ÓÃx(1),x(2),...
%
%ÀıÌâ  Çóf(x)=100(y-x^2)^2+(1-x)^2ÔÚ[-1.2,1]¸½½üµÄ¼«Ğ¡Öµ¡£
% ÏÈĞ´Mº¯Êıoptfun1.m  
%         function  f=optfun1(x)
%         f=100*(x(2)-x(1).^2).^2+(1-x(1)).^2
% Çó½â
%  clear;
%  x=[-1.2,1];
%  [x,options]=fmins('optfun1',x,options);
%  x,options(8)
%
%FMINS  Minimize function of several variables.
%   X = FMINS('F',X0) attempts to return a vector X which is a local
%   minimizer of F(x) near the starting vector X0.  'F' is a string
%   containing the name of the objective function to be minimized,
%   a string expression representing the objective function, or an
%   inline function object. F(x) should be a scalar valued function 
%   of a vector variable.
%
%   X = FMINS('F',X0,OPTIONS) uses a vector of control parameters. If
%   OPTIONS(1) is positive, intermediate steps in the solution are
%   displayed; the default is OPTIONS(1) = 0.  OPTIONS(2) is the
%   termination tolerance for x; the default is 1.e-4.  OPTIONS(3) is
%   the termination tolerance for F(x); the default is 1.e-4.
%   OPTIONS(14) is the maximum number of function evaluations; the 
%   default is OPTIONS(14) = 200*length(x). The other components of 
%   OPTIONS are not used by FMINS. For more information, see FOPTIONS.
%
%   X = FMINS('F',X0,OPTIONS,[],P1,P2,...) provides for additional
%   arguments which are passed to the objective function, F(X,P1,P2,...)
%   Pass an empty matrix for OPTIONS to use the default values.
%
%   [X,OPTIONS] = FMINS(...) returns the number of function evaluations
%   in OPTIONS(10).
%
%   FMINS uses the Nelder-Mead simplex (direct search) method.
%
%   See also FMIN, FOPTIONS. 

%   Reference: Jeffrey C. Lagarias, James A. Reeds, Margaret H. Wright,
%   Paul E. Wright, "Convergence Properties of the Nelder-Mead Simplex
%   Algorithm in Low Dimensions", May 1, 1997.  To appear in the SIAM 
%   Journal of Optimization.
%
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.14 $  $Date: 1997/11/21 23:30:44 $

if nargin<3, options = []; end
options = foptions(options);
prnt = options(1);
tolx = options(2); 
tolf = options(3);
% The input argument grad is there for compatability with FMINU in
% the Optimization Toolbox, but is not used by this function.

% Convert to inline function as needed.
funfcn = fcnchk(funfcn,length(varargin));

n = prod(size(x));
if (~options(14)) 
   options(14) = 200*n; 
end

% Initialize parameters
rho = 1; chi = 2; psi = 0.5; sigma = 0.5;
onesn = ones(1,n);
two2np1 = 2:n+1;
one2n = 1:n;

% Set up a simplex near the initial guess.
xin = x(:); % Force xin to be a column vector
v = zeros(n,n+1); fv = zeros(1,n+1);
v = xin;    % Place input guess in the simplex! (credit L.Pfeffer at Stanford)
x(:) = xin;    % Change x to the form expected by funfcn 
fv = feval(funfcn,x,varargin{:}); 

% Following improvement suggested by L.Pfeffer at Stanford
usual_delta = 0.05;             % 5 percent deltas for non-zero terms
zero_term_delta = 0.00025;      % Even smaller delta for zero elements of x
for j = 1:n
   y = xin;
   if y(j) ~= 0
      y(j) = (1 + usual_delta)*y(j);
   else 
      y(j) = zero_term_delta;
   end  
   v(:,j+1) = y;
   x(:) = y; f = feval(funfcn,x,varargin{:});
   fv(1,j+1) = f;
end     

% sort so v(1,:) has the lowest function value 
[fv,j] = sort(fv);
v = v(:,j);

func_evals = n+1;
if prnt > 0
   clc
   formatsave = get(0,{'format','formatspacing'});
   format compact
   format short e
   disp(' ')
   disp('initial')
   v
   fv
   func_evals
end

% Main algorithm
% Iterate until the diameter of the simplex is less than tolx
%   AND the function values differ from the least by less than tolf,
%   or the max function evaluations are exceeded.
while func_evals < options(14)
   if max(max(abs(v(:,two2np1)-v(:,onesn)))) <= tolx &...
         max(abs(fv(1)-fv(two2np1))) <= tolf
      break
   end
   how = '';
   
   % Compute the reflection point
   
   % xbar = average of the n (NOT n+1) best points
   xbar = sum(v(:,one2n), 2)/n;
   xr = (1 + rho)*xbar - rho*v(:,end);
   x(:) = xr; fxr = feval(funfcn,x,varargin{:});
   func_evals = func_evals+1;
   
   if fxr < fv(:,1)
      % Calculate the expansion point
      xe = (1 + rho*chi)*xbar - rho*chi*v(:,end);
      x(:) = xe; fxe = feval(funfcn,x,varargin{:});
      func_evals = func_evals+1;
      if fxe < fxr
         v(:,end) = xe;
         fv(:,end) = fxe;
         how = 'expand';
      else
         v(:,end) = xr; 
         fv(:,end) = fxr;
         how = 'reflect';
      end
   else % fv(:,1) <= fxr
      if fxr < fv(:,n)
         v(:,end) = xr; 
         fv(:,end) = fxr;
         how = 'reflect';
      else % fxr >= fv(:,n) 
         % Perform contraction
         if fxr < fv(:,end)
            % Perform an outside contraction
            xc = (1 + psi*rho)*xbar - psi*rho*v(:,end);
            x(:) = xc; fxc = feval(funfcn,x,varargin{:});
            func_evals = func_evals+1;
            
            if fxc <= fxr
               v(:,end) = xc; 
               fv(:,end) = fxc;
               how = 'contract outside';
            else
               % perform a shrink
               how = 'shrink'; 
            end
         else
            % Perform an inside contraction
            xcc = (1-psi)*xbar + psi*v(:,end);
            x(:) = xcc; fxcc = feval(funfcn,x,varargin{:});
            func_evals = func_evals+1;
            
            if fxcc < fv(:,end)
               v(:,end) = xcc;
               fv(:,end) = fxcc;
               how = 'contract inside';
            else
               % perform a shrink
               how = 'shrink';
            end
         end
         if strcmp(how,'shrink')
            for j=two2np1
               v(:,j)=v(:,1)+sigma*(v(:,j) - v(:,1));
               x(:) = v(:,j); fxcc = feval(funfcn,x,varargin{:});
            end
            func_evals = func_evals + n;
         end
      end
   end
   [fv,j] = sort(fv);
   v = v(:,j);
   if prnt > 0
      disp(' ')
      disp(how)
      v
      fv
      func_evals
   end  
end   % while


x(:) = v(:,1);
if prnt > 0,
   % reset format
   set(0,{'format','formatspacing'},formatsave);
end
options(10)=func_evals;
options(8)=min(fv); 
if func_evals >= options(14) 
   if options(1) >= 0
      disp(' ')
      disp(['Maximum number of function evaluations (', ...
            int2str(options(14)),') has been exceeded']);
      disp( '         (increase OPTIONS(14)).')
   end
end




