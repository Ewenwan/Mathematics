function [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD,HESSIAN] = fmincon(FUN,X,A,B,Aeq,Beq,LB,UB,NONLCON,options,varargin)
%求解下列形式非线性规划问题：
%     min f(x)  s.t.  Ax<= b,  Aeqx=beq, 
%                   c(x)<=0, ceq(x) = 0, lb<=x<=ub
%调用格式为：
% x=fmincon(fun, 初值,A,b,Aeq,beq,lb,ub,nonlcon)
%      此时当约束条件中缺A和b、Aeq和beq或lb和ub时，
%       相关项可用[ ]代替以表示省略。
%      fun写成如下的M-函数形式 (fun.m) ：
%                function  f = fun (x)
%                        f = f(x); 
%        非线性约束条件写成如下的M-函数形式 (nonlcon.m) ：
%         function [c,ceq]=nonlcon(x)
%        c = c(x);ceq=ceq(x);
% 注意：方程变量必须拼成一个向量变量，即用x(1),x(2),...
%
%例题
%   max x*y*z
%   -x+x*y+2*z>=0
%   x+2*y+2*z<=72
%   10<=y<=20
%    x-y=10
%  先化为
%   min -x(1)*x(2)*x(3)
%   x(1)+2*x(2)+2*x(3)<=72
%   x(1)-x(2)=10
%   x(1)-x(1)*x(2)-2*x(3)<=0
%   10<=x(2)<=20
%  写M函数 fconfun.m
%          function  f=fconfun(x)
%          f=-x(1)*x(2)*x(3)
%  再写M函数 fconfun2.m
%          function  [g,geq]=fconfun2(x)
%          g=x(1)-x(1)*x(2)-2*x(3);
%          geq=0;
%  求解
%   x0=[10,10,10];
%   A=[1 2 2];b=72;
%   Aeq=[1 -1 0];beq=10;
%   [x,f]=fmincon('fconfun',x0,A,b,Aeq,beq,[-inf,10,-inf]',[inf,20,inf],'fconfun2')
%
%FMINCON Finds the constrained minimum of a function of several variables.
%   FMINCON solves problems of the form:
%       min F(X)  subject to:  A*X  <= B, Aeq*X  = Beq (linear constraints)
%        X                       C(X) <= 0, Ceq(X) = 0   (nonlinear constraints)
%                                LB <= X <= UB            
%                                                           
%   X=FMINCON(FUN,X0,A,B) starts at X0 and finds a minimum X to the function
%   described in FUN, subject to the linear inequalities A*X <= B. X0 may be a 
%   scalar, vector or matrix. The function FUN (usually an M-file or inline object) 
%   should return a scalar function value F evaluated at X when called with 
%   feval: F=feval(FUN,X).
%
%   X=FMINCON(FUN,X0,A,B,Aeq,Beq) minimizes FUN subject to the linear equalities
%   Aeq*X = Beq as well as A*X <= B. (Set A=[] and B=[] if no inequalities exist.)
%
%   X=FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB) defines a set of lower and upper
%   bounds on the design variables, X, so that the solution is in 
%   the range LB <= X <= UB. Use empty matrices for LB and UB
%   if no bounds exist. Set LB(i) = -Inf if X(i) is unbounded below; 
%   set UB(i) = Inf if X(i) is unbounded above.
%
%   X=FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON) subjects the minimization to the 
%   constraints defined in NONLCON. The function NONLCON should return the vectors
%   C and Ceq, representing the nonlinear inequalities and equalities respectively, 
%   when called with feval: [C, Ceq] = feval(NONLCON,X). FMINCON minimizes
%   FUN such that C(X)<=0 and Ceq(X)=0. (Set LB=[] and/or UB=[] if no bounds exist.)
%
%   X=FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS) minimizes with the 
%   default optimization parameters replaced by values in the structure OPTIONS, 
%   an argument created with the OPTIMSET function.  See OPTIMSET for details.  Used
%   options are Display, TolX, TolFun, TolCon, DerivativeCheck, Diagnostics, GradObj, 
%   GradConstr, Hessian, MaxFunEvals, MaxIter, DiffMinChange and DiffMaxChange, 
%   LargeScale, MaxPCGIter, PrecondBandWidth, TolPCG, TypicalX, HessPattern. 
%   Use the GradObj option to specify that FUN may be called with two output 
%   arguments where the second, G, is the partial derivatives of the
%   function df/dX, at the point X: [F,G] = feval(FUN,X). Use the GradConstr
%   option to specify that NONLCON may be called with four output arguments:
%   [C,Ceq,GC,GCeq] = feval(NONLCON,X) where GC is the partial derivatives of the 
%   constraint vector of inequalities C an GCeq is the partial derivatives of the 
%   constraint vector of equalities Ceq. Use OPTIONS = [] as a place holder if 
%   no options are set.
%  
%   X=FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS,P1,P2,...) passes the 
%   problem-dependent parameters P1,P2,... directly to the functions FUN 
%   and NONLCON: feval(FUN,X,P1,P2,...) and feval(NONLCON,X,P1,P2,...).  Pass
%   empty matrices for A, B, Aeq, Beq, OPTIONS, LB, UB, and NONLCON to use the 
%   default values.
%
%   [X,FVAL]=FMINCON(FUN,X0,...) returns the value of the objective 
%   function FUN at the solution X.
%
%   [X,FVAL,EXITFLAG]=FMINCON(FUN,X0,...) returns a string EXITFLAG that 
%   describes the exit condition of FMINCON.  
%   If EXITFLAG is:
%      > 0 then FMINCON converged to a solution X.
%      0   then the maximum number of function evaluations was reached.
%      < 0 then FMINCON did not converge to a solution.
%   
%   [X,FVAL,EXITFLAG,OUTPUT]=FMINCON(FUN,X0,...) returns a structure
%   OUTPUT with the number of iterations taken in OUTPUT.iterations, the number
%   of function evaluations in OUTPUT.funcCount, the algorithm used in 
%   OUTPUT.algorithm, the number of CG iterations (if used) in OUTPUT.cgiterations, 
%   and the first-order optimality (if used) in OUTPUT.firstorderopt.
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA]=FMINCON(FUN,X0,...) returns the Lagrange multipliers
%   at the solution X: LAMBDA.lower for LB, LAMBDA.upper for UB, LAMBDA.ineqlin is
%   for the linear inequalities, LAMBDA.eqlin is for the linear equalities,
%   LAMBDA.ineqnonlin is for the nonlinear inequalities, and LAMBDA.eqnonlin
%   is for the nonlinear equalities.
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD]=FMINCON(FUN,X0,...) returns the value of 
%   the gradient of FUN at the solution X.
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD,HESSIAN]=FMINCON(FUN,X0,...) returns the 
%   value of the HESSIAN of FUN at the solution X.
%
%   See also OPTIMSET, FMINUNC, FMINBND, FMINSEARCH.

%   Copyright (c) 1990-98 by The MathWorks, Inc.
%   $Revision: 1.19 $  $Date: 1998/10/22 20:11:07 $

defaultopt = optimset('display','final','LargeScale','on', ...
   'TolX',1e-6,'TolFun',1e-6,'TolCon',1e-6,'DerivativeCheck','off',...
   'Diagnostics','off',...
   'GradObj','off','GradConstr','off','Hessian','off','MaxFunEvals','100*numberOfVariables',...
   'DiffMaxChange',1e-1,'DiffMinChange',1e-8,...
   'PrecondBandWidth',0,'TypicalX','ones(numberOfVariables,1)','MaxPCGIter','max(1,floor(numberOfVariables/2))', ...
   'TolPCG',0.1,'MaxIter',400,'HessPattern',[]);
% If just 'defaults' passed in, return the default options in X
if nargin==1 & nargout <= 1 & isequal(FUN,'defaults')
   X = defaultopt;
   return
end

large = 'large-scale';
medium = 'medium-scale';

if nargin < 4, error('FMINCON requires at least four input arguments'); end
if nargin < 10, options=[];
   if nargin < 9, NONLCON=[];
      if nargin < 8, UB = [];
         if nargin < 7, LB = [];
            if nargin < 6, Beq=[];
               if nargin < 5, Aeq =[];
               end, end, end, end, end, end
if isempty(NONLCON) & isempty(A) & isempty(Aeq) & isempty(UB) & isempty(LB)
   error('FMINCON is for constrained problems. Use FMINUNC for unconstrained problems.')
end

if nargout > 4
   computeLambda = 1;
else 
   computeLambda = 0;
end

caller='constr';
lenVarIn = length(varargin);
XOUT=X(:);
numberOfVariables=length(XOUT);

options = optimset(defaultopt,options);
switch optimget(options,'display')
case {'off','none'}
   verbosity = 0;
case 'iter'
   verbosity = 2;
case 'final'
   verbosity = 1;
otherwise
   verbosity = 1;
end

% Set to column vectors
B = B(:);
Beq = Beq(:);

[XOUT,l,u,msg] = checkbounds(XOUT,LB,UB,numberOfVariables);
if ~isempty(msg)
   EXITFLAG = -1;
   [FVAL,OUTPUT,LAMBDA,GRAD,HESSIAN] = deal([]);
   X(:)=XOUT;
   if verbosity > 0
      disp(msg)
   end
   return
end
lFinite = l(~isinf(l));
uFinite = u(~isinf(u));


meritFunctionType = 0;

diagnostics = isequal(optimget(options,'diagnostics','off'),'on');
gradflag =  strcmp(optimget(options,'GradObj'),'on');
hessflag = strcmp(optimget(options,'Hessian'),'on');
if isempty(NONLCON)
   constflag = 0;
else
   constflag = 1;
end
gradconstflag =  strcmp(optimget(options,'GradConstr'),'on');
line_search = strcmp(optimget(options,'largescale','off'),'off'); % 0 means trust-region, 1 means line-search

% Convert to inline function as needed
if ~isempty(FUN)  % will detect empty string, empty matrix, empty cell array
   [funfcn, msg] = fprefcnchk(FUN,'fmincon',length(varargin),gradflag,hessflag);
else
   errmsg = sprintf('%s\n%s', ...
      'FUN must be a function name, valid string expression, or inline object;', ...
      ' or, FUN may be a cell array that contains these type of objects.');
   error(errmsg)
end

if constflag % NONLCON is non-empty
   [confcn, msg] = fprefcnchk(NONLCON,'fmincon',length(varargin),gradconstflag,[],1);
else
   confcn{1} = '';
end

[rowAeq,colAeq]=size(Aeq);
% if only l and u then call sfminbx
if ~line_search & isempty(NONLCON) & isempty(A) & isempty(Aeq) & gradflag
   OUTPUT.algorithm = large;
   % if only Aeq beq and Aeq has as many columns as rows, then call sfminle
elseif ~line_search & isempty(NONLCON) & isempty(A) & isempty(lFinite) & isempty(uFinite) & gradflag ...
      & colAeq >= rowAeq
   OUTPUT.algorithm = large;
elseif ~line_search
   warning(['Trust region method does not currently solve this type of problem,',...
         sprintf('\n'), 'switching to line search.'])
   if isequal(funfcn{1},'fungradhess')
      funfcn{1}='fungrad';
      warning('Hessian provided by user will be ignored in line search algorithm')
      
   elseif  isequal(funfcn{1},'fun_then_grad_then_hess')
      funfcn{1}='fun_then_grad';
      warning('Hessian provided by user will be ignored in line search algorithm')
   end    
   hessflag = 0;
   OUTPUT.algorithm = medium;
elseif line_search
   OUTPUT.algorithm = medium;
   if issparse(Aeq) | issparse(A)
      warning('can not do sparse with line_search, converting to full')
   end
   
   % else call nlconst
else
   error('Unrecognized combination of OPTIONS flags and calling sequence.')
end


lenvlb=length(l);
lenvub=length(u);

if isequal(OUTPUT.algorithm,medium)
   CHG = 1e-7*abs(XOUT)+1e-7*ones(numberOfVariables,1);
   i=1:lenvlb;
   lindex = XOUT(i)<l(i);
   if any(lindex),
      XOUT(lindex)=l(lindex)+1e-4; 
   end
   i=1:lenvub;
   uindex = XOUT(i)>u(i);
   if any(uindex)
      XOUT(uindex)=u(uindex);
      CHG(uindex)=-CHG(uindex);
   end
   X(:) = XOUT;
else
   arg = (u >= 1e10); arg2 = (l <= -1e10);
   u(arg) = inf*ones(length(arg(arg>0)),1);
   l(arg2) = -inf*ones(length(arg2(arg2>0)),1);
   if min(min(u-XOUT),min(XOUT-l)) < 0, 
      XOUT = startx(u,l);
      X(:) = XOUT;
   end
end

% Evaluate function
GRAD=zeros(numberOfVariables,1);
HESS = [];

switch funfcn{1}
case 'fun'
   try
      f = feval(funfcn{3},X,varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fungrad'
   try
      [f,GRAD(:)] = feval(funfcn{3},X,varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fungradhess'
   try
      [f,GRAD(:),HESS] = feval(funfcn{3},X,varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fun_then_grad'
   try
      f = feval(funfcn{3},X,varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
   try
      GRAD(:) = feval(funfcn{4},X,varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied objective gradient function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fun_then_grad_then_hess'
   try
      f = feval(funfcn{3},X,varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
   try
      GRAD(:) = feval(funfcn{4},X,varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied objective gradient function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
   try
      HESS = feval(funfcn{5},X,varargin{:});
   catch 
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied objective Hessian function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
otherwise
   error('Undefined calltype in FMINCON');
end

% Evaluate constraints
switch confcn{1}
case 'fun'
   try 
      [ctmp,ceqtmp] = feval(confcn{3},X,varargin{:});
      c = ctmp(:); ceq = ceqtmp(:);
      cGRAD = zeros(numberOfVariables,length(c));
      ceqGRAD = zeros(numberOfVariables,length(ceq));
   catch
      if findstr(xlate('Too many output arguments'),lasterr)
         if isa(confcn{3},'inline')
            errmsg = sprintf('%s%s%s\n%s\n%s\n%s', ...
               'The inline function ',formula(confcn{3}),' representing the constraints',...
               ' must return two outputs: the nonlinear inequality constraints and', ...
               ' the nonlinear equality constraints.  At this time, inline objects may',...
               ' only return one output argument: use an M-file function instead.');
         else
            errmsg = sprintf('%s%s%s\n%s%s', ...
               'The constraint function ',confcn{3},' must return two outputs:',...
               ' the nonlinear inequality constraints and', ...
               ' the nonlinear equality constraints.');
         end
         error(errmsg)
      else
         errmsg = sprintf('%s\n%s\n\n%s',...
            'FMINCON cannot continue because user supplied nonlinear constraint function', ...
            ' failed with the following error:', lasterr);
         error(errmsg);
      end
   end
   
case 'fungrad'
   try
      [ctmp,ceqtmp,cGRAD,ceqGRAD] = feval(confcn{3},X,varargin{:});
      c = ctmp(:); ceq = ceqtmp(:);
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'FMINCON cannot continue because user supplied nonlinear constraint function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fun_then_grad'
   try
      [ctmp,ceqtmp] = feval(confcn{3},X,varargin{:});
      c = ctmp(:); ceq = ceqtmp(:);
      [cGRAD,ceqGRAD] = feval(confcn{4},X,varargin{:});
   catch
      errmsg = sprintf('%s\n%s%s\n\n%s',...
         'FMINCON cannot continue because user supplied nonlinear constraint function', ...
         'or nonlinear constraint gradient function',...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case ''
   c=[]; ceq =[];
   cGRAD = zeros(numberOfVariables,length(c));
   ceqGRAD = zeros(numberOfVariables,length(ceq));
otherwise
   error('Undefined calltype in FMINCON');
end

non_eq = length(ceq);
non_ineq = length(c);
[lin_eq,Aeqcol] = size(Aeq);
[lin_ineq,Acol] = size(A);
[cgrow, cgcol]= size(cGRAD);
[ceqgrow, ceqgcol]= size(ceqGRAD);

eq = non_eq + lin_eq;
ineq = non_ineq + lin_ineq;

if ~isempty(Aeq) & Aeqcol ~= numberOfVariables
   error('Aeq has the wrong number of columns.')
end
if ~isempty(A) & Acol ~= numberOfVariables
   error('A has the wrong number of columns.')
end
if  cgrow~=numberOfVariables & cgcol~=non_ineq
   error('Gradient of the nonlinear inequality constraints is the wrong size.')
end
if ceqgrow~=numberOfVariables & ceqgcol~=non_eq
   error('Gradient of the nonlinear equality constraints is the wrong size.')
end

if diagnostics > 0
   % Do diagnostics on information so far
   msg = diagnose('fmincon',OUTPUT,gradflag,hessflag,constflag,gradconstflag,...
      line_search,options,XOUT,non_eq,...
      non_ineq,lin_eq,lin_ineq,l,u,funfcn,confcn,f,GRAD,HESS,c,ceq,cGRAD,ceqGRAD);
end


% call algorithm
if isequal(OUTPUT.algorithm,medium)
   [X,FVAL,lambda,EXITFLAG,OUTPUT,GRAD,HESSIAN]=...
      nlconst(funfcn,X,l,u,full(A),B,full(Aeq),Beq,confcn,options, ...
      verbosity,gradflag,gradconstflag,hessflag,meritFunctionType,...
      CHG,f,GRAD,HESS,c,ceq,cGRAD,ceqGRAD,varargin{:});
   LAMBDA=lambda;
   
   
else
   if (isequal(funfcn{1}, 'fun_then_grad_then_hess') | isequal(funfcn{1}, 'fungradhess'))
      Hstr=[];
   elseif (isequal(funfcn{1}, 'fun_then_grad') | isequal(funfcn{1}, 'fungrad'))
      n = length(XOUT); 
      Hstr = optimget(options,'HessPattern',[]);
      if isempty(Hstr)
         % Put this code separate as it might generate OUT OF MEMORY error
         Hstr = sparse(ones(n));
      end
      if ischar(Hstr)
         Hstr = eval(Hstr);
      end
   end
   
   if isempty(Aeq)
      [X,FVAL,LAMBDA,EXITFLAG,OUTPUT,GRAD,HESSIAN] = ...
         sfminbx(funfcn,X,l,u,verbosity,options,computeLambda,f,GRAD,HESS,Hstr,varargin{:});
   else
      [X,FVAL,LAMBDA,EXITFLAG,OUTPUT,GRAD,HESSIAN] = ...
         sfminle(funfcn,X,sparse(Aeq),Beq,verbosity,options,computeLambda,f,GRAD,HESS,Hstr,varargin{:});
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [allfcns,msg] = fprefcnchk(funstr,caller,lenVarIn,gradflag,hessflag,constrflag)
%PREFCNCHK Pre- and post-process function expression for FUNCHK.
%   [ALLFCNS,MSG] = PREFUNCHK(FUNSTR,CALLER,lenVarIn,GRADFLAG) takes
%   the (nonempty) expression FUNSTR from CALLER with LenVarIn extra arguments,
%   parses it according to what CALLER is, then returns a string or inline
%   object in ALLFCNS.  If an error occurs, this message is put in MSG.
%
%   ALLFCNS is a cell array: 
%    ALLFCNS{1} contains a flag 
%    that says if the objective and gradients are together in one function 
%    (calltype=='fungrad') or in two functions (calltype='fun_then_grad')
%    or there is no gradient (calltype=='fun'), etc.
%    ALLFCNS{2} contains the string CALLER.
%    ALLFCNS{3}  contains the objective (or constraint) function
%    ALLFCNS{4}  contains the gradient function
%    ALLFCNS{5}  contains the hessian function (not used for constraint function).
%  
%    NOTE: we assume FUNSTR is nonempty.
% Initialize
if nargin < 6
   constrflag = 0;
end
if constrflag
   graderrmsg = 'Constraint gradient function expected (OPTIONS.GradConstr==''on'') but not found.';
   warnstr = ...
      sprintf('%s\n%s\n%s\n','Constraint gradient function provided but OPTIONS.GradConstr==''off'';', ...
      '  ignoring constraint gradient function and using finite-differencing.', ...
      '  Rerun with OPTIONS.GradConstr==''on'' to use constraint gradient function.');
else
   graderrmsg = 'Gradient function expected OPTIONS.GradObj==''on'' but not found.';
   warnstr = ...
      sprintf('%s\n%s\n%s\n','Gradient function provided but OPTIONS.GradObj==''off'';', ...
      '  ignoring gradient function and using finite-differencing.', ...
      '  Rerun with OPTIONS.GradObj==''on'' to use gradient function.');
   
end
msg='';
allfcns = {};
funfcn = [];
gradfcn = [];
hessfcn = [];
if gradflag & hessflag 
   calltype = 'fungradhess';
elseif gradflag
   calltype = 'fungrad';
else
   calltype = 'fun';
end

% {fun}
if isa(funstr, 'cell') & length(funstr)==1
   % take the cellarray apart: we know it is nonempty
   if gradflag
      error(graderrmsg)
   end
   [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end
   
   % {fun,[]}      
elseif isa(funstr, 'cell') & length(funstr)==2 & isempty(funstr{2})
   if gradflag
      error(graderrmsg)
   end
   [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end  
   
   % {fun, grad}   
elseif isa(funstr, 'cell') & length(funstr)==2 % and ~isempty(funstr{2})
   
   [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      error(msg);
   end  
   [gradfcn, msg] = fcnchk(funstr{2},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end
   calltype = 'fun_then_grad';
   if ~gradflag
      warning(warnstr);
      calltype = 'fun';
   end
   
   
   % {fun, [], []}   
elseif isa(funstr, 'cell') & length(funstr)==3 ...
      & ~isempty(funstr{1}) & isempty(funstr{2}) & isempty(funstr{3})
   if gradflag
      error(graderrmsg)
   end
   if hessflag
      error('Hessian function expected but not found.')
   end
   
   [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end  
   
   % {fun, grad, hess}   
elseif isa(funstr, 'cell') & length(funstr)==3 ...
      & ~isempty(funstr{2}) & ~isempty(funstr{3})
   [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end  
   [gradfcn, msg] = fcnchk(funstr{2},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end
   [hessfcn, msg] = fcnchk(funstr{3},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end
   calltype = 'fun_then_grad_then_hess';
   if ~hessflag & ~gradflag
      hwarnstr = sprintf('%s\n%s\n%s\n','Hessian and gradient functions provided ', ...
         '  but OPTIONS.Hessian==''off'' and OPTIONS.GradObj==''off''; ignoring Hessian and gradient functions.', ...
         '  Rerun with OPTIONS.Hessian==''on'' and OPTIONS.GradObj==''on'' to use derivative functions.');
      warning(hwarnstr)
      calltype = 'fun';
   elseif hessflag & ~gradflag
      warnstr = ...
         sprintf('%s\n%s\n%s\n','Hessian and gradient functions provided ', ...
         '  but OPTIONS.GradObj==''off''; ignoring Hessian and gradient functions.', ...
         '  Rerun with OPTIONS.Hessian==''on'' and OPTIONS.GradObj==''on'' to use derivative functions.');
      warning(warnstr)
      calltype = 'fun';
   elseif ~hessflag & gradflag
      hwarnstr = ...
         sprintf('%s\n%s\n%s\n','Hessian function provided but OPTIONS.Hessian==''off'';', ...
         '  ignoring Hessian function,', ...
         '  Rerun with OPTIONS.Hessian==''on'' to use Hessian function.');
      warning(hwarnstr);
      calltype = 'fun_then_grad';
   end
   
   % {fun, grad, []}   
elseif isa(funstr, 'cell') & length(funstr)==3 ...
      & ~isempty(funstr{2}) & isempty(funstr{3})
   if hessflag
      error('Hessian function expected but not found.')
   end
   [funfcn, msg] = fcnchk(funstr{1},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end  
   [gradfcn, msg] = fcnchk(funstr{2},lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end
   calltype = 'fun_then_grad';
   if ~gradflag
      warning(warnstr);
      calltype = 'fun';
   end
   
   % {fun, [], hess}   
elseif isa(funstr, 'cell') & length(funstr)==3 ...
      & isempty(funstr{2}) & ~isempty(funstr{3})
   error('Hessian function given without gradient function.')
   
elseif ~isa(funstr, 'cell')  %Not a cell; is a string expression, function name string or inline object
   [funfcn, msg] = fcnchk(funstr,lenVarIn);
   if ~isempty(msg)
      if constrflag
         msg = ['NONLCON must be a function name.'];
      end
      
      error(msg);
   end   
   if gradflag % gradient and function in one function/M-file
      gradfcn = funfcn; % Do this so graderr will print the correct name
   end  
   if hessflag & ~gradflag
      hwarnstr = ...
         sprintf('%s\n%s\n%s\n','OPTIONS.Hessian==''on'' ', ...
         '  but OPTIONS.GradObj==''off''; ignoring Hessian and gradient functions.', ...
         '  Rerun with OPTIONS.Hessian==''on'' and OPTIONS.GradObj==''on'' to use derivative functions.');
      warning(hwarnstr)
   end
   
else
   errmsg = sprintf('%s\n%s', ...
      'FUN must be a function name or inline object;', ...
      ' or, FUN may be a cell array that contains these type of objects.');
   error(errmsg)
end

allfcns{1} = calltype;
allfcns{2} = caller;
allfcns{3} = funfcn;
allfcns{4} = gradfcn;
allfcns{5} = hessfcn;

