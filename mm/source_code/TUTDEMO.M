echo off
%优化工具箱简明教程
%TUTDEMO Tutorial for Optimization Toolbox.

%   Copyright (c) 1990-98 by The MathWorks, Inc.
%   $Revision: 1.12 $  $Date: 1997/11/29 01:23:27 $

echo on; clc
%TUTDEMO Tutorial for Optimization Toolbox.
%##########################################################################
%
%   This is a demonstration script-file for the OPTIMIZATION TOOLBOX 
%   It closely follows the Tutorial section of the users' guide
%
%   It consists of:
%           (1) unconstrained optimization example
%           (2) constrained optimization example 
%           (3) constrained example using gradients
%           (4) bounded example
%           (5) equality constrained example
%           (6) unconstrained example using user-supplied settings
%
%   All the principles outlined in this demonstration apply to the other
%   routines: attgoal, minimax, leastsq, fsolve.
%
%   The routines differ from the Tutorial Section examples in the manual 
%   only in that M-files for the objective functions have not been coded 
%   up. Instead the expression form of the syntax has been used where
%   functions to be minimized are expressed as MATLAB string variables. 
%
%##########################################################################

pause % Strike any key to continue (Note: use Ctrl-C to abort)
clc
%##########################################################################
%           DEMO 1: UNCONSTRAINED PROBLEM
%--------------------------------------------------------------------------
%
%   Consider initially the problem of finding a minimum to the function:
%
%                                2        2
%       f(x) = exp(x(1)) . (4x(1)  + 2x(2)  + 4x(1).x(2) + 2x(2) + 1)
%
%--------------------------------------------------------------------------
pause % Strike any key to continue

% The function to be minimized is

fun = 'exp(x(1)) * (4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1)';

pause % Strike any key to continue

% Take a guess at the solution

x0 = [-1 1];

pause % Strike any key to continue

% Use default parameters

options = [];

pause % Strike any key to start the optimization

[x, options] = fminu(fun, x0, options);

%  The optimizer has found a solution at:
x
pause % Strike any key to continue

%  The function value at the solution is:
options(8)
pause % Strike any key to continue

%  The total number of function evaluations was: 
options(10)
% Note: by entering the expression explicitly in a string using
% the variable 'x' we avoid having to write an M-file.

pause % Strike any key for next demo
clc
%##########################################################################
%           DEMO 2: CONSTRAINED PROBLEM
%--------------------------------------------------------------------------
%
%   Consider the above problem with two additional constraints:
%
%                                      2        2
%   minimize  f(x) = exp(x(1)) . (4x(1)  + 2x(2)  + 4x(1).x(2) + 2x(2) + 1)
%
%   subject to  1.5 + x(1).x(2) - x(1) - x(2) <= 0
%                   - x(1).x(2)               <= 10
%
%--------------------------------------------------------------------------
pause % Strike any key to continue

% Objective Function and constraints

funf = 'f = exp(x(1)) * (4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1);';
fung = 'g = [1.5 + x(1)*x(2) - x(1) - x(2); -x(1)*x(2) - 10];';
fun = [funf fung];

pause % Strike any key to continue

% Take a guess at the solution

x0 = [-1 1];

pause % Strike any key to continue

% Use default parameters

options = [];

pause % Strike any key to start the optimization

[x, options] = constr(fun, x0, options);

% A solution to this problem has been found at:
x 
pause % Strike any key to continue

% The function value at the solution is: 
options(8)
pause % Strike any key to continue

% Both the constraints are active at the solution:
g = [1.5 + x(1)*x(2) - x(1) - x(2); - x(1)*x(2) - 10]
pause % Strike any key to continue

% The total number of function evaluations was: 
options(10)
pause % Strike any key for next demo
clc
%##########################################################################
%           DEMO 3: BOUNDED EXAMPLE
%--------------------------------------------------------------------------
%
%   Consider the above problem with additional bound constraints:
%
%                                      2        2
%   minimize  f(x) = exp(x(1)) . (4x(1)  + 2x(2)  + 4x(1).x(2) + 2x(2) + 1)
%
%   subject to  1.5 + x(1).x(2) - x(1) - x(2) <= 0
%                   - x(1).x(2)               <= 10
%
%          and                    x(1)        >= 0
%                                        x(2) >= 0
%
%--------------------------------------------------------------------------
pause % Strike any key to continue

% Objective Function and constraints

funf = 'f = exp(x(1)) * (4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1);';
fung = 'g = [1.5 + x(1)*x(2) - x(1) - x(2); -x(1)*x(2) - 10];';
fun = [funf fung];

pause % Strike any key to continue

% Again, make a guess at the solution
  
x0 = [-1 1];

pause % Strike any key to continue

% Use default parameters

options = [];

pause % Strike any key to continue

% This time we will use the bounded syntax:
% X = CONSTR(`FUN', X0, OPTIONS, VLB, VUB) 

vlb = zeros(1,2); % Lower bounds X >= 0
vub = [];         % No upper bounds 

pause % Strike any key to start the optimization

[x, options] = constr(fun, x0, options, vlb, vub);

% The solution to this problem has been found at:
x 
pause % Strike any key to continue

% The function value at the solution is: 
options(8)
pause % Strike any key to continue

% The constraint values at the solution are:
g = [1.5 + x(1)*x(2) - x(1) - x(2); - x(1)*x(2) - 10]
pause % Strike any key to continue

% The total number of function evaluations was: 
options(10)
pause % Strike any key for next demo
clc
%##########################################################################
%           DEMO 4: USER-SUPPLIED GRADIENTS
%--------------------------------------------------------------------------
%  The above problem can be solved more efficiently and accurately if
%  gradients are supplied by the user. This demo shows how this may be
%  performed.
%
%  Again the problem is:
%                                      2        2
%   minimize  f(x) = exp(x(1)) . (4x(1)  + 2x(2)  + 4x(1).x(2) + 2x(2) + 1)
%
%   subject to  1.5 + x(1).x(2) - x(1) - x(2) <= 0
%                   - x(1).x(2)               <= 10
%
%--------------------------------------------------------------------------
pause % Strike any key to continue

% Objective function and constraints

funf = 'f = exp(x(1)) * (4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1);';
fung = 'g = [1.5 + x(1)*x(2) - x(1) - x(2); -x(1)*x(2) - 10];';
fun = [funf fung];

pause % Strike any key to continue

% Make a guess at the solution:
 
x0 = [-1 1];

pause % Strike any key to continue

% Use default parameters

options = [];

pause % Strike any key to continue

% Partial derivatives

dfdx1 = 'exp(x(1))*(4*x(1)^2+2*x(2)^2+4*x(1)*x(2)+2*x(2)+1)+4*exp(x(1))*(2*x(1)+x(2));'; 
dfdx2 = '4*exp(x(1))*(x(1)+x(2)+0.5);';
dfdg = '[x(2)-1, -x(2); x(1)-1, -x(1)];';
grad = ['df=[',dfdx1, dfdx2,']; dg=', dfdg];

pause % Strike any key to start the optimization

[x, options] = constr(fun, x0, options, [], [], grad);

% As before the solution to this problem has been found at:
x 
pause % Strike any key to continue

% The function value at the solution is: 
options(8)
pause % Strike any key to continue

% Both the constraints are active at the solution:
g = [1.5 + x(1)*x(2) - x(1) - x(2); - x(1)*x(2) - 10]
pause % Strike any key to continue

% The total number of function evaluations was: 
options(10)

pause % Strike any key for next demo
clc
%##########################################################################
%           DEMO 5: EQUALITY CONSTRAINED EXAMPLE
%--------------------------------------------------------------------------
%
%   Consider the above problem with an additional equality constraint:
%
%                                      2        2
%   minimize  f(x) = exp(x(1)) . (4x(1)  + 2x(2)  + 4x(1).x(2) + 2x(2) + 1)
%
%   subject to                    x(1) + x(2)  = 0
%               1.5 + x(1).x(2) - x(1) - x(2) <= 0
%                   - x(1).x(2)               <= 10
%
%--------------------------------------------------------------------------
pause % Strike any key to continue

% Objective function and constraints

funf = 'f = exp(x(1)) * (4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1);';
fung = 'g = [x(1) + x(2); 1.5 + x(1)*x(2) - x(1) - x(2); -x(1)*x(2) - 10];';
fun = [funf fung];

pause % Strike any key to continue

% Again, make a guess at the solution

x0 = [-1 1];

pause % Strike any key to continue

% This time we will indicate the number of equality constraints
% by setting options(13) to the number of constraints.  The equality
% constraints must be contained the in first few elements of g.

% One equality constraint

clear options
options(13) = 1;

pause % Strike any key to start the optimization

[x, options] = constr(fun, x0, options);

% The solution to this problem has been found at:
x 
pause % Strike any key to continue

% The function value at the solution is: 
options(8)
pause % Strike any key to continue

% The constraint values at the solution are:
g = [x(1) + x(2); 1.5 + x(1)*x(2) - x(1) - x(2); -x(1)*x(2) - 10]
pause % Strike any key to continue

% The total number of function evaluations was: 
options(10)

pause % Strike any key for next demo
clc
%##########################################################################
%           DEMO 6: CHANGING THE DEFAULT SETTINGS
%--------------------------------------------------------------------------
%
%   Consider the original unconstrained problem:
%
%                                      2        2
%   minimize  f(x) = exp(x(1)) . (4x(1)  + 2x(2)  + 4x(1).x(2) + 2x(2) + 1)
%
%   This time we will solve it more accurately by overriding the 
%   default termination criteria (OPTIONS(2) and OPTIONS(3)). 
%--------------------------------------------------------------------------
pause % Strike any key to continue

% The function to be minimized is

fun = 'exp(x(1)) * (4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1)';

pause % Strike any key to continue

% Again, make a guess at the solution:

x0 = [-1 1];

pause % Strike any key to continue

% Override the default termination criteria:
clear options
options(2) = 1e-8;    % Termination tolerance on X
options(3) = 1e-8;    % Termination tolerance on F

pause % Strike any key to start the optimization

[x, options] = fminu(fun, x0, options);

%  The optimizer has found a solution at:
x
pause % Strike any key to continue

%  The function value at the solution is:
options(8)
pause % Strike any key to continue

%  The total number of function evaluations was: 
options(10)
%   Note: warning messages may be displayed because of problems
%   in the calculation of finite difference gradients at the 
%   solution point. They are an indication that tolerances are overly 
%   stringent, however, the optimizer always continues to make steps 
%   towards the solution. 

pause % Strike any key to continue

% If we want a tabular display of each iteration we can set
% options(1) = 1 as follows:

options = 1;  % Set display parameter to on, the others to default. 

pause % Strike any key to start the optimization

[x, options] = fminu(fun, x0, options);

%  The optimizer has found a solution at:
x
pause % Strike any key to continue

%  The function value at the solution is:
options(8)
pause % Strike any key to continue

%  The total number of function evaluations was: 
options(10)
%  At each major iteration the table displayed consists of: 
%           -   number of function values
%           -   function value
%           -   step length used in the line search
%           -   gradient in the direction of search
%

%------------------------------Demo End------------------------------------
pause % Strike any key for main menu
echo off
disp('End of demo')
