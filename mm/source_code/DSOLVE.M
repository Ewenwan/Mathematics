function varargout = dsolve(varargin)
%s=dsolve('方程1','方程2',...,'初始条件1','初始条件2',...,'自变量').
%      均用字符串方式表示,自变量缺省值为t.
%      导数用D表示,2阶导数用D2表示,以此类推.
%      s返回解析解.方程组情形,s为一个符号结构.
%
%DSOLVE Symbolic solution of ordinary differential equations.
%   DSOLVE('eqn1','eqn2', ...) accepts symbolic equations representing
%   ordinary differential equations and initial conditions.  Several
%   equations or initial conditions may be grouped together, separated
%   by commas, in a single input argument.
%
%   By default, the independent variable is 't'. The independent variable
%   may be changed from 't' to some other symbolic variable by including
%   that variable as the last input argument.
%
%   The letter 'D' denotes differentiation with respect to the independent
%   variable, i.e. usually d/dt.  A "D" followed by a digit denotes
%   repeated differentiation; e.g., D2 is d^2/dt^2.  Any characters
%   immediately following these differentiation operators are taken to be
%   the dependent variables; e.g., D3y denotes the third derivative
%   of y(t). Note that the names of symbolic variables should not contain
%   the letter "D".
%
%   Initial conditions are specified by equations like 'y(a)=b' or
%   'Dy(a) = b' where y is one of the dependent variables and a and b are
%   constants.  If the number of initial conditions given is less than the
%   number of dependent variables, the resulting solutions will obtain
%   arbitrary constants, C1, C2, etc.
%
%   Three different types of output are possible.  For one equation and one
%   output, the resulting solution is returned, with multiple solutions to
%   a nonlinear equation in a symbolic vector.  For several equations and
%   an equal number of outputs, the results are sorted in lexicographic
%   order and assigned to the outputs.  For several equations and a single
%   output, a structure containing the solutions is returned.
%
%   If no closed-form solution is found, a warning is given.
%
%   Examples:
%
%      dsolve('Dx = -a*x') returns
%
%        ans = exp(-a*t)*C1
%
%      x = dsolve('Dx = -a*x','x(0) = 1','s') returns
%
%        x = exp(-a*s)
%
%      y = dsolve('(Dy)^2 + y^2 = 1','y(0) = 0') returns
% 
%        y =
%        [  sin(t)]
%        [ -sin(t)]
%
%      S = dsolve('Df = f + g','Dg = -f + g','f(0) = 1','g(0) = 2')
%      returns a structure S with fields
%
%        S.f = exp(t)*cos(t)+2*exp(t)*sin(t)
%        S.g = -exp(t)*sin(t)+2*exp(t)*cos(t)
%
%      dsolve('Df = f + sin(t)', 'f(pi/2) = 0')
%      dsolve('D2y = -a^2*y', 'y(0) = 1, Dy(pi/a) = 0')
%      S = dsolve('Dx = y', 'Dy = -x', 'x(0)=0', 'y(0)=1')
%      S = dsolve('Du=v, Dv=w, Dw=-u','u(0)=0, v(0)=0, w(0)=1')
%      w = dsolve('D3w = -w','w(0)=1, Dw(0)=0, D2w(0)=0')
%
%   See also SOLVE, SUBS.

%   Copyright (c) 1993-98 by The MathWorks, Inc.
%   $Revision: 1.26 $  $Date: 1997/11/29 01:06:23 $pj costa

narg = nargin;

% The default independent variable is t.
x = 't';
% Pick up the independent variable, if specified.
if all(varargin{narg} ~= '='),
   x = varargin{narg}; narg = narg-1;
end;

% Concatenate equation(s) and initial condition(s) inputs into SYS.
sys = varargin{1};
for k = 2: narg
   sys = [sys ', ' varargin{k}];;
end

% Break SYS into pieces. Each such piece, Dstr, begins with the first
% character following a "D" and ends with the character preceding the
% next consecutive "D". Loop over each Dstr and do the following:
%   o add to the list of dependent variables
%   o replace derivative notation. E.g., "D3y" --> "(D@@3)y"
%
% A dependent variable is defined as a variable that is preceded by "Dk",
% where k is an integer.
%
% new_sys looks like:  eqn(s), initial condition(s)  (i.e., no brackets)
% var_set looks like: { x(t), y2(t), ... }           (i.e., with brackets)

var_set = '{';   % string representing Maple set of dependent variables

% Add dummy "D" so that last Dstr acts like all Dstr's
d = [find(sys == 'D') length(sys)+1];

new_sys = sys(1:d-1);   % SYS rewritten with (D@@k)y notation

for kd = 1:length(d)-1
   Dstr = sys(d(kd)+1:d(kd+1)-1);
   iletter = find(isletter(Dstr));    % index to letters in Dstr

   % Replace Dky with (D@@k)y
   if iletter(1)==1    % First derivative case (Dy)
      new_sys = [new_sys '(D' Dstr(1:iletter(1)-1) ')' Dstr(iletter(1):end)];
   else
      new_sys = [new_sys '(D@@' Dstr(1:iletter(1)-1) ')' Dstr(iletter(1):end)];
   end

   % Store the dependent variable. Find this variable by looking at the
   % characters following the derivative order and pulling off the first
   % consecutive chunk of alphanumeric characters.
   Dstr1 = Dstr(iletter(1):end);
   ialphanum = find(~isletter(Dstr1) & (Dstr1 < '0' | Dstr1 > '9'));
   var_set = [var_set Dstr1(1:ialphanum(1)-1) ','];
end

% Get rid of duplicate entries in var_set
var_set(end) = '}';
var_set = maple([var_set ' intersect ' var_set]);

% Generate var_str, the Maple string representing the set of dependent
%    variables.
% Replace all dependent variables with their functional equivalents,
%    i.e., replace y -> (y)(x).

% Break the system string into its equation and initial condition parts.
% This is done by looking for the first occurrence of "y(", where y is a
% dependent variable.
indx_ic = length(new_sys);   % points to starting character of ic string
ic_str = [];                 % initialize the initial condition string
eq_str = new_sys;            % initialize the equation string
var_str = '{';                          % Maple set of dependent variables
vars = [',' var_set(2:end-1) ','];      % preceding comma delimits variable
vars(find(vars==' '))=[];               % deblank
kommas = find(vars==',');

for k = 1: length(kommas)-1
   v = vars(kommas(k)+1:kommas(k+1)-1);  % v is a dependent variable

   % Add to set of dependent variables.
   var_str = [var_str v '(' x '),'];

   % Look for first occurrence of "v(". If it's before the first occurrence
   % of the previous dependent variable, change value of indx_ic and
   % shorten the equation string.
   indx = findstr(eq_str, [v '(']);     % index to current dependent var.
   if isempty(indx), indx = indx_ic; end
   indx_ic = min(indx_ic,indx(1));
   eq_str = new_sys(1:min(indx_ic));
end

% Finish var_str
var_str(end) = '}';

% Stuff after the last comma belongs in the initial condition string
if indx_ic < length(new_sys)
   last_comma = max(find(eq_str==','));
   ic_str = new_sys(last_comma:end);
   eq_str = eq_str(1: last_comma-1);
end

% In the equation string, replace all occurrences of "y" with "(y)(x)".
for j = 1:length(kommas)-1
   v = vars(kommas(j)+1:kommas(j+1)-1);
   m = length(v);
   e = length(eq_str);
   for k = fliplr(findstr(v,eq_str))
      if k+m > e | ~isvarname(eq_str(k:k+m))
         eq_str = [eq_str(1:k-1) '(' v ')(' x ')' eq_str(k+m:end)];
      end
   end
end

% In the ic string, replace all occurrences of "y" with "(y)".
for j = 1:length(kommas)-1
   v = vars(kommas(j)+1:kommas(j+1)-1);
   m = length(v);
   e = length(ic_str);
   for k = fliplr(findstr(v,ic_str))
      if k+m > e | ~isvarname(ic_str(k:k+m))
         ic_str = [ic_str(1:k-1) '(' v ')' ic_str(k+m:end)];
      end
   end
end

% Convert system to rational form and solve
[R,stat] = maple('dsolve', ...
   ['convert({',eq_str,ic_str,'},fraction)'], var_str, 'explicit');
if stat
   error(R)
end

% If no solution, give up.

if isempty(R) | ~isempty(findstr(R,'DESol'))
   warning('Explicit solution could not be found.');
   varargout = cell(1,nargout);
   varargout{1} = sym([]);
   return
end

% Eliminate underscores in constants.

R(findstr(R,'_C')) = [];

% Parse the result.

if R(1) ~= '{', R = ['{' R '}']; end
vars(1) = '['; vars(end) = ']';
vars = maple('sort',vars);
vars(1) = '{'; vars(end) = '}';
nvars = sum(commas(vars))+1; 

if nvars == 1 & nargout <= 1

   % One variable and at most one output.
   % Return a single scalar or vector sym.

   S = sym([]);
   c = find(commas(R) | R == '}');
   for p = find(R == '=')
      q = min(c(c>p));
      t = trim(R(p+1:q-1));
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
      v = trim(R(q+1:p-1));
      v(findstr(v,'('):findstr(v,')')) = [];
      q = min(c(c>p));
      t = trim(R(p+1:q-1));
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

function s = trim(s);
%TRIM  TRIM(s) deletes any leading or trailing blanks.
while s(1) == ' ', s(1) = []; end
while s(end) == ' ', s(end) = []; end


function c = commas(s)
%COMMAS  COMMAS(s) is true for commas not inside parentheses.
p = cumsum((s == '(') - (s == ')'));
c = (s == ',') & (p == 0);
