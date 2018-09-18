function [x,OPTIONS] = fminu(FUN,x,OPTIONS,GRADFUN,varargin)
%多元函数极值拟牛顿法，适用于光滑函数优化?
%x=fminu('fun',x0)牛顿法求多元函数y=f(x)在x0出发的局部极小值点?
%   这里 x,x0均为向量。 
%x=fminu('fun',x0,options)输入options是优化中算法参数向量设置,
%          用help foptions可看到各分量的含义。
%x=fminu('fun',x0,options,'grad') grad给定f(x)的梯度函数表达式？杉涌旒扑闼俣取?
%x=fminu('fun',x0,options,'grad',p1,p2…)p1,p2,..是表示fun的M函数中的参数。
%例题  求f(x)=100(x2-x1^2)^2+(1-x1)^2在[-1.2,1]附近的极小值。
% 先写M函数optfun1.m  
%         function  f=optfun1(x)
%         f=100*(x(2)-x(1).^2).^2+(1-x(1)).^2;
% 求解
%  clear;
%  x=[-1.2,1];
%  [x,options]=fminu('optfun1',x,options);
%  x,options(8)
%
%FMINU  Finds the minimum of a function of several variables.
%   X=FMINU('FUN',X0) starts at the matrix X0 and finds a minimum to the
%   function which is described in FUN (usually an M-file: FUN.M).
%   The function 'FUN' should return a scalar function value: F=FUN(X).
%
%   X=FMINU('FUN',X0,OPTIONS) allows a vector of optional parameters to
%   be defined. OPTIONS(1) controls how much display output is given; set 
%   to 1 for a tabular display of results, (default is no display: 0). 
%   OPTIONS(2) is a measure of the precision required for the values of 
%   X at the solution. OPTIONS(3) is a measure of the precision
%   required of the objective function at the solution.
%   For more information type HELP FOPTIONS. 
%
%   X=FMINU('FUN',X0,OPTIONS,'GRADFUN') enables a function'GRADFUN'
%   to be entered which returns the partial derivatives of the function,
%   df/dX, at the point X: gf = GRADFUN(X).
%
%   X=FMINU('FUN',X0,OPTIONS,'GRADFUN',P1,P2,...) passes the problem-
%   dependent parameters P1,P2,... directly to the functions FUN 
%   and GRADFUN: FUN(X,P1,P2,...) and GRADFUN(X,P1,P2,...).  Pass
%   empty matrices for OPTIONS, and 'GRADFUN' to use the default 
%   values.
%
%   [X,OPTIONS]=FMINU('FUN',X0,...) returns the parameters used in the 
%   optimization method.  For example, options(10) contains the number 
%   of function evaluations used.
%
%   The default algorithm is the BFGS Quasi-Newton method with a 
%   mixed quadratic and cubic line search procedure. 

%   Copyright (c) 1990-98 by The MathWorks, Inc.
%   $Revision: 1.27 $  $Date: 1997/11/29 01:23:11 $
%   Andy Grace 7-9-90.


% ------------Initialization----------------
XOUT=x(:);
nvars=length(XOUT);

if nargin < 2, error('fminu requires two input arguments');end
if nargin < 3, OPTIONS=[]; end
if nargin < 4, GRADFUN=[]; end

% Convert to inline function as needed.
if ~isempty(FUN)
  [funfcn, msg] = fcnchk(FUN,length(varargin));
  if ~isempty(msg)
    error(msg);
  end
else
  error('FUN must be a function name or valid expression.')
end

if ~isempty(GRADFUN)
  [gradfcn, msg] = fcnchk(GRADFUN,length(varargin));
  if ~isempty(msg)
    error(msg);
  end
else
  gradfcn = [];
end

f = feval(funfcn,x,varargin{:}); 
n = length(XOUT);
GRAD=zeros(nvars,1);
OLDX=XOUT;
MATX=zeros(3,1);
MATL=[f;0;0];
OLDF=f;
FIRSTF=f;
[OLDX,OLDF,HESS,OPTIONS]=optint(XOUT,f,OPTIONS);
CHG = 1e-7*abs(XOUT)+1e-7*ones(nvars,1);
SD = zeros(nvars,1);
diff = zeros(nvars,1);
PCNT = 0;
how = '';


OPTIONS(10)=2; % Function evaluation count (add 1 for last evaluation)
status =-1;

while status ~= 1
% Work Out Gradients
    if isempty(gradfcn) | OPTIONS(9) 
        OLDF=f;
% Finite difference perturbation levels
% First check perturbation level is not less than search direction.
        f = find(10*abs(CHG)>abs(SD)); 
        CHG(f) = -0.1*SD(f);
% Ensure within user-defined limits
        CHG = sign(CHG+eps).*min(max(abs(CHG),OPTIONS(16)),OPTIONS(17));
        for gcnt=1:nvars
            XOUT(gcnt,1)=XOUT(gcnt)+CHG(gcnt);
            x(:) = XOUT; 
            f = feval(funfcn,x,varargin{:});
            GRAD(gcnt)=(f-OLDF)/(CHG(gcnt));
            if f < OLDF
                OLDF=f;
            else
                XOUT(gcnt)=XOUT(gcnt)-CHG(gcnt);
            end
        end
% Try to set difference to 1e-8 for next iteration
% Add eps for machines that can't handle divide by zero.
        CHG = 1e-8./(GRAD + eps); 
        f = OLDF;
        OPTIONS(10)=OPTIONS(10)+nvars;
% Gradient check 
        if OPTIONS(9) == 1 
            GRADFD = GRAD; 
            x(:)=XOUT;  
            GRAD(:) = feval(gradfcn,x,varargin{:});
            if isa(gradfcn,'inline')
              graderr(GRADFD, GRAD, formula(gradfcn));
            else
              graderr(GRADFD, GRAD,  gradfcn);
            end
             OPTIONS(9) = 0; 
        end
                
    else
        OPTIONS(11)=OPTIONS(11)+1;
        x(:)=XOUT; 
        GRAD(:) = feval(gradfcn,x,varargin{:});
    end
%---------------Initialization of Search Direction------------------
if status == -1
    SD=-GRAD;
    FIRSTF=f;
    OLDG=GRAD;
    GDOLD=GRAD'*SD;
% For initial step-size guess assume the minimum is at zero. 
    OPTIONS(18) = max(0.001, min([1,2*abs(f/GDOLD)]));
    if OPTIONS(1)>0
        disp([sprintf('%5.0f %12.6g %12.6g ',OPTIONS(10),f,OPTIONS(18)),sprintf('%12.3g  ',GDOLD)]);
    end
    XOUT=XOUT+OPTIONS(18)*SD;
    status=4; 
    if OPTIONS(7)==0; PCNT=1; end
         
else
%-------------Direction Update------------------
    gdnew=GRAD'*SD;
    if OPTIONS(1)>0, 
        num=[sprintf('%5.0f %12.6g %12.6g ',OPTIONS(10),f,OPTIONS(18)),sprintf('%12.3g  ',gdnew)];
    end
    if (gdnew>0 & f>FIRSTF)|~finite(f)
% Case 1: New function is bigger than last and gradient w.r.t. SD -ve
%   ...interpolate.
        how='inter';
        [stepsize]=cubici1(f,FIRSTF,gdnew,GDOLD,OPTIONS(18));
        if stepsize<0|isnan(stepsize), stepsize=OPTIONS(18)/2; how='C1f '; end
        if OPTIONS(18)<0.1&OPTIONS(6)==0 
            if stepsize*norm(SD)<eps
                stepsize=exp(rand(1,1)-1)-0.1;
                how='RANDOM STEPLENGTH';
                status=0;
            else        
                stepsize=stepsize/2;
            end   
        end      
        OPTIONS(18)=stepsize;
        XOUT=OLDX;
    elseif f<FIRSTF
        [newstep,fbest] =cubici3(f,FIRSTF,gdnew,GDOLD,OPTIONS(18));
        sk=(XOUT-OLDX)'*(GRAD-OLDG);
        if sk>1e-20
% Case 2: New function less than old fun. and OK for updating HESS
%         .... update and calculate new direction.
        how='';   
            if gdnew<0
                how='incstep';
                if newstep<OPTIONS(18),  newstep=2*OPTIONS(18)+1e-5; how=[how,' IF']; end
                OPTIONS(18)=min([max([2,1.5*OPTIONS(18)]),1+sk+abs(gdnew)+max([0,OPTIONS(18)-1]), (1.2+0.3*(~OPTIONS(7)))*abs(newstep)]);
            else % gdnew>0
                if OPTIONS(18)>0.9
                    how='int_st';
                    OPTIONS(18)=min([1,abs(newstep)]);
                end
            end %if gdnew
            [HESS,SD]=updhess(XOUT,OLDX,GRAD,OLDG,HESS,OPTIONS);
            gdnew=GRAD'*SD;
            OLDX=XOUT;
            status=4;
% Save Variables for next update
            FIRSTF=f;
            OLDG=GRAD;
            GDOLD=gdnew;
% If mixed interpolation set PCNT
            if OPTIONS(7)==0, PCNT=1; MATX=zeros(3,1);  MATL(1)=f; end
    elseif gdnew>0 %sk<=0 
% Case 3: No good for updating HESSIAN .. interpolate or halve step length.
            how='inter_st'; 
            if OPTIONS(18)>0.01
                OPTIONS(18)=0.9*newstep;
                XOUT=OLDX;
            end
            if OPTIONS(18)>1, OPTIONS(18)=1; end
        else  
% Increase step, replace starting point
            OPTIONS(18)=max([min([newstep-OPTIONS(18),3]),0.5*OPTIONS(18)]);
            how='incst2';
            OLDX=XOUT;
            FIRSTF=f;
            OLDG=GRAD;
            GDOLD=GRAD'*SD;
                OLDX=XOUT;
        end % if sk>
% Case 4: New function bigger than old but gradient in on
%         ...reduce step length.
    else %gdnew<0 & F>FIRSTF
        if gdnew<0&f>FIRSTF
            how='red_step';  
            if norm(GRAD-OLDG)<1e-10; HESS=eye(nvars); end
            if abs(OPTIONS(18))<eps
                SD=norm(nvars,1)*(rand(nvars,1)-0.5);
                OPTIONS(18)=abs(rand(1,1)-0.5)*1e-6;
                        how='RANDOM SD';
                    else
                        OPTIONS(18)=-OPTIONS(18)/2;
            end
            XOUT=OLDX;
        end %gdnew>0    
    end % if (gdnew>0 & F>FIRSTF)|~finite(F)
    XOUT=XOUT+OPTIONS(18)*SD;
    if isinf(OPTIONS(1)) 
       disp([num,how])
    elseif OPTIONS(1)>0 
       disp(num)
    end
end %----------End of Direction Update-------------------

% Check Termination 
    if max(abs(SD))<2*OPTIONS(2) & (-GRAD'*SD) < 2*OPTIONS(3)
        if OPTIONS(1) > 0
           disp('Optimization Terminated Successfully')
           disp(' Search direction less than 2*options(2)')     
           disp(' Gradient in the search direction less than 2*options(3)')     
           disp([' NUMBER OF FUNCTION EVALUATIONS=', int2str(OPTIONS(10))]);
        end
        status=1; 
    elseif OPTIONS(10)>OPTIONS(14) 
            if OPTIONS(1) >= 0
                  disp('Maximum number of function evaluations exceeded;')
                  disp('   increase options(14).')
            end              
            status=1;
    else

% Line search using mixed polynomial interpolation and extrapolation.
        if PCNT~=0 
            while PCNT > 0 & OPTIONS(10) <= OPTIONS(14)
                x(:) = XOUT;
                f = feval(funfcn,x,varargin{:}); 
                OPTIONS(10)=OPTIONS(10)+1;
                [PCNT,MATL,MATX,steplen,f, how]=searchq(PCNT,f,OLDX,MATL,MATX,SD,GDOLD,OPTIONS(18), how);
                OPTIONS(18)=steplen;
                XOUT=OLDX+steplen*SD;
            end
            if OPTIONS(10)>OPTIONS(14) 
              if OPTIONS(1) >= 0
                  disp('Maximum number of function evaluations exceeded;')
                  disp('   increase options(14).')
              end              
              status=1; 
            end
        else
            x(:)=XOUT; 
            f = feval(funfcn,x,varargin{:}); 
            OPTIONS(10)=OPTIONS(10)+1;
        end
    end
end

x(:)=XOUT;
f = feval(funfcn,x,varargin{:}); 
if f > FIRSTF
    OPTIONS(8) = FIRSTF; 
    x(:)=OLDX;
else
    OPTIONS(8) = f; 
end
