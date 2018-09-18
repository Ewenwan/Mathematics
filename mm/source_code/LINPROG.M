function [x,fval,exitflag,output,lambda]=linprog(f,A,B,Aeq,Beq,lb,ub,x0,options)
%x=linprog(f, A, b)求解线性规划
%             min z = f'x,  Ax ≤ b；
%x=linprog(f, A, b, Aeq, beq)求解线性规划：
%           min z = f'x,  Ax ≤ b,   Aeqx = beq；
%x=linprog(f, A, b, Aeq, beq, lb, ub)指定lb ≤ x ≤ ub；
%x=linprog(f, A, b, Aeq, beq, lb, ub, x0)指定迭代初值x0，
%如果没有不等式约束，可用[ ]替代A和b表示缺省，如果没有等式约束，可用[ ]替代Aeq和beq表示缺省
%如果某个xi下无界或上无界，设定lb(i) = -inf或ub(i) = inf；
%用[x, Fval]代替上述各命令行中左边的x，则可得到最优解处的函数值Fval。
%
%例  max   z=10x1+5x2
%    s.t. 5x1+2x2<=8
%         3x1+4x2=9
%         x1+x2>=1
%         x1,x2>=0
% 首先化为：min   - z = -10x1 -5x2
%    s.t. 5x1+2x1<=8
%         -x1-x2<=-1
%         3x1+4x2=9 
%         x1,x2>=0
%  解法              
%  clear;
%  C=[-10,-5]';
%  A=[5 2;-1 -1];Aeq=[3 4];
%  b=[8,-1]';beq=9;
%  [x,fval]=linprog(C,A,b,Aeq,beq,zeros(2,1));
%  xmax=x,zmax=-fval
%
%LINPROG     Linear programming.                   
%   X=LINPROG(f,A,b) solves the linear programming problem:
%        
%            min f'*x    subject to:   A*x <= b 
%             x
%
%   X=LINPROG(f,A,b,Aeq,beq) solves the problem above while additionally
%   satisfying the equality constraints Aeq*x = beq.
%   
%   X=LINPROG(f,A,b,Aeq,beq,LB,UB) defines a set of lower and upper
%   bounds on the design variables, X, so that the solution is in
%   the range LB <= X <= UB.  Use empty matrices for LB and UB
%   if no bounds exist. Set LB(i) = -Inf if X(i) is unbounded below; 
%   set UB(i) = Inf if X(i) is unbounded above.
%
%   X=LINPROG(f,A,b,Aeq,beq,LB,UB,X0) sets the starting point to X0.  This
%   option is only available with the active-set algorithm.  The default
%   interior point algorithm will ignore any non-empty starting point.
%
%   X=LINPROG(f,A,b,Aeq,Beq,LB,UB,X0,OPTIONS) minimizes with the default 
%   optimization parameters replaced by values in the structure OPTIONS, an 
%   argument created with the OPTIMSET function.  See OPTIMSET for details.  
%   Use options are Display, Diagnostics, TolFun, LargeScale, MaxIter. 
%   Currently, only 'final' and 'off' are valid values for the parameter 
%   Display when LargeScale is 'off' ('iter' is valid when LargeScale is 'on').
%
%   [X,FVAL]=LINPROG(f,A,b) returns the value of the objective function at X:
%   FVAL = f'*X.
%
%   [X,FVAL,EXITFLAG] = LINPROG(f,A,b) returns EXITFLAG that 
%   describes the exit condition of LINPROG.
%   If EXITFLAG is:
%      > 0 then LINPROG converged with a solution X.
%      0   then LINPROG reached the maximum number of iterations without converging.
%      < 0 then the problem was infeasible or LINPROG failed.
%
%   [X,FVAL,EXITFLAG,OUTPUT] = LINPROG(f,A,b) returns a structure
%   OUTPUT with the number of iterations taken in OUTPUT.iterations, the type
%   of algorithm used in OUTPUT.algorithm, the number of conjugate gradient
%   iterations (if used) in OUTPUT.cgiterations.
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA]=LINPROG(f,A,b) returns the set of 
%   Lagrangian multipliers LAMBDA, at the solution: LAMBDA.ineqlin for the 
%   linear inequalities A, LAMBDA.eqlin for the linear equalities Aeq, 
%   LAMBDA.lower for LB, and LAMBDA.upper for UB.
%   
%   NOTE: the LargeScale (the default) version of LINPROG uses a primal-dual
%         method. Both the primal problem and the dual problem must be feasible 
%         for convergence. Infeasibility messages of either the primal or dual, 
%         or both, are given as appropriate.  The primal problem in standard 
%         form is 
%              min f'*x such that A*x = b, x >= 0.
%         The dual problem is
%              max b'*y such that A'*y + s = f, s >= 0.

%   Copyright (c) 1990-98 by The MathWorks, Inc.
%   $Revision: 1.17 $  $Date: 1998/10/22 20:11:09 $
% If just 'defaults' passed in, return the default options in X

defaultopt = optimset('display','final',...
   'TolFun',1e-8,'Diagnostics','off',...
   'LargeScale','on','maxiter',85);

if nargin==1 & nargout <= 1 & isequal(f,'defaults')
   x = defaultopt;
   return
end

% Handle missing arguments
if nargin < 9, options = [];
   if nargin < 8, x0 = []; 
      if nargin < 7, ub = []; 
         if nargin < 6, lb = []; 
            if nargin < 5, Beq = [];
               if nargin < 4, Aeq = [];
               end, end, end, end, end, end
if nargout > 4
   computeLambda = 1;
else 
   computeLambda = 0;
end

% Options setup
options = optimset(defaultopt,options);
largescale = isequal(optimget(options,'largescale'),'on');
diagnostics = isequal(optimget(options,'diagnostics','off'),'on');
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

% Set the constraints up: defaults and check size
[nineqcstr,nvars]=size(A);
[neqcstr, nvarseq]=size(Aeq);
nvars = max([length(f),nvars,nvarseq]); % In case A is empty
ncstr = nineqcstr + neqcstr;   

if isempty(A), A=zeros(0,nvars); end
if isempty(B), B=zeros(0,1); end       
if isempty(Aeq), Aeq=zeros(0,nvars); end
if isempty(Beq), Beq=zeros(0,1); end       

% Set to column vectors
f = f(:);
B = B(:);
Beq = Beq(:);

[x0,lb,ub,msg] = checkbounds(x0,lb,ub,nvars);
if ~isempty(msg)
   exitflag = -1;
   output = []; x=x0; fval = []; lambda = [];
   if verbosity > 0
      disp(msg)
   end
   return
end

caller = 'linprog'; 
ncstr = nineqcstr + neqcstr;

if largescale
   OUTPUT.algorithm = 'large-scale: interior point';
else
   OUTPUT.algorithm  = 'medium-scale: active-set';
end

if diagnostics 
   % Do diagnostics on information so far
   gradflag = []; hessflag = []; line_search=[];
   constflag = 0; gradconstflag = 0; non_eq=0;non_ineq=0;
   lin_eq=size(Aeq,1); lin_ineq=size(A,1); XOUT=ones(nvars,1);
   funfcn{1} = [];ff=[]; GRAD=[];HESS=[];
   confcn{1}=[];c=[];ceq=[];cGRAD=[];ceqGRAD=[];
   msg = diagnose('linprog',OUTPUT,gradflag,hessflag,constflag,gradconstflag,...
      line_search,options,XOUT,non_eq,...
      non_ineq,lin_eq,lin_ineq,lb,ub,funfcn,confcn,ff,GRAD,HESS,c,ceq,cGRAD,ceqGRAD);
end

if (largescale)
   if ~isempty(x0) & verbosity > 0
      warning('Interior Point method is ignoring starting point')
   end
   [x,fval,lambda,exitflag,output] = lipsol(f,A,B,Aeq,Beq,lb,ub,options,computeLambda);
   output.algorithm = 'lipsol';
else
   if ~largescale  & (issparse(A) | issparse(Aeq) )% asked for medium-scale but sparse
      if verbosity > 0
         disp('The medium-scale (active-set) algorithm does not currently handle sparse matrices.')
         disp('Converting to full matrices to solve.')
      end
   end
   if isempty(x0), x0=zeros(nvars,1); end
   [x,lambdaqp,exitflag,output]= ...
      qpsub([],full(f),full([Aeq;A]),full([Beq;B]),lb,ub,x0,neqcstr,verbosity,caller,ncstr,nvars,options);          
   output.algorithm = 'medium-scale: activeset';
end

if isequal(output.algorithm , 'medium-scale: activeset')
   fval = f'*x; 
   llb = length(lb); 
   lub = length(ub);
   lambda.lower = zeros(llb,1);
   lambda.upper = zeros(lub,1);
   arglb = ~isinf(lb); lenarglb = nnz(arglb);
   argub = ~isinf(ub); lenargub = nnz(argub);
   lambda.eqlin = lambdaqp(1:neqcstr,1);
   lambda.ineqlin = lambdaqp(neqcstr+1:neqcstr+nineqcstr,1);
   lambda.lower(arglb) = lambdaqp(neqcstr+nineqcstr+1:neqcstr+nineqcstr+lenarglb);
   lambda.upper(argub) = lambdaqp(neqcstr+nineqcstr+lenarglb+1:neqcstr+nineqcstr+lenarglb+lenargub);
      
   output.firstorderopt=[];
   output.cgiterations =[];
   
   if verbosity > 0
      if ( exitflag ==1 )
         disp('Optimization terminated successfully.');   
      end
      if ( exitflag == 2)
         % do some sort of check here to see how unreliable
         disp('Optimization completed.'); 
      end
      if (exitflag ==0)
         disp('Maximum number of iterations exceeded;')
         disp('   increase options.MaxIter')
      end

   end
end
