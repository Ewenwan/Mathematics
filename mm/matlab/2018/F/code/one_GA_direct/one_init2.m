function [Solu, Temp_gate_num, Progress_time, Gate_used_num] = one_init2(Flight_table, Gate_table, Ticket_table, Progress_time_table)
   %% 输入：Flight_table 航次表 
    % 航班表 303行 6列：  
    %{
    1.到时间(1~4320) 2.走时间(1~4320)  3.到类型(I(0) / D(1)) 4.走类型(I(0) / D(1))
    5.机型(W(1) / N(0)) 6.编号index(1~303)
    %}
    %% Gate_table 登机口表  6行 69列： 
    %{
     1.到类型(I(0) / D(1) /  I/D(2))  
     2.走类型(I(0) / D(1)/  I/D(2)) 
     3.所在终端厅(T(0) / S(1)) 
     4.支持机型(W(1) / N(0))  
     5.区域位置(North=0 Center=1 South=2 East=3)
     6.编号index(1~69)
    %}
    %%        Ticket_table 机票表
    % 机票乘客时间表 1649行 6列：
    %{ 
     1.乘客数量(1~2)   2.到达航次ID(1~303)  3.出发航次ID(1~303)  4.时间差  5.编号index(1~1649)
    %}
    
   %% Progress_time_table 过程时间表
    % 登机口流程时间表 
    %{
            4列(出发) DT(10) DS(11) IT(00) IS(01)
    4行(到达) 
            1  DT(10)    
            2  DS(11) 
            3  IT(00) 
            4  IS(01) 
    %}
        
   %% 输出：Solu 一个解  2列 第一列:分配的登机口 第二列：可变异否
   %         Temp_gate_num 临时口使用数量 
   %         Progress_time 过程时间 
   %         Gate_num      固定登机口使用数量
   
        FS = size(Flight_table);
        GS = size(Gate_table);
        %TS = size(Ticket_table);
        Flight_nums = FS(1); % 航次数量   303 
        Gate_nums = GS(2);   % 登机口数量 69    70 为临时登机口
        % Ticket_nums = TS(1); % 机票 票次数量 1649
        
        Solu = zeros(Flight_nums, 1+1); % 303*2 初始化解 门id + 可变异否
        
        Gate_time = zeros(1, Gate_nums);% 1*69  登机口 最后空闲时间

        for i = 1:Flight_nums % 为每个航班选择登机口
            
           gate_candidate = [];
           for j = 1:Gate_nums %遍历每一个登机口，看哪些合适
               % 机型不匹配
               f0 = (Flight_table(i,5) ~= Gate_table(4,j)); % 机型匹配 W-W N-N
               % 航次和登机口 国内国际匹配 不匹配的情况
               % 到达不匹配
               f1 = ((Flight_table(i,3)==0)&&((Gate_table(1,j)==1)));% ID 
               f2 = ((Flight_table(i,3)==1)&&((Gate_table(1,j)==0)));% DI
               % 出发不匹配
               f3 = ((Flight_table(i,4)==0)&&((Gate_table(2,j)==1)));% ID
               f4 = ((Flight_table(i,4)==1)&&((Gate_table(2,j)==0)));% DI
               % 登机口 空闲时间要求 
               f5 = ( Flight_table(i, 1) <= Gate_time(j));% 45分钟可用
               
               if( f0 || f1 || f2 || f3 || f4 || f5 ) %不合适
               else % 合适
                   gate_candidate = [gate_candidate; j]; % 合适的存放起来
               end
           end
           candi_size = size(gate_candidate);

           if(candi_size(1)>0) % 有解
               % 随机选择一个
               candi_index = ceil(rand()*candi_size(1));
               index = gate_candidate(candi_index);% 对应的固定登机口
               if(candi_size(1)>=3) % 有两个以上的候选登机口
                   Solu(i, 1+1) = 1; % 可变异点 ========================================
               end
               
           else %无解
               Solu(i, 1) = Gate_nums+1;% 选择临时登机口
               continue
           end

           Solu(i,1) = index; % 选择该登机口 index
           Gate_time(index) = Flight_table(i, 2) + 45; % 更新登机口 空闲时间
           
        end
    %% 计算解的适应度值 
      [Temp_gate_num, Progress_time, Gate_used_num] = one_score(Solu, Flight_table, Gate_table, Ticket_table, Progress_time_table); 
%{     
%% Temp_gate_num 临时口使用数量 
        Temp_gate_num = sum( Solu(:,1) == Gate_nums+1 );  % 临时口 使用数量   少
        
%% Progress_time 过程时间 
      
        Gate_free_num = 0;
        for j=1:Gate_nums
                if sum( Solu(:,1) == j ) == 0 % 未占用
                    Gate_free_num = Gate_free_num+1;% 未占用数量     固定口 空闲数量   多
                end
        end
        Gate_used_num = Gate_nums - Gate_free_num; % 固定登机口使用数量
        
%% Gate_num      固定登机口使用数量
       Progress_time = 0;
       for k = 1:Ticket_nums % 遍历每个票次 计算 时间
           peop_nums = Ticket_table(k,1);% 人数
           in_flight_id  = Ticket_table(k,2);% 到航班id
           out_flight_id = Ticket_table(k,3);% 走航班id
           % time_diff = Ticket_table(k,4);% 时间差 换乘时间
           
           in_flight_type  = Flight_table(in_flight_id,3);  % 航班到类型   I0 / D1
           out_flight_type = Flight_table(out_flight_id,4); % 航班走类型   I0 / D1 
           
           in_gate_id = Solu(in_flight_id,1);   % 到登机口id  可能为临时登机口  Gate_nums+1
           out_gate_id = Solu(out_flight_id,1); % 走登机口id
           
           % 如果有一个为临时登机口 就跳过
           if( (in_gate_id == Gate_nums+1) || (out_gate_id == Gate_nums+1))
               continue;
           end
           
           in_gate_type = Gate_table(3,in_gate_id);   % 到登机口 终端厅类型 T0 / S1
           out_gate_type = Gate_table(3,out_gate_id); % 走登机口 终端厅类型 T0 / S1  
           
           if((in_flight_type==1)&&(in_gate_type == 0))
             row_id = 1;
           else if((in_flight_type==1)&&(in_gate_type == 1))
             row_id = 2;
           else if((in_flight_type==0)&&(in_gate_type == 0))
             row_id = 3;
           else
             row_id = 4;
           end
           end
           end
           
           if((out_flight_type==1)&&(out_gate_type == 0))
             col_id = 1;
           else if((out_flight_type==1)&&(out_gate_type == 1))
             col_id = 2;
           else if((out_flight_type==0)&&(out_gate_type == 0))
             col_id = 3;
           else
             col_id = 4;
           end
           end
           end          
           
           temp_time = Progress_time_table(row_id,col_id);
           
           Progress_time = Progress_time + temp_time * peop_nums;   
       end 
 
%}
        
end

      