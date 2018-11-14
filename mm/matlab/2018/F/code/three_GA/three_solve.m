
clc;
clear;
%% F:AGAP Problem

%% 1. 载入数据===========================================   
    Gate_nums = 69;    % 总登机口数量
    Flight_nums = 303; % 总航次数量
    
   %% 航班表 303行 6列：  
   %{
    1.到时间(1~4320) 2.走时间(1~4320)  3.到类型(I(0) / D(1)) 4.走类型(I(0) / D(1))
    5.机型(W(1) / N(0)) 6.编号index(1~303)
   %}
    Flight_table = xlsread('data\Flight_table.xlsx');
   
   %% 登机口表 6行 69列： 
   %{
     1.到类型(I(0) / D(1) /  I/D(2))  
     2.走类型(I(0) / D(1)/  I/D(2)) 
     3.所在终端厅(T(0) / S(1)) 
     4.支持机型(W(1) / N(0))  
     5.区域位置(North=0 Center=1 South=2 East=3)
     6.编号index(1~69)
   %} 
   Gate_table = xlsread('data\Gate_table.xlsx');
   
   %% 机票乘客时间表 1649行 6列：
   %{ 
     1.乘客数量(1~2)   2.到达航次ID(1~303)  3.出发航次ID(1~303)  4.时间差  5.编号index(1~1649)
   %}
   Ticket_table = xlsread('data\Ticket_table.xlsx');
   
   %% 登机口流程时间表 4行(到达) DT(10) DS(11) IT(00) IS(01)  4列(出发) DT(10) DS(11) IT(00) IS(01)
   Progress_time_table = xlsread('data\Progress_time_table.xlsx');
   
   %% 捷运时间
   Trans_time_table = xlsread('data\Trans_time_table.xlsx');
   
   %% 行走时间 
   Work_time_table = xlsread('data\Work_time_table.xlsx');
    
%% 2. 算法参数设置 ======================================================================
%% 最优个体
    best_Temp_gate_num= 100;       % 最优解 临时口使用数量   越少越好  优先级最大
    best_Progress_time = 10000000; % 最优解 乘客 过程时间    越少越好      次
    best_Change_time   = 100000000;% 最优解 乘客 中转时间    越少越好      次
    best_time_or_tension = 1000000;  % 紧张程度 ================           次
    best_Gate_num  = 0;            % 最优解 固定口 使用数量  越多越好      最低
    best_Score = -10000;           % 得分
   
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

%{
best_Temp_gate_num_init = 10000;      % 最优解 临时口使用数量   越少越好  优先级最大
best_Progress_time_init = 10000000;   % 最优解 乘客 过程时间              次
best_Change_time_init   = 100000000;  % 最优解 乘客 中转时间              次
best_Gate_num_init      = 10000;      % 最优解 固定口 使用数量  越多越好   最低  
max_itr = 10000;
for i=1:max_itr
    i
    % 输入：航次表 登机口表 机票表 乘客时间表
    % 输出：一个解 临时口使用数量 过程时间 固定登机口使用数量
    [Solution, Temp_gate_num_init, time_or_tension, Gate_num_init] = three_init2(Flight_table, Gate_table,Ticket_table,Progress_time_table,Trans_time_table,Work_time_table); %求解1次
    % Solution_W = one_init3(Flight_W, Gate_W); %求解1次
    % Score_W_init = Temp_gate_num_W * -100 + Gate_free_num_W;  %该个体得分

    if((Temp_gate_num_init < best_Temp_gate_num_init )||...
      ((Temp_gate_num_init == best_Temp_gate_num_init ) && ( Progress_time_init <  best_Progress_time_init))||...
      ((Temp_gate_num_init == best_Temp_gate_num_init ) && ( Progress_time_init == best_Progress_time_init) && ( Gate_num_init < best_Gate_num_init))) 
        %    临时口更少                   或  临时口 使用数量 相同,且 空闲口多
        best_Solution_init       = Solution;
        best_Temp_gate_num_init = Temp_gate_num_init; % 最少的 临时口 使用数量
        best_Progress_time_init = Progress_time_init; % 最少的 过程时间
        best_Gate_num_init      = Gate_num_init;      % 最少的 固定口 使用数量
    end
 end  
 %}  
   
%%{   
%% 产生初始种群 ====================================================================
    % 初始化 初始种群中的个体最优解
    % 初始化
    best_Temp_gate_num_init = 10000;      % 最优解 临时口使用数量   越少越好  优先级最大
    best_Progress_time_init = 10000000;   % 最优解 乘客 过程时间              次
    best_Change_time_init   = 100000000;  % 最优解 乘客 中转时间              次
    best_time_or_tension_init = 1000000;  % 紧张程度 ================
    best_Gate_num_init  = 10000;          % 最优解 固定口 使用数量  越多越好   最低
    best_Score_init = -10000;             % 得分
    
    NP = zeros(Flight_nums, 2, I_NP); % 303*2 初始化解的群体  第一列:分配的登机口 第二列：可变异否
   
    max_itr = 200; % 500次迭代 中 选一个好的 个体 作为种群中的个体
    for n =1:I_NP
        str1 = sprintf('generate %d individual...',n);
        disp(str1)
        for i=1:max_itr
            % 输入：航次表 登机口表 机票表 乘客时间表  捷运时间 行走时间
            % 输出：一个解 临时口使用数量 过程时间 固定登机口使用数量 
            [Solution, Temp_gate_num_init, time_or_tension_init, Gate_num_init] = three_init2(Flight_table, Gate_table,Ticket_table,Progress_time_table,Trans_time_table,Work_time_table); %求解1次
            % Solution_W = one_init3(Flight_W, Gate_W); %求解1次
            % Score_W_init = Temp_gate_num_W * -100 + Gate_free_num_W;  %该个体得分

            if((Temp_gate_num_init < best_Temp_gate_num_init )||...
              ((Temp_gate_num_init == best_Temp_gate_num_init ) && ( time_or_tension_init <  best_time_or_tension_init))||...
              ((Temp_gate_num_init == best_Temp_gate_num_init ) && ( time_or_tension_init == best_time_or_tension_init) && ( Gate_num_init < best_Gate_num_init))) 
                %    临时口更少                   或  临时口 使用数量 相同,且 空闲口多
                best_Solution_init        = Solution;
                best_Temp_gate_num_init   = Temp_gate_num_init; % 最少的 临时口 使用数量
                best_time_or_tension_init = time_or_tension_init; % 最少的 过程时间
                best_Gate_num_init        = Gate_num_init;      % 最少的 固定口 使用数量
                
            end
               
         end  
       NP(:,:,n) =  best_Solution_init ;
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
   
    NP = three_crossover_mutation(NP, Flight_table, Gate_table, C_weight);
   
%% 变异  ======================================================================
    V_num = floor(V_weight * I_NP); % 变异个体数量
    str1 = sprintf('variation individual num %d ', V_num);
    disp(str1);
    
    c = randperm(numel(1:I_NP));
    V_NP = c(1:V_num);% 变异个体序列
    for m =1:V_num
     %[NP(:,:,V_NP(m)), Temp_gate_num_init, Progress_time_init, Gate_num_init] = three_variation( NP(:,:,V_NP(m)), Flight_table, Gate_table,Ticket_table,Progress_time_table); %求解1次
     [NP(:,:,V_NP(m))] = three_variation( NP(:,:,V_NP(m)), Flight_table, Gate_table); %求解1次
    end

%% 选择  ==============================================================================================
    str1 = sprintf('begin  select.');
    disp(str1)   
    % 产生 适应度值
    NP_OBJ = zeros(I_NP,4);%存储每个 个体 的适应度值 (即 临时口使用数量 、 过程时间 和  固定口使用数量  ) 和 在种群中的id
    for k = 1:I_NP
        [T, P, G] = three_score(NP(:,:,k), Flight_table, Gate_table, Ticket_table, Progress_time_table, Trans_time_table, Work_time_table);
        NP_OBJ(k,1:3) = [T, P, G];   
        NP_OBJ(k,4) = k;% 在种群中的id
    end
    
    % 排序
    NP_OBJ = sortrow(NP_OBJ);
    
    % 选择最好的个体
    if((NP_OBJ(1,1) < best_Temp_gate_num )||...
      ((NP_OBJ(1,1) == best_Temp_gate_num ) && ( NP_OBJ(1,2) <  best_time_or_tension))||...
      ((NP_OBJ(1,1) == best_Temp_gate_num ) && (  NP_OBJ(1,2) == best_time_or_tension) && ( NP_OBJ(1,3) < best_Gate_num))) 
        %    临时口更少                   或  临时口 使用数量 相同,且 空闲口多
        best_Solution      = NP(:,:,NP_OBJ(1,4));     % 解
        best_Temp_gate_num = NP_OBJ(1,1);             % 最少的 临时口 使用数量
        best_time_or_tension = NP_OBJ(1,2);           % 最少的 过程时间
        best_Gate_num      = NP_OBJ(1,3);             % 最少的 固定口 使用数量
    end

    
%% 产生新的个体 =======================================================================================

    died_num = ceil((1-S_weight) * I_NP) ; % 需要淘汰的 个体数量
    died_id = NP_OBJ(I_NP - died_num + 1 : I_NP, 4);% 淘汰后面不好的个体

    str1 = sprintf('begin  generate %d new individuals', died_num);
    disp(str1)  
    
    % 产生新的
    best_Temp_gate_num_new = 100;      % 最优解 临时口使用数量   越少越好  优先级最大
    best_Progress_time_new = 10000000; % 最优解 乘客 过程时间              次
    best_Change_time_new   = 100000000;% 最优解 乘客 中转时间              次
    best_time_or_tension_new = 1000000;% 紧张程度
    best_Gate_free_num_new  = 0;       % 最优解 固定口 使用数量  越多越好   最低
    best_Score_new = -10000;           % 得分
    
     max_itr = 200; % 500次迭代 中 选一个好的 个体 为为种群中的个体
    for l = 1: died_num
        str1 = sprintf('generate %d th new  individual',l);
        disp(str1)
        for i=1:max_itr
            % 输入：航次表 登机口表 机票表 乘客时间表
            % 输出：一个解 临时口使用数量 过程时间 固定登机口使用数量
            [Solution, Temp_gate_num_new, time_or_tension_new, Gate_num_new] = three_init2(Flight_table, Gate_table,Ticket_table,Progress_time_table,Trans_time_table,Work_time_table); %求解1次
            % Solution_W = one_init3(Flight_W, Gate_W); %求解1次
            % Score_W_init = Temp_gate_num_W * -100 + Gate_free_num_W;  %该个体得分

            if((Temp_gate_num_new < best_Temp_gate_num_new )||...
              ((Temp_gate_num_new == best_Temp_gate_num_new ) && ( time_or_tension_new <  best_time_or_tension_new))||...
              ((Temp_gate_num_new == best_Temp_gate_num_new ) && ( time_or_tension_new == best_time_or_tension_new) && ( Gate_num_new < best_Gate_num_new))) 
                %    临时口更少                   或  临时口 使用数量 相同,且 空闲口多
                best_Solution_new        = Solution;
                best_Temp_gate_num_new   = Temp_gate_num_new; % 最少的 临时口 使用数量
                best_time_or_tension_new = time_or_tension_new; % 最少的 过程时间
                best_Gate_num_new        = Gate_num_new;      % 最少的 固定口 使用数量
                
            end 
         end  
       NP(:,:,died_id(l)) =  best_Solution_new ;
    end
    
end

%%}

