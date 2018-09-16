function [x,y]=lpint(f,G,h,lb,ub,x,n,id)
%整数线性规划分枝定界法，可求解线性全整数或线性混合整数规划。
%         y = min f'x    subject to:   Gx <= h  x为整 
%              x
%用法
%    [x,y]=lpint(f,G,h)
%    [x,y]=lpint(f,G,h,lb,ub)
%    [x,y]=lpint(f,G,h,lb,ub,x)
%    [x,y]=lpint(f,G,h,lb,ub,x,n)
%    [x,y]=lpint(f,G,h,lb,ub,x,n,id)
%参数说明
%    x: 最优解列向量
%    y: 目标函数最小值
%    f: 目标函数系数列向量
%    G: 约束条件系数矩阵
%    h: 约束条件右端列向量
%    lb: 解的的下界列向量(Default: -inf)
%    ub: 解的的上界列向量(Default: inf)
%    x: 迭代初值列向量
%    n: 等式约束数(Default: 0)
%    id: 整数变量指标列向量。1-整数，0-实数(Default: 1)
%例2 min Z=x1+4x2
% s.t.  2x1+x2<=8
%      x1+2x2>=6
%      x1, x2>=0且为整数
%先将x1+2x2>=6化为 - x1 - 2x2<= -6
%[x,y]=lpint([1;4],[2 1;-1 -2],[8;-6],[0;0])

% Y. MA & L.J. HU 1999

global upper opt c N x0 A b ID;
if nargin<8, id=ones(size(f));end
if nargin<7|isempty(n), n=0;end
if nargin<6, x=[];end
if nargin<5|isempty(ub), ub=inf*ones(size(f));end
if nargin<4|isempty(lb), lb=zeros(size(f));end

upper=inf;
c=f;N=n;x0=x;A=G;b=h;ID=id;
temp=ILP(lb(:),ub(:));
x=opt;y=upper;

%以下子函数
function y=ILP(vlb,vub)
global upper opt c N x0 A b ID;
  warning off;
  [x,temp,how]=lp(c,A,b,vlb,vub,x0,N,-1);
  if strcmp(how,'ok')~=1
     return;
  end;
  if c'*x-upper>0.00005  %in order to avoid error
     return;
  end;
   
  if max(abs(x.*ID-round(x.*ID)))<0.00005
    if upper-c'*x>0.00005 %in order to avoid error
      opt=x';
      upper=c'*x;
      return;
   else 
      opt=[opt;x'];
      return;
    end;
  end;
  notintx=find(abs(x-round(x))>=0.00005); %in order to avoid error
  intx=fix(x);
  tempvlb=vlb;
  tempvub=vub;
  if vub(notintx(1,1),1)>=intx(notintx(1,1),1)+1
     tempvlb(notintx(1,1),1)=intx(notintx(1,1),1)+1;
     temp=ILP(tempvlb,vub);
  end;
  if vlb(notintx(1,1),1)<=intx(notintx(1,1),1)
    tempvub(notintx(1,1),1)=intx(notintx(1,1),1);
     temp=ILP(vlb,tempvub);
  end;