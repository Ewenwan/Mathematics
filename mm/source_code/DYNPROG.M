function [p_opt,fval]=dynprog(x,DecisFun,ObjFun,TransFun)       
% [p_opt,fval]=dynprog(x,DecisFun,ObjFun,TransFun)
% 自由始端和终端的动态规划,求指标函数最小值的逆序算法递归
% 计算程序。x是状态变量，一列代表一个阶段状态；M-函数
% DecisFun(k,x)由阶段k的状态变量x求出相应的允许决策变量;
% M-函数ObjFun(k,x,u)是阶段指标函数，M-函数TransFun(k,x,u)
% 是状态转移函数,其中x是阶段k的某状态变量，u是相应的决策变量；
% 输出p_opt由4列构成，p_opt=[序号组;最优策略组;最优轨线组;
% 指标函数值组]；fval是一个列向量，各元素分别表示p_opt各
% 最优策略组对应始端状态x的最优函数值；
%
%例（参看胡良剑等编《数学实验--使用MATLAB》P180
%先写3个函数
%                 eg13f1_2.m
%    function u=DecisF_1(k,x)
%    在阶段k由状态变量x的值求出其相应的决策变量所有的取值
%    c=[70,72,80,76];q=10*[6,7,12,6];
%    if q(k)-x<0,u=0:100;       %决策变量不能取为负值
%    else,u=q(k)-x:100;end;     %产量满足需求且不超过100
%    u=u(:);
%                 eg13f2_2.m
%    function v=ObjF_1(k,x,u)
%    阶段k的指标函数
%    c=[70,72,80,76];v=c(k)*u+2*x;
%                 eg13f3_2.m
%    function y=TransF_1(k,x,u)
%     状态转移方程
%     q=10*[6,7,12,6];y=x+u-q(k);
%调用DynProg.m计算如下：
%    clear;x=nan*ones(14,4);% x是10的倍数，最大范围0≤x≤130,
%       %因此x=0,1,...13，所以x初始化取14行，nan表示无意义元素
%    x(1:7,1)=10*(0:6)';     % 按月定义x的可能取值
%    x(1:11,2)=10*(0:10)';x(1:12,3)=10*(2:13)';
%    x(1:7,4)=10*(0:6)';
%    [p,f]=dynprog(x,'eg13f1_2','eg13f2_2','eg13f3_2')

% By X.D. Ding June 2000

k=length(x(1,:));f_opt=nan*ones(size(x));d_opt=f_opt;
t_vubm=inf*ones(size(x));x_isnan=~isnan(x);t_vub=inf;
% 计算终端相关值
tmp1=find(x_isnan(:,k));tmp2=length(tmp1);
for i=1:tmp2
   u=feval(DecisFun,k,x(i,k));tmp3=length(u);
   for j=1:tmp3
         tmp=feval(ObjFun,k,x(tmp1(i),k),u(j));
         if tmp<=t_vub, 
            f_opt(i,k)=tmp;d_opt(i,k)=u(j);t_vub=tmp; 
end;end;end
% 逆推计算各阶段的递归调用程序
for ii=k-1:-1:1
   tmp10=find(x_isnan(:,ii));tmp20=length(tmp10);
   for i=1:tmp20
      u=feval(DecisFun,ii,x(i,ii));tmp30=length(u);
      for j=1:tmp30
         tmp00=feval(ObjFun,ii,x(tmp10(i),ii),u(j));
         tmp40=feval(TransFun,ii,x(tmp10(i),ii),u(j));
         tmp50=x(:,ii+1)-tmp40;
         tmp60=find(tmp50==0);
         if ~isempty(tmp60),
            tmp00=tmp00+f_opt(tmp60(1),ii+1);    
            if tmp00<=t_vubm(i,ii)
               f_opt(i,ii)=tmp00;d_opt(i,ii)=u(j);
               t_vubm(i,ii)=tmp00;
end;end;end;end;end;
fval=f_opt(tmp1,1);
% 记录最优决策、最优轨线和相应指标函数值
p_opt=[];tmpx=[];tmpd=[];tmpf=[];
tmp0=find(x_isnan(:,1));tmp01=length(tmp0);
for i=1:tmp01,
  tmpd(i)=d_opt(tmp0(i),1); 
  tmpx(i)=x(tmp0(i),1);
  tmpf(i)=feval(ObjFun,1,tmpx(i),tmpd(i));
  p_opt(k*(i-1)+1,[1,2,3,4])=[1,tmpx(i),...
tmpd(i),tmpf(i)];
  for ii=2:k
     tmpx(i)=feval(TransFun,ii-1,tmpx(i),tmpd(i));
     tmp1=x(:,ii)-tmpx(i);tmp2=find(tmp1==0);
     if ~isempty(tmp2)
        tmpd(i)=d_opt(tmp2(1),ii);
     end;
     tmpf(i)=feval(ObjFun,ii,tmpx(i),tmpd(i));
     p_opt(k*(i-1)+ii,[1,2,3,4])=[ii,tmpx(i),...
tmpd(i),tmpf(i)];
end;end;

