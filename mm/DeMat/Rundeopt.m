%********************************************************************
% 差异进化算法
%********************************************************************
%% 优化停止 条件
		F_VTR = 0;  % 目标函数最优值 界限
% 目标函数的参数个数 
		I_D = 3; 


% 参数 的范围
      FVr_minbound = -6*ones(1,I_D); 
      FVr_maxbound = +6*ones(1,I_D); 
      I_bnd_constr = 0;  % 是否使用 范围界限  1 使用  0  不使用     
            
%% 种群个体数量  为参数 的5~20倍  5~10倍
		I_NP = 40; 
        
%% 进化最大代数
		I_itermax = 50; 
       
%% 变异 参数 DE-stepsize F_weight ex [0, 2]
		F_weight = 0.3; 

%% 交叉概率  crossover probabililty constant ex [0, 1]
		F_CR = 0.5; 
        
%% 算法选择
% I_strategy     1 --> DE/rand/1:          经典的 DE（差异进化）算法模型   变异  基准个体 随意选取
%                2 --> DE/local-to-best/1: 鲁棒性好 快速收敛的  算法模型
%                3 --> DE/best/1 with jitter: 种群小 维度低    快速收敛   变异  基准个体 选最优的个体
%                4 --> DE/rand/1 with per-vector-dither:
%                5 --> DE/rand/1 with per-generation-dither:
%                6 --> DE/rand/1 either-or-algorithm:         

		I_strategy = 5

%% 辅助信息参数        
      I_refresh = 10; %从第几代开始输出  中间个体
      I_plotting = 0; %是否需要画图

% %% ----画图的参数------------------------------------- 2维
if (I_plotting == 1)      
   FVc_xx = [-6:0.2:6]';
   FVc_yy = [-6:0.2:6]';

   [FVr_x,FM_y]=meshgrid(FVc_xx',FVc_yy') ;
   FM_meshd = 20+((FVr_x).^2-10*cos(2*pi*FVr_x)) +...
        ((FM_y).^2-10*cos(2*pi*FM_y));
      
   S_struct.FVc_xx       = FVc_xx;
   S_struct.FVc_yy       = FVc_yy;
   S_struct.FM_meshd     = FM_meshd;
end

S_struct.I_NP         = I_NP;    %种群大小
S_struct.F_weight     = F_weight;%变异参数
S_struct.F_CR         = F_CR;    %交叉参数与
S_struct.I_D          = I_D;     % 参数数量
S_struct.FVr_minbound = FVr_minbound;%下限
S_struct.FVr_maxbound = FVr_maxbound;%上限
S_struct.I_bnd_constr = I_bnd_constr;%是否使用界限限制
S_struct.I_itermax    = I_itermax;   %最大进化代数
S_struct.F_VTR        = F_VTR;       %最优函数优化界限
S_struct.I_strategy   = I_strategy;  %函数模型选择
S_struct.I_refresh    = I_refresh;   %输出个体选项
S_struct.I_plotting   = I_plotting;  %画图选项


%********************************************************************
% Start of optimization
%********************************************************************

[FVr_x,S_y,I_nf] = deopt('objfun',S_struct)

