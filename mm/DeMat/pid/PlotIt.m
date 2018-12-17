%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:         PlotIt(FVr_temp,iter,S_struct)
% Author:           Rainer Storn
% Description:      PlotIt can be used for special purpose plots
%                   used in deopt.m.
% Parameters:       FVr_temp     (I)    参数向量
%                   iter         (I)    迭代进化计数
%                   S_Struct     (I)    约束
% Return value:     -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlotIt(FVr_temp,iter,S_struct)
global rin yout timef  %输入，输出，离散时间
%----First of four subplots.---------------------------------------
 % subplot(1,2,1)
 figure(1)
  hold on;
  S_MSE = objfun(S_struct.FVr_bestmem,S_struct);
  plot(iter,S_MSE.FVr_oa(1),'ro');                  % 每一代的 适应度函数
  xlabel('代数');ylabel('适应度函数值');
  title(sprintf('最好的得分: %f',S_MSE.FVr_oa(1)));
  hold off;
 
 %subplot(1,2,2)  
 figure(2)
 %hold on;
 plot(timef,rin,'r',timef,yout,'b');% 系统输入输出
 xlabel('时间');ylabel('rin,yout');
% hold on;

  drawnow;
  pause(1); %wait for one second to allow convenient viewing
  return
