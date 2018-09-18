function [int, tol1,ix]= quadg(fun,xlow,xhigh,tol,trace,p1,p2,p3,p4,p5,p6,p7,p8,p9)
%GAUSS积分法
%用法:  int  = quadg('Fun',xlow,xhigh)
%
%       int     -- 积分值
%       Fun     -- 被积函数Fun(x) （函数名或字符串）
%       xlow    --  x 下限
%       xhigh   --  x 上限
%
%usage:  int = quadg('Fun',xlow,xhigh)
%or
%        [int,tol] = quadg('Fun',xlow,xhigh,reltol)
%or
%        [int, tol] = quadg('Fun',xlow,xhigh,reltol,trace,p1,p2,....)
%
%      reltol=relative tolerance default=1e-3
%      tol = absolute tolerance abs(int-intold)
%
%This function works just like QUAD or QUAD8 but uses a Gaussian quadrature
%integration scheme.  Use this routine instead of QUAD or QUAD8:
%
%   if higher accuracy is desired (this works best if the function, 
%   'Fun', can be approximated by a power series) 
%   
%   if many similar integrations are going to be done 
%      (I think less function evaluations will typically be done, 
%       but the integration points and the weights must be calculated.
%       These are saved between integrations so when QUADG is called 
%       again, the points and weights are all ready known.) 
%
%   if the function evaluations are time consuming.
%
%Note that if there are discontinuities the integral should be broken up into separate 
%pieces.  And if there are singularities,  a more appropriate integration quadrature
%should be used (such as the Gauss-Chebyshev).
% 
% modified by Per A. Brodtkorb 17.11.98 :
% -accept multiple integrationlimits
% -optimized by only computing the integrals which did not converge.
% -enabled the integration of directly given functions enclosed in 
%  parenthesis. Example: integration from 0 to 2 and from 2 to 4 for x is done by:
%
%   quadg('(x.^2)',[0 2],[2 4])
%
global b2
global w2


if exist('tol')~=1,
  tol=1e-3;
elseif isempty(tol),
  tol=1e-3;
end
if exist('trace')~=1,
  trace=0;
elseif isempty(trace),
  trace=0;
else,
  trace=1;
end


if prod(size(xlow))==1,% make sure the integration limits have correct size
  xlow=xlow(ones(size(xhigh)));;
elseif prod(size(xhigh))==1,
  xhigh=xhigh(ones(size(xlow)));;
elseif any( size(xhigh)~=size(xlow) )
  error('The input must have equal size!')
end


if any(fun=='(')  & any(fun=='x'),
  exec_string=['y=',fun ';']; %the call function is already setup
else
  %setup string to call the function
  exec_string=['y=',fun,'(x'];
  num_parameters=nargin-5;
  for i=1:num_parameters,
    %if exist('p1') ~=1,
    xvar=['p' int2str(i)]; % variable # i
    if eval(['~ischar(' ,xvar,') &all(size(xlow)==size(' xvar,')) & length(',xvar,'(:)) ~=1' ]) ,
      eval([xvar, '=' ,xvar ,'(:);']); %make sure it is a column 
      exec_string=[exec_string,',' xvar '(k,ones(1,gn) )']; %enable integration with multiple arguments
    else
      exec_string=[exec_string,',' xvar];
    end
  end
  exec_string=[exec_string,');'];
end
[N M]=size(xlow);
%setup mapping parameters
xlow=xlow(:);
jacob=(xhigh(:)-xlow(:))/2;
nk=N*M;%length of jacob
k=1:nk;
%generate the first two sets of integration points and weights
if isempty(b2),
  [b2 w2]=grule(2);
end
gn=2;
x=(b2(ones(nk,1),:)+1).*jacob(k,ones(1,gn))+xlow(k,ones(1,gn));
eval(exec_string);
%size(x),size(y),size(w2)
int_old=sum(w2(ones(nk,1),:).*y,2).*jacob;
int=int_old;tol1=int;
if trace==1,
  x_trace=x(:);
  y_trace=y(:);
end


% Break out of the iteration loop for three reasons:
%  1) the last update is very small (compared to int  and  compared to tol)
%  2) There are more than 10 iterations. This should NEVER happen. 


converge='n';
for i=1:10,
  gn=2^(i+1);
  gntxt=int2str(gn);% # of weights
  eval(['global b',gntxt,' w',gntxt,';']);
  if isempty(eval(['b',gntxt])) ,  % calculate the weights if necessary
    eval(['[b',gntxt,',w',gntxt,']=grule(',gntxt,');']);
  end
  eval(['x=(b',gntxt,'(ones(nk,1),:)+1).*jacob(k,ones(1, gn ))+xlow(k,ones(1,gn ));']);
  eval(exec_string);
  eval(['int(k)=sum(w',gntxt,'(ones(nk,1),:).*y,2).*jacob(k);']);


  if trace==1,
    x_trace=[x_trace;x(:)];
    y_trace=[y_trace;y(:)];
  end
  tol1(k)=abs(int_old(k)-int(k)); %absolute tolerance
  k=find(tol1 > abs(tol*int)| tol1 > abs(tol));%indices to integrals which did not converge
   
  if any(k),% compute integrals again
      nk=length(k);%# of integrals we have to compute again
  else
    converge='y';
    break;
  end
  int_old=int;
end
int=reshape(int,N,M); % make sure int is the same size as the integration  limits
tol1=reshape(tol1,N,M);


if converge=='n',
  disp('Integral did not converge--singularity likely')
end


if trace==1,
  plot(x_trace,y_trace,'+')
end
