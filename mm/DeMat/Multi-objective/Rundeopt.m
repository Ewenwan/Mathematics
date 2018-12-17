%********************************************************************
% 差异进化算法
%********************************************************************
clear;clc;close all;
%% 优化停止 条件
		F_VTR = 1.e-8; 
% 目标函数的参数个数 
		I_D = 2; 
% 参数 的范围
      FVr_minbound = -10*ones(1,I_D); 
      FVr_maxbound = 10*ones(1,I_D); 
      I_bnd_constr = 1;  %1: use bounds as bound constraints, 0: no bound constraints      
            
%% 种群个体数量  为参数 的5~10倍
		I_NP = 20;  %pretty high number - needed for demo purposes only

%% 进化最大代数
		I_itermax = 3000; 
%% 变异 参数 DE-stepsize F_weight ex [0, 2]
		F_weight = 0.85; 

%% 交叉概率  crossover probabililty constant ex [0, 1]
		F_CR = 0.5; 

        
%% 算法选择
% I_strategy     1 --> DE/rand/1:          经典的 DE（差异进化）算法模型   变异  基准个体 随意选取
%                2 --> DE/local-to-best/1: 鲁棒性好 快速收敛的  算法模型
%                3 --> DE/best/1 with jitter: 种群小 维度低    快速收敛   变异  基准个体 选最优的个体
%                4 --> DE/rand/1 with per-vector-dither:
%                5 --> DE/rand/1 with per-generation-dither:
%                6 --> DE/rand/1 either-or-algorithm:                 
		I_strategy = 1


%% 辅助信息     
      I_refresh =  3;  %从第几代开始输出  中间个体
      I_plotting = 1; %是否需要画图
      
%-----Problem dependent constant values for plotting----------------
% if (I_plotting == 1)
% end

S_struct.I_NP         = I_NP;
S_struct.F_weight     = F_weight;
S_struct.F_CR         = F_CR;
S_struct.I_D          = I_D;
S_struct.FVr_minbound = FVr_minbound;
S_struct.FVr_maxbound = FVr_maxbound;
S_struct.I_bnd_constr = I_bnd_constr;
S_struct.I_itermax    = I_itermax;
S_struct.F_VTR        = F_VTR;
S_struct.I_strategy   = I_strategy;
S_struct.I_refresh    = I_refresh;
S_struct.I_plotting   = I_plotting;

%********************************************************************
% Start of optimization
%********************************************************************

[FVr_x,S_y,I_nf] = deopt('objfun',S_struct)

