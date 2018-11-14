%% F:AGAP Problem

%% Problem 1
%function one_init
    Gate_W_nums = 24;
    Flight_W_nums  = 49;
    %Solution_W = zeros(Flight_W_nums,Gate_W_nums+1);% 宽 解
    Gate_W   = xlsread('Gate_W.xlsx'); %约束
    Flight_W = xlsread('Flight_W.xlsx'); %约束

    Gate_N_nums = 45;
    Flight_N_nums  = 254;
    % Solution_N = zeros(Flight_N_nums,Gate_N_nums+1);
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
    
    %best_solution_N;
    best_Temp_gate_num_N_T = 100; % 最优解 临时口使用数量
    best_Gate_free_num_N_T  = 0;   % 最优解 固定口 空闲数量
    
    % 淘汰不好的产生新的
    best_Temp_gate_num_W_T_new = 100; % 最优解 临时口使用数量   越少越好  优先级最大
    best_Gate_free_num_W_T_new  = 0;   % 最优解 固定口 空闲数量  越多越好
    
    %best_solution_N;
    best_Temp_gate_num_N_T_new = 100; % 最优解 临时口使用数量
    best_Gate_free_num_N_T_new  = 0;   % 最优解 固定口 空闲数量
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
   I_NP = 100; 
        
%% 进化最大代数                   100次
   I_itermax = 50; 
        
%% 变异概率 Variation
   V_weight = 0.5;
   
%% 选择 Sele 留下的概率            0.85
   S_weight = 0.95;
   
%% 最优个体
    %best_Solution_W=[];
    best_Score_W = -10000; % 得分
    %best_Solution_N=[];
    best_Score_N = -10000; % 
   
   
%% 产生初始种群 =====================================================================================
   NP_W = zeros(Flight_W_nums, Gate_W_nums+2, I_NP); % 初始化解的群体
   NP_N = zeros(Flight_N_nums, Gate_N_nums+2, I_NP);
   
   max_itr = 300; % 500次迭代 中 选一个好的 个体 为为种群中的个体
   for n =1:I_NP
        str1 = sprintf('generate %d individual...',n);
        str1
        for i=1:max_itr
           
        %% W
            [Solution_W, Temp_gate_num_W,Gate_free_num_W] = one_init2(Flight_W, Gate_W); %求解1次
           % Solution_W = one_init3(Flight_W, Gate_W); %求解1次

            if((Temp_gate_num_W < best_Temp_gate_num_W_T )||((Temp_gate_num_W == best_Temp_gate_num_W_T ) && ( Gate_free_num_W > best_Gate_free_num_W_T  ))) 
                %    临时口更少                   或  临时口 使用数量 相同,且 空闲口多
                best_Solution_W_T = Solution_W;
                best_Temp_gate_num_W_T  = Temp_gate_num_W; % 更新临时口 使用数量
                best_Gate_free_num_W_T  = Gate_free_num_W; % 更新固定口 空闲数量
            end

        %% N
            [Solution_N, Temp_gate_num_N, Gate_free_num_N] = one_init2(Flight_N, Gate_N); %求解1次
            %Solution_N = one_init3(Flight_N, Gate_N); %求解1次

           if((Temp_gate_num_N < best_Temp_gate_num_N_T )||((Temp_gate_num_N == best_Temp_gate_num_N_T ) && ( Gate_free_num_N > best_Gate_free_num_N_T  ))) 
                %    临时口更少                   或  临时口 使用数量 相同,且 空闲口多
                best_Solution_N_T  = Solution_N;
                best_Temp_gate_num_N_T  = Temp_gate_num_N; % 更新临时口 使用数量
                best_Gate_free_num_N_T  = Gate_free_num_N;           % 更新固定口 空闲数量
           end
        end  
       NP_W(:,:,n) =  best_Solution_W_T ;
       NP_N(:,:,n) =  best_Solution_N_T ;
   end
%%}  

%%{
%% 开始迭代===========================================================================================
for ll =1:I_itermax
        str1 = sprintf(' %d iter...',ll);
        str1
%% 变异  ======================================================================
    str1 = sprintf('begin  variation');
    str1
    V_num = floor(V_weight * I_NP); % 变异个体数量
    c = randperm(numel(1:I_NP));
    V_NP = c(1:V_num);% 变异个体序列
    for m =1:V_num
        str1 = sprintf('variation %d individual. ', m);
        str1
        %W
        [NP_W(:,:,V_NP(m)) , Temp_gate_num_M, Gate_free_num_M] = one_variation( NP_W(:,:,V_NP(m)) , Flight_W, Gate_W);
        %N
        [NP_N(:,:,V_NP(m)) , Temp_gate_num_N, Gate_free_num_N] = one_variation( NP_N(:,:,V_NP(m)) , Flight_N, Gate_N); 
    end

%% 选择  ==============================================================================================
    str1 = sprintf('begin  select.');
    str1    
    % 产生 适应度值
    NP_W_OBJ = zeros(I_NP,2);%存储每个 个体 的适应度值 即 临时口使用数量 和 固定口空闲数量 和 在种群中的id
    NP_N_OBJ = zeros(I_NP,2);% score = 临时口使用数量*-100 + 固定口空闲数量
    for k = 1:I_NP
        [Temp_gate_num_M, Gate_free_num_M] = one_score(NP_W(:,:,k));
        NP_W_OBJ(k,1) = Temp_gate_num_M * -100 + Gate_free_num_M;  %该个体得分
        NP_W_OBJ(k,2) = k;% 在种群中的id

        [Temp_gate_num_N, Gate_free_num_N] = one_score(NP_N(:,:,k));
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
    str1  
    
     max_itr = 300; % 500次迭代 中 选一个好的 个体 为为种群中的个体
    for l = 1: died_num
            str1 = sprintf('generate %d th new  individual',l);
            str1
            for i=1:max_itr

            %% W
                [Solution_W_new, Temp_gate_num_W,Gate_free_num_W] = one_init2(Flight_W, Gate_W); %求解1次
               % Solution_W = one_init3(Flight_W, Gate_W); %求解1次

                if((Temp_gate_num_W < best_Temp_gate_num_W_T_new )||((Temp_gate_num_W == best_Temp_gate_num_W_T_new ) && ( Gate_free_num_W > best_Gate_free_num_W_T_new  ))) 
                    %    临时口更少                   或  临时口 使用数量 相同,且 空闲口多
                    best_Solution_W_T_new = Solution_W_new;
                    best_Temp_gate_num_W_T_new  = Temp_gate_num_W; % 更新临时口 使用数量
                    best_Gate_free_num_W_T_new  = Gate_free_num_W; % 更新固定口 空闲数量
                end

            %% N
                [Solution_N_new, Temp_gate_num_N, Gate_free_num_N] = one_init2(Flight_N, Gate_N); %求解1次
                %Solution_N = one_init3(Flight_N, Gate_N); %求解1次

               if((Temp_gate_num_N < best_Temp_gate_num_N_T_new )||((Temp_gate_num_N == best_Temp_gate_num_N_T_new ) && ( Gate_free_num_N > best_Gate_free_num_N_T_new  ))) 
                    %    临时口更少                   或  临时口 使用数量 相同,且 空闲口多
                    best_Solution_N_T_new  = Solution_N_new;
                    best_Temp_gate_num_N_T_new = Temp_gate_num_N; % 更新临时口 使用数量
                    best_Gate_free_num_N_T_new  = Gate_free_num_N;           % 更新固定口 空闲数量
               end
            end  
           NP_W(:,:,died_id_W(l)) =  best_Solution_W_T_new ;
           NP_N(:,:,died_id_N(l)) =  best_Solution_N_T_new ;
    end
end

%%}

