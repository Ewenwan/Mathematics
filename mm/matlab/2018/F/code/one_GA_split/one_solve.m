
clc;
clear;
%% F:AGAP Problem

%% Problem 1
%function one_init
    Gate_W_nums = 24;
    Flight_W_nums  = 49;
    %Solution_W = zeros(Flight_W_nums,1+1);% 宽 解
    Gate_W   = xlsread('Gate_W.xlsx'); %约束
    Flight_W = xlsread('Flight_W.xlsx'); %约束

    Gate_N_nums = 45;
    Flight_N_nums  = 254;
    % Solution_N = zeros(Flight_N_nums,1+1);
    Gate_N   = xlsread('Gate_N.xlsx'); %约束
    Flight_N = xlsread('Flight_N.xlsx'); %约束
    
    %% 打乱
    %{
    rowrankW = randperm(size(Flight_W, 1));
    Flight_W = Flight_W(rowrankW,:);
    
    rowrankN = randperm(size(Flight_N, 1));
    Flight_N = Flight_N(rowrankN,:);
    %}
    %% 初始化 初始种群中的个体最优解
    %best_solution_W;
    best_Temp_gate_num_W_T = 100; % 最优解 临时口使用数量   越少越好  优先级最大
    best_Gate_free_num_W_T  = 0;   % 最优解 固定口 空闲数量  越多越好
    best_Score_W_init = -10000;
    
    best_Temp_gate_num_N_T = 100; % 最优解 临时口使用数量
    best_Gate_free_num_N_T  = 0;   % 最优解 固定口 空闲数量
    best_Score_N_init = -10000;
    
    % 淘汰不好的产生新的
    best_Temp_gate_num_W_T_new = 100; % 最优解 临时口使用数量   越少越好  优先级最大
    best_Gate_free_num_W_T_new  = 0;   % 最优解 固定口 空闲数量  越多越好
    best_Score_W_new = -10000;
    
    best_Temp_gate_num_N_T_new = 100; % 最优解 临时口使用数量
    best_Gate_free_num_N_T_new  = 0;   % 最优解 固定口 空闲数量
    best_Score_N_new = -10000;
%{ 
    % 求解一次
    GS_N = size(Gate_N);
    Gate_nums_N = GS_N(2);   %登机口数量

    Solution_N = one_init2(Flight_N, Gate_N); %求解1次

    Temp_gate_num_N = sum(Solution_N(:,Gate_nums_N+1)); % 临时口 使用数量   少
    max1_N=0;
    for k=1:Gate_nums_N
         if sum(Solution_N(:,k))==0 %未占用
            max1_N=max1_N+1;%未占用数量     固定口 空闲数量   多
         end
    end 
%} 

%% 种群个体数量  为参数 的5~10倍   500个
   I_NP = 50; 
        
%% 进化最大代数                   100次
   I_itermax = 100; 
        
%% 变异概率 Variation
  V_weight = 0.4;
   
%% 交叉概率 crossover  交叉后需要检查，使用变异来将不可行解变成可选解
  C_weight = 0.4;
   
%% 选择 Sele 留下的概率            0.85
   S_weight = 0.8;
   
%% 最优个体
    %best_Solution_W=[];
    best_Score_W = -10000; % 得分
    %best_Solution_N=[];
    best_Score_N = -10000; % 
   
   
%% 产生初始种群 =====================================================================================
   NP_W = zeros(Flight_W_nums, 2, I_NP); % 初始化解的群体
   NP_N = zeros(Flight_N_nums, 2, I_NP);
   
   max_itr = 300; % 500次迭代 中 选一个好的 个体 为为种群中的个体
   for n =1:I_NP
        str1 = sprintf('generate %d individual...',n);
        disp(str1)
        for i=1:max_itr
           
        %% W
            [Solution_W, Temp_gate_num_W,Gate_free_num_W] = one_init2(Flight_W, Gate_W); %求解1次
           % Solution_W = one_init3(Flight_W, Gate_W); %求解1次
            Score_W_init = Temp_gate_num_W * -100 + Gate_free_num_W;  %该个体得分

            if(Score_W_init > best_Score_W_init)
                best_Solution_W_init = Solution_W;
                best_Score_W_init = Score_W_init;
            end
            
        %% N
            [Solution_N, Temp_gate_num_N, Gate_free_num_N] = one_init2(Flight_N, Gate_N); %求解1次
            %Solution_N = one_init3(Flight_N, Gate_N); %求解1次
            Score_N_init = Temp_gate_num_N * -100 + Gate_free_num_N;  %该个体得分
   
            if(Score_N_init > best_Score_N_init)
                best_Solution_N_init  = Solution_N;
                best_Score_N_init = Score_N_init; %得分
            end      
        end  
       NP_W(:,:,n) =  best_Solution_W_init ;
       NP_N(:,:,n) =  best_Solution_N_init ;
   end
%%}  

%%{
%% 开始迭代===========================================================================================
for ll =1:I_itermax
   str1 = sprintf(' %d iter...',ll);
   disp(str1);
   
%% 交叉 后 使用变异来将不可行解变成可行解
   str1 = sprintf('begin crossover ...');
   disp(str1);
   
   NP_W = one_crossover_mutation(NP_W, Flight_W, Gate_W, C_weight);
   NP_N = one_crossover_mutation(NP_N, Flight_N, Gate_N, C_weight);
   
%% 变异  ======================================================================
    V_num = floor(V_weight * I_NP); % 变异个体数量
    str1 = sprintf('variation individual num %d ', V_num);
    disp(str1);
    
    c = randperm(numel(1:I_NP));
    V_NP = c(1:V_num);% 变异个体序列
    for m =1:V_num
        % str1 = sprintf('variation %d individual. ', m);
        % str1
        %W
        [NP_W(:,:,V_NP(m)) , Temp_gate_num_W, Gate_free_num_W] = one_variation( NP_W(:,:,V_NP(m)) , Flight_W, Gate_W);
        %N
        [NP_N(:,:,V_NP(m)) , Temp_gate_num_N, Gate_free_num_N] = one_variation( NP_N(:,:,V_NP(m)) , Flight_N, Gate_N); 
    end

%% 选择  ==============================================================================================
    str1 = sprintf('begin  select.');
    disp(str1)   
    % 产生 适应度值
    NP_W_OBJ = zeros(I_NP,2);%存储每个 个体 的适应度值 (即 临时口使用数量 和 固定口空闲数量 决定的得分) 和 在种群中的id
    NP_N_OBJ = zeros(I_NP,2);% score = 临时口使用数量*-100 + 固定口空闲数量
    for k = 1:I_NP
        [Temp_gate_num_W, Gate_free_num_W] = one_score(NP_W(:,:,k),Gate_W_nums);
        NP_W_OBJ(k,1) = Temp_gate_num_W * -100 + Gate_free_num_W;  %该个体得分
        NP_W_OBJ(k,2) = k;% 在种群中的id

        [Temp_gate_num_N, Gate_free_num_N] = one_score(NP_N(:,:,k),Gate_N_nums);
        NP_N_OBJ(k,1) = Temp_gate_num_N * -100 + Gate_free_num_N;
        NP_N_OBJ(k,2) = k;
    end
    % 排序
    NP_W_OBJ = sortrows(NP_W_OBJ,-1); %按照第一列 降序排列   拍在前面的个体 好
    NP_N_OBJ = sortrows(NP_N_OBJ,-1); %按照第一列 降序排列
    
    % 选择最好的个体
    if(NP_W_OBJ(1,1) > best_Score_W)
        best_Score_W = NP_W_OBJ(1,1); % 得分
        best_Solution_W = NP_W(:,:,NP_W_OBJ(1,2)); % 当前最好的个体
    end

    if(NP_N_OBJ(1,1) > best_Score_N)
        best_Score_N = NP_N_OBJ(1,1); % 得分
        best_Solution_N = NP_N(:,:,NP_N_OBJ(1,2)); % 当前最好的个体
    end

    
%% 产生新的个体 =======================================================================================

    died_num = floor((1-S_weight) * I_NP) ; % 需要淘汰的 个体数量
    died_id_W = NP_W_OBJ(I_NP - died_num + 1 : I_NP, 2);% 淘汰后面不好的个体
    died_id_N = NP_N_OBJ(I_NP - died_num + 1 : I_NP, 2);% 淘汰后面不好的个体
    
    str1 = sprintf('begin  generate %d new individuals', died_num);
    disp(str1)  
    
     max_itr = 300; % 500次迭代 中 选一个好的 个体 为为种群中的个体
    for l = 1: died_num
            str1 = sprintf('generate %d th new  individual',l);
            disp(str1)
            for i=1:max_itr

            %% W
              [Solution_W_new, Temp_gate_num_W,Gate_free_num_W] = one_init2(Flight_W, Gate_W); %求解1次
              % Solution_W = one_init3(Flight_W, Gate_W); %求解1次
              Score_W_new = Temp_gate_num_W * -100 + Gate_free_num_W;  %该个体得分
                
              if(Score_W_new > best_Score_W_new)
                    best_Solution_W_T_new = Solution_W_new;
                    best_Score_W_new = Score_W_new;
              end
            
            %% N
              [Solution_N_new, Temp_gate_num_N, Gate_free_num_N] = one_init2(Flight_N, Gate_N); %求解1次
               %Solution_N = one_init3(Flight_N, Gate_N); %求解1次
              Score_N_new = Temp_gate_num_N * -100 + Gate_free_num_N;  %该个体得分
                
              if(Score_N_new > best_Score_N_new)
                    best_Solution_N_T_new = Solution_N_new;
                    best_Score_N_new = Score_N_new;
              end    
             
            end  
           NP_W(:,:,died_id_W(l)) =  best_Solution_W_T_new ;
           NP_N(:,:,died_id_N(l)) =  best_Solution_N_T_new ;
    end
end

%%}

