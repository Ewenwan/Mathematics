function [errmsg,Z,X,t,c,fail] = BNB18(fun,x0,xstat,xl,xu,A,B,Aeq,Beq,nonlcon,setts,options1,options2,maxSQPit,varargin);
%非线性整数规划模型求解分支定界迭代算法。在MATLAB5.3中使用，需Optimization toolbox 2.0支持?
%			Minimize F(x) 
%subject to: xlb <= x <=xub
%              A*x <= B
%  				Aeq*x=Beq
%              C(x)<=0  
%			 	   Ceq(x)=0
%
%				x(i)可为连续变量，整数，或固定值
% 使用格式
%[errmsg,Z,X]=BNB18('fun',x0,xstat,xl,xu,A,B,Aeq,Beq,'nonlcon',setts)
%fun：  M文件名，表示最小化目标函数f=fun(x)
%x0:    列向量，表示变量初值
%xstat： 列向量，xstat(i)=0表示x(i)为连续变量，1表示整数，2表示固定值
%xl：   列向量，表示变量下界
%xu:    列向量，表示变量上界
%A:     矩阵, 表示线性不等式约束系数
%B:     列向量, 表示线性不等式约束上界
%Aeq:   矩阵, 表示线性等式约束系数
%Beg:   列向量, 表示线性不等式约束右端值
%nonlcon:  M文件名，表示非线性约束函数[C,Ceq]=nonlin(x),其中C(x)为不等式约束, 
%              Ceq(x)为等式约束
%setts:  算法设置
%errmsq: 返回错误提示
%Z:      返回目标函数最小值
%X:      返回最优解
%
%例题
%   max x1*x2*x3
%   -x1+2*x2+2*x3>=0
%   x1+2*x2+2*x3<=72
%   10<=x2<=20
%    x1-x2=10
% 先写 M函数discfun.m
%                 function f=discfun(x)
%                 f=-x(1)*x(2)*x(3);
%求解
%    clear;x0=[25,15,10]';xstat=[1 1 1]';
%    xl=[20 10 -10]';xu=[30 20 20]';
%     A=[1 -2 -2;1 2 2];B=[0 72]';Aeq=[1 -1 0];Beq=10;
%    [err,Z,X]=BNB18('discfun',x0,xstat,xl,xu,A,B,Aeq,Beq);
%    XMAX=X',ZMAX=-Z
%
% BNB18 Finds the constrained minimum of a function of several possibly integer variables.
% Usage: [errmsg,Z,X,t,c,fail] = 
%        BNB18(fun,x0,xstatus,xlb,xub,A,B,Aeq,Beq,nonlcon,settings,options1,options2,maxSQPiter,P1,P2,...) 
%
% BNB solves problems of the form:
% Minimize F(x) subject to: xlb <= x0 <=xub
%                           A*x <= B  Aeq*x=Beq
%                           C(x)<=0  Ceq(x)=0
%                           x(i) is continuous for xstatus(i)=0  
%                           x(i) integer for xstatus(i)= 1
%                           x(i) fixed for xstatus(i)=2
%
% BNB uses:
% Optimization Toolbox Version 2.0 (R11) 09-Oct-1998
% From this toolbox fmincon.m is called. For more info type help fmincon.
%
% fun is the function to be minimized and should return a scalar. F(x)=feval(fun,x).
% x0 is the starting point for x. x0 should be a column vector.
% xstatus is a column vector describing the status of every variable x(i).
% xlb and xub are column vectors with lower and upper bounds for x.
% A and Aeq are matrices for the linear constrains.
% B and Beq are column vectors for the linear constrains.
% nonlcon is the function for the nonlinear constrains.
% [C(x);Ceq(x)]=feval(nonlcon,x). Both C(x) and Ceq(x) should be column vectors.
%
% errmsg is a string containing an error message if BNB found an error in the input.
% Z is the scalar result of the minimization, X the values of the accompanying variables. 
% t is the time elapsed while the algorithm BNB has run, c is the number of BNB cycles and
% fail is the number of unsolved leaf sub-problems.  
%
% settings is a row vector with settings for BNB:
% settings(1) (standard 0) if 1: use phase 1 by relaxation. This sometimes makes the algorithm
% faster, because phase 1 means the algorithm first checks if there is a feasible solution
% for a sub-problem before trying to find a best solution. If there is no feasible solution BNB
% will not try to find a best solution.
% settings(2) (standard 0) if 1: if the sub-problem did not converge do not branch. If a sub-
% problem did not converge this means BNB did not find a solution for it. Normally BNB will 
% branch the problem so it can try again to find a solution.
% A sub-problem that is a leaf of the branch-and-bound-three can not be branched. If such
% a problem does not converge it will be considered unfeasible and the parameter fail will be 
% raised by one.
% settings(3) (standard 0) if 1: if 1 a sub-problem that did not converge but did return a feasible
% point will be considered convergent. This might be useful if fmincon is having a hard time with
% a certain problem but you do want some results.
% options1 and options2 are options structures for phase 1 and phase 2.
% For details about the options structure type help optimset.
% maxSQPiter is a global variable used by fmincon (if modified as described in bnb18.m).
% maxSQPiter is 1000 by default.
% P1,P2,... are parameters to be passed to fun and nonlcon.
% F(x)=feval(fun,x,P1,P2,...). [C(x);Ceq(x)]=feval(nonlcon,x,P1,P2,...).
% Type edit BNB18 for more info.

% E.C. Kuipers
% e-mail E.C.Kuipers@cpedu.rug.nl 
% FI-Lab
% Applied Physics
% Rijksuniversiteit Groningen

% To get rid of bugs and to stop fmincon from hanging make the following chances:
%
% In optim/private/nlconst.m ($Revision: 1.20 $  $Date: 1998/08/24 13:46:15 $):
% Get EXITFLAG independent of verbosity.
% After the lines:                 disp('  less than 2*options.TolFun but constraints are not satisfied.')    
%                               end
%                               EXITFLAG = -1;   
%                            end
%                         end
%                         status=1;
% add the line: if (strncmp(howqp, 'i',1) & mg > 0), EXITFLAG = -1; end;
%
% In optim/private/qpsub.m ($Revision: 1.21 $  $Date: 1998/09/01 21:37:56 $):
% Stop qpsub from hanging.
% After the line: %   Andy Grace 7-9-90. Mary Ann Branch 9-30-96.
% add the line: global maxSQPiter; 
% and changed the line: maxSQPiters = Inf;
% to the line: if exist('maxSQPiter','var'), maxSQPiters = maxSQPiter; else maxSQPiters=inf; end; 
% I guess there was a reason to put maxSQPiters at infinity, but this works fine for me.
global maxSQPiter;

% STEP 0 CHECKING INPUT
Z=[]; X=[]; t=0; c=0; fail=0;
if nargin<2, errmsg='BNB needs at least 2 input arguments.'; return; end;
if isempty(fun), errmsg='No fun found.'; return; end;
if isempty(x0), errmsg='No x0 found.'; return;
elseif size(x0,2)>1, errmsg='x0 must be a column vector.'; return; end;
xstatus=zeros(size(x0));
if nargin>2 & ~isempty(xstat)
   if all(size(xstat)<=size(x0))
      xstatus(1:size(xstat))=xstat;
   else errmsg='xstatus must be a column vector the same size as x0.'; return;
   end;
   if any(xstatus~=round(xstatus) | xstatus<0 | 2<xstatus)
      errmsg='xstatus must consist of the integers 0,1 en 2.'; return;
   end;
end;
xlb=zeros(size(x0));
xlb(find(xstatus==0))=-inf;
if nargin>3 & ~isempty(xl)
   if all(size(xl)<=size(x0))
      xlb(1:size(xl,1))=xl;
   else errmsg='xlb must be a column vector the same size as x0.'; return;
   end;
end;
if any(x0<xlb)
   errmsg='x0 must be in the range xlb <= x0.'; return;
elseif any(xstatus==1 & (~isfinite(xlb) | xlb~=round(xlb)))
   errmsg='xlb(i) must be an integer if x(i) is an integer variabele.'; return;
end;
xlb(find(xstatus==2))=x0(find(xstatus==2));
xub=ones(size(x0));
xub(find(xstatus==0))=inf;
if nargin>4 & ~isempty(xu)
   if all(size(xu)<=size(x0))
      xub(1:size(xu,1))=xu;
   else errmsg='xub must be a column vector the same size as x0.'; return;
   end;
end;
if any(x0>xub)
   errmsg='x0 must be in the range x0 <=xub.'; return;
elseif any(xstatus==1 & (~isfinite(xub) | xub~=round(xub)))
   errmsg='xub(i) must be an integer if x(i) is an integer variabale.'; return;
end;
xub(find(xstatus==2))=x0(find(xstatus==2));
if nargin>5
   if ~isempty(A) & size(A,2)~=size(x0,1), errmsg='Matrix A not correct.'; return; end;
else A=[]; end;
if nargin>6
   if ~isempty(B) & any(size(B)~=[size(A,1) 1]), errmsg='Column vector B not correct.'; return; end;
else B=[]; end;
if isempty(A) & ~isempty(B), errmsg='A and B should only be nonempty together.'; return; end;
if isempty(B) & ~isempty(A), B=zeros(size(A,1),1); end;
if nargin>7 & ~isempty(Aeq)
   if size(Aeq,2)~=size(x0,1), errmsg='Matrix Aeq not correct.'; return; end;
else Aeq=[]; end;
if nargin>8
   if ~isempty(Beq) & any(size(Beq)~=[size(Aeq,1) 1]), errmsg='Column vector Beq not correct.'; return; end;
else Beq=[]; end;
if isempty(Aeq) & ~isempty(Beq), errmsg='Aeq and Beq should only be nonempty together'; return; end;
if isempty(Beq) & ~isempty(Aeq), Beq=zeros(size(Aeq,1),1); end;
if nargin<10, nonlcon=''; end;
settings = [0 0 0];
if nargin>10 & ~isempty(setts)
   if all(size(setts)<=size(settings))
      settings(setts~=0)=setts(setts~=0);
   else errmsg='settings should be a row vector of length 3.'; return; end;
end;
if nargin<12, options1=[]; end;
options1=optimset(optimset('fmincon'),options1);
if nargin<13, options2=[]; end;
options2=optimset(optimset('fmincon'),options2);
if nargin<14, maxSQPiter=1000; 
elseif isnumeric(maxSQPit) & all(size(maxSQPit))==1 & maxSQPit>0 & round(maxSQPit)==maxSQPit
   maxSQPiter=maxSQPit;
else errmsg='maxSQPiter must be an integer >0'; return; end;
eval(['z=',fun,'(x0,varargin{:});'],'errmsg=''fun caused error.''; return;');
if ~isempty(nonlcon)
   eval(['[C, Ceq]=',nonlcon,'(x0,varargin{:});'],'errmsg=''nonlcon caused error.''; return;');
   if size(C,2)>1 | size(Ceq,2)>1, errmsg='C en Ceq must be column vectors.'; return; end;
end;

% STEP 1 INITIALISATION
currentwarningstate=warning;
warning off;
tic;
lx = size(x0,1);
z_incumbent=inf;
x_incumbent=inf*ones(size(x0));
I = ceil(sum(log2(xub(find(xstatus==1))-xlb(find(xstatus==1))+1))+size(find(xstatus==1),1)+1);
stackx0=zeros(lx,I);
stackx0(:,1)=x0;
stackxlb=zeros(lx,I);
stackxlb(:,1)=xlb;
stackxub=zeros(lx,I);
stackxub(:,1)=xub;
stacksize=1;
xchoice=zeros(size(x0));
if ~isempty(Aeq)
   j=0;
   for i=1:size(Aeq,1)
      if Beq(i)==1 & all(Aeq(i,:)==0 | Aeq(i,:)==1)
         J=find(Aeq(i,:)==1);
         if all(xstatus(J)~=0 & xchoice(J)==0 & xlb(J)==0 & xub(J)==1)
            if all(xstatus(J)~=2) | all(x0(J(find(xstatus(J)==2)))==0)
               j=j+1;
               xchoice(J)=j;
               if sum(x0(J))==0, errmsg='x0 not correct.'; return; end;
            end;
         end;
      end;
   end;
end;
errx=optimget(options2,'TolX');
errcon=optimget(options2,'TolCon');
fail=0;
c=0;

% STEP 2 TERMINIATION
while stacksize>0
   c=c+1;
   
   % STEP 3 LOADING OF CSP
   x0=stackx0(:,stacksize);
   xlb=stackxlb(:,stacksize);
   xub=stackxub(:,stacksize);
   x0(find(x0<xlb))=xlb(find(x0<xlb));
   x0(find(x0>xub))=xub(find(x0>xub));
   stacksize=stacksize-1;
      
   % STEP 4 RELAXATION
   
   % PHASE 1
   con=BNBCON(x0,A,B,Aeq,Beq,xlb,xub,nonlcon,varargin{:});
   if abs(con)>errcon & settings(1)~=0
      [x1 dummy feasflag]=fmincon('0',x0,A,B,Aeq,Beq,xlb,xub,nonlcon,options1,varargin{:});
      if settings(3) & feasflag==0
         con=BNBCON(x1,A,B,Aeq,Beq,xlb,xub,nonlcon,varargin{:});
         if con<errcon, feasflag=1; end;
      end;
   else x1=x0; feasflag=1; end;
   
   % PHASE 2
   if feasflag>0
      [x z convflag]=fmincon(fun,x1,A,B,Aeq,Beq,xlb,xub,nonlcon,options2,varargin{:});
      if settings(3) & convflag==0
         con=BNBCON(x,A,B,Aeq,Beq,xlb,xub,nonlcon,varargin{:});
         if con<errcon, convflag=1; end;
      end;
   else convflag=feasflag; end;
   
   % STEP 5 FATHOMING
   K = find(xstatus==1 & xlb~=xub);
   separation=1;
   if convflag<0 | (convflag==0 & settings(2))
      % FC 1
      separation=0;
   elseif z>=z_incumbent & convflag>0
      % FC 2
      separation=0;
   elseif all(abs(round(x(K))-x(K))<errx) & convflag>0
      % FC 3
      z_incumbent = z;
      x_incumbent = x;
      separation = 0;
	end;
   
   % STEP 6 SELECTION
   if separation == 1 & ~isempty(K)
      dzsep=-1;
      for i=1:size(K,1)
         dxsepc = abs(round(x(K(i)))-x(K(i)));
         if dxsepc>=errx | convflag==0
            xsepc = x; xsepc(K(i))=round(x(K(i)));
            dzsepc = abs(feval(fun,xsepc,varargin{:})-z);
            if dzsepc>dzsep
               dzsep=dzsepc;
               ixsep=K(i);
            end;
         end;
      end;
      
      % STEP 7 SEPARATION
      if xchoice(ixsep)==0
         
         % XCHOICE==0
         branch=1;
         domain=[xlb(ixsep) xub(ixsep)];
         while branch==1
            xboundary=(domain(1)+domain(2))/2;
            if x(ixsep)<xboundary
               domainA=[domain(1) floor(xboundary)];
               domainB=[floor(xboundary+1) domain(2)];
            else
               domainA=[floor(xboundary+1) domain(2)];
               domainB=[domain(1) floor(xboundary)];
            end;
            stacksize=stacksize+1;
            stackx0(:,stacksize)=x;
            stackxlb(:,stacksize)=xlb;
            stackxlb(ixsep,stacksize)=domainB(1);
            stackxub(:,stacksize)=xub;
            stackxub(ixsep,stacksize)=domainB(2);
            if domainA(1)==domainA(2) 
               stacksize=stacksize+1;
               stackx0(:,stacksize)=x;
               stackxlb(:,stacksize)=xlb;
               stackxlb(ixsep,stacksize)=domainA(1);
               stackxub(:,stacksize)=xub;
               stackxub(ixsep,stacksize)=domainA(2);
               branch=0;
            else
               domain=domainA;
               branch=1;
            end;
         end;
      else
         
         % XCHOICE~=0
         L=find(xchoice==xchoice(ixsep));
         M=intersect(K,L);
         [dummy,N]=sort(x(M));
         part1=M(N(1:floor(size(N)/2))); part2=M(N(floor(size(N)/2)+1:size(N)));
         stacksize=stacksize+1;
         stackx0(:,stacksize)=x;
         O = (1-sum(stackx0(part1,stacksize)))/size(part1,1);
         stackx0(part1,stacksize)=stackx0(part1,stacksize)+O;
         stackxlb(:,stacksize)=xlb;
         stackxub(:,stacksize)=xub;
         stackxub(part2,stacksize)=0;
         stacksize=stacksize+1;
         stackx0(:,stacksize)=x;
         O = (1-sum(stackx0(part2,stacksize)))/size(part2,1);
         stackx0(part2,stacksize)=stackx0(part2,stacksize)+O;
         stackxlb(:,stacksize)=xlb;
         stackxub(:,stacksize)=xub;
         stackxub(part1,stacksize)=0;
         if size(part2,1)==1, stackxlb(part2,stacksize)=1; end;
      end;
   elseif separation==1 & isempty(K)
      fail=fail+1;
   end;
end;

% STEP 8 OUTPUT  
t=toc;
Z = z_incumbent;
X = x_incumbent;
errmsg='';
eval(['warning ',currentwarningstate]);

function CON=BNBCON(x,A,B,Aeq,Beq,xlb,xub,nonlcon,varargin);
if isempty(A), CON1=[]; else CON1 = max(A*x-B,0); end;
if isempty(Aeq), CON2=[]; else CON2 = abs(Aeq*x-Beq); end;
CON3 = max(xlb-x,0);
CON4 = max(x-xub,0);
if isempty(nonlcon)
   CON5=[]; CON6=[];
else
   [C Ceq]=feval(nonlcon,x,varargin{:});
   CON5 = max(C,0);
   CON6 = abs(Ceq);
end;
CON  = max([CON1; CON2; CON3; CON4; CON5; CON6]);