function varargout = solve(varargin)
%求各种类型方程组的解析解, 
%当找不到解析解时,将自动寻求原点附近的一个近似解, 并可达任意精度.
%用法
%   solve('方程1','方程2',...,'方程N','变量1','变量2',...,'变量M')
%SOLVE  Symbolic solution of algebraic equations.
%   SOLVE('eqn1','eqn2',...,'eqnN')
%   SOLVE('eqn1','eqn2',...,'eqnN','var1,var2,...,varN')
%   SOLVE('eqn1','eqn2',...,'eqnN','var1','var2',...'varN')
%
%   The eqns are symbolic expressions or strings specifying equations.  The
%   vars are symbolic variables or strings specifying the unknown variables.
%   SOLVE seeks zeros of the expressions or solutions of the equations.
%   If not specified, the unknowns in the system are determined by FINDSYM.
%   If no analytical solution is found and the number of equations equals
%   the number of dependent variables, a numeric solution is attempted.
%
%   Three different types of output are possible.  For one equation and one
%   output, the resulting solution is returned, with multiple solutions to
%   a nonlinear equation in a symbolic vector.  For several equations and
%   an equal number of outputs, the results are sorted in lexicographic
%   order and assigned to the outputs.  For several equations and a single
%   output, a structure containing the solutions is returned.
%
%   Examples:
%
%      solve('p*sin(x) = r') chooses 'x' as the unknown and returns
%
%        ans =
%        asin(r/p)
%
%      [x,y] = solve('x^2 + x*y + y = 3','x^2 - 4*x + 3 = 0') returns
%
%        x =
%        [ 1]
%        [ 3]
%
%        y =
%        [    1]
%        [ -3/2]
%
%      S = solve('x^2*y^2 - 2*x - 1 = 0','x^2 - y^2 - 1 = 0') returns
%      the solutions in a structure.
%
%        S =
%          x: [8x1 sym]
%          y: [8x1 sym]
%
%      [u,v] = solve('a*u^2 + v^2 = 0','u - v = 1') regards 'a' as a
%      parameter and solves the two equations for u and v.
%
%      S = solve('a*u^2 + v^2','u - v = 1','a,u') regards 'v' as a
%      parameter, solves the two equations, and returns S.a and S.u.
%
%      [a,u,v] = solve('a*u^2 + v^2','u - v = 1','a^2 - 5*a + 6') solves
%      the three equations for a, u and v.
%
%      [x,y] = solve('sin(x+y)-exp(x)*y = 0','x^2-y = 2') cannot find
%      an analytic solution, so returns a numeric solution.
%
%   See also DSOLVE.

%   Copyright (c) 1993-98 by The MathWorks, Inc.
%   $Revision: 1.13 $  $Date: 1997/11/29 01:06:35 $

% Set the Explicit solution (for equations of order 4 or less)
% option on in the Maple Workspace.

maple('_EnvExplicit := true;');

% Collect input arguments together in either equation or variable lists.

eqns = [];
vars = [];
for k = 1:nargin
   v = varargin{k};
   if all(isletter(v) | ('0'<=v & v<='9') | v == '_' | v == ',')
      vars = [vars ',' v];
   else
      [t,stat] = maple(v);
      if stat
         error(['''' v ''' is not a valid expression or equation.'])
      end
      eqns = [eqns ',' v];   
   end
end

if isempty(eqns)
   warning('List of equations is empty.')
   varargout = cell(1,nargout);
   varargout{1} = sym([]);
   return
else
   eqns(1) = '{'; eqns(end+1) = '}';
end
neqns = sum(commas(eqns)) + 1;

% Determine default variables and sort variable list.

if isempty(vars)
   vars = ['[' findsym(sym(eqns),neqns) ']'];
else
   vars(1) = '['; vars(end+1) = ']';
end
v = vars;
[vars,stat] = maple('sort',v);
if stat
   error(['''' v ''' is not a valid variable list.'])
end
vars(1) = '{'; vars(end) = '}';
nvars = sum(commas(vars)) + 1;

if neqns ~= nvars
   warning([int2str(neqns) ' equations in ' int2str(nvars) ' variables.'])
end

% Seek analytic solution.

[R,stat] = maple('solve',eqns,vars);

% If no analytic solution, seek numerical solution.

if (isempty(R) & (nvars == neqns))
   [R,stat] = maple('fsolve',eqns,vars);
end

if stat
   error(R)
end

% If still no solution, give up.

if isempty(R) | findstr(R,'fsolve')
   warning('Explicit solution could not be found.');
   varargout = cell(1,nargout);
   varargout{1} = sym([]);
   return
end

% Expand any RootOf.

while ~isempty(findstr(R,'RootOf'))
   k = min(findstr(R,'RootOf'));
   p = findstr(R,'{'); p = max(p(p<k));
   q = findstr(R,'}'); q = min(q(q>k));
   s = R(p:q);
   t = s(min(findstr(s,'RootOf'))+6:end);
   e = min(find(cumsum((t=='(')-(t==')'))==0));
   if isempty(find(commas(t(2:e-1))))
      % RootOf with one argument, possibly an imbedded RootOf.
      [s,stat] = maple('allvalues',s,'dependent');
      if stat
         error(s)
      end
   else
      % RootOf with a good estimate as the second argument.
      s = maple('evalf',s);
   end
   R = [R(1:p-1) s R(q+1:end)];
end

% Parse the result.

if nvars == 1 & nargout <= 1

   % One variable and at most one output.
   % Return a single scalar or vector sym.

   S = sym([]);
   c = find(commas(R) | R == '}');
   for p = find(R == '=')
      q = min(c(c>p));
      t = trim(R(p+1:q-1));  % The solution (xk)
      S = [S; sym(t)];
   end
   varargout{1} = S;

else

   % Several variables.
   % Create a skeleton structure.

   c = [1 find(commas(vars)) length(vars)];
   S = [];
   for j = 1:nvars
      v = trim(vars(c(j)+1:c(j+1)-1));
      S = setfield(S,v,[]);
   end

   % Complete the structure.

   c = [1 find(commas(R) | R == '{' | R == '}') length(R)];
   for p = find(R == '=')
      q = max(c(c<p));
      v = trim(R(q+1:p-1));  % The variable (x)
      q = min(c(c>p));
      t = trim(R(p+1:q-1));  % The solution (xk)
      S = setfield(S,v,[getfield(S,v); sym(t)]);
   end
   
   if nargout <= 1

      % At most one output, return the structure.
      varargout{1} = S;

   elseif nargout == nvars

      % Same number of outputs as variables.
      % Match results in lexicographic order to outputs.
      v = fieldnames(S);
      for j = 1:nvars
         varargout{j} = getfield(S,v{j});
      end

   else
      error([int2str(nvars) ' variables does not match ' ...
             int2str(nargout) ' outputs.'])
   end
end

%-------------------------

function s = trim(s);
%TRIM  TRIM(s) deletes any leading or trailing blanks.
while s(1) == ' ', s(1) = []; end
while s(end) == ' ', s(end) = []; end

%-------------------------

function c = commas(s)
%COMMAS  COMMAS(s) is true for commas not inside parentheses.
p = cumsum((s == '(') - (s == ')'));
c = (s == ',') & (p == 0);
