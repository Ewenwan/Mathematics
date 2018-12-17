%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:         S_MSE= objfun(FVr_temp, S_struct)
% Author:           Rainer Storn
% Description:      Implements the cost function to be minimized.
% Parameters:       FVr_temp     (I)    Paramter vector
%                   S_Struct     (I)    Contains a variety of parameters.
%                                       For details see Rundeopt.m
% Return value:     S_MSE.I_nc   (O)    Number of constraints
%                   S_MSE.FVr_ca (O)    Constraint values. 0 means the constraints
%                                       are met. Values > 0 measure the distance
%                                       to a particular constraint.
%                   S_MSE.I_no   (O)    Number of objectives.
%                   S_MSE.FVr_oa (O)    Objective function values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S_MSE= objfun(FVr_temp, S_struct)

%---Peaks function----------------------------------------------
%F_cost = peaks(FVr_temp(1),FVr_temp(2));

global  rin yout timef
 
tz=0.001;%时间增量
sys=tf(0.03,[8.8825e-12,1.2920e-05,9.1404e-04,0]); % 系统传递函数
zsys=c2d(sys,tz,'z');       % 连续 变离散
[num,den]=tfdata(zsys,'v'); % 得到 离散系统的 分子  和 分母
rin=1.0; %输入
u_1=0.0;u_2=0.0;u_3=0.0;
y_1=0.0;y_2=0.0;y_3=0.0;
K=[0,0,0]'; %参数
error_1=0;  %误差和
Tup=1;      %稳态时间
m=0;        %稳态标志
n=0;        %上升时间开始标志
j=0;        %上升时间结束标志标志
t1=0;t2=0;
final=100;  %步数
J=0;        %初始函数值
r=rin*ones(final,1);
u=zeros(final,1);
error=zeros(final,1);
for t=1:1:final
   timef(t)=t*tz;%总时间
   %r(t)=rin;  
   % 控制量
   u(t)=FVr_temp(1)*K(1)+FVr_temp(2)*K(2)+FVr_temp(3)*K(3);    
   % 限幅
   if u(t)>=10
      u(t)=10;
   end
   if u(t)<=-10
      u(t)=-10;
   end   
   yout(t)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+num(3)*u_2+num(4)*u_3;
   error(t)=r(t)-yout(t);% 输入 - 输出为 误差
%------------ Return of PID parameters -------------
   u_3=u_2;u_2=u_1;u_1=u(t);% 控制量
   y_3=y_2;y_2=y_1;y_1=yout(t);%系统输出 
   K(1)=error(t);                % Calculating P
   K(2)=(error(t)-error_1)/tz;   % Calculating D
   K(3)=K(3)+error(t)*tz;        % Calculating I 
   error_1=error(t);  
 %% 求上升时间Tr
yr1=0.1*rin;
yr2=0.9*rin;
if n==0
  if yout(t)>=yr1
      t1=timef(t);
      n=1;
  end
end
if j==0
  if yout(t)>=yr2
      t2=timef(t);
      j=1;
  end
end   
   %% 稳态时间Tup
if m==0
   if yout(t)>0.95&&yout(t)<1.05
      Tup=timef(t);
      m=1; %稳态标志
   end 
end
end
 
for t=1:1:final
   J=J+0.999*abs(error(t))+0.001*u(t)^2;  % 评价函数
  if t>1   
   if error(t)<0           %% 输出 大于 设定值 
      J=J+100*abs(error(t));% 加入超调乐手
   end    
  end
end
Tr=t2-t1;
J=J+2*Tup+2*Tr;
%----strategy to put everything into a cost function------------
S_MSE.I_nc      = 0;%no constraints
S_MSE.FVr_ca    = 0;%no constraint array
S_MSE.I_no      = 1;%number of objectives (costs)
S_MSE.FVr_oa(1) = J;