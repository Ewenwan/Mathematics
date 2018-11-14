 clc
 clear
 

Flight_table = xlsread('data\Flight_table.xlsx');% 航班表 303行 6列
Gate_table = xlsread('data\Gate_table.xlsx');    % 登机口表 6行 69列
Ticket_table = xlsread('data\Ticket_table.xlsx');% 机票乘客时间表 1649行 6列
Progress_time_table = xlsread('data\Progress_time_table.xlsx');% 登机口流程时间表
Trans_time_table = xlsread('data\Trans_time_table.xlsx');% 捷运时间表
Work_time_table = xlsread('data\Work_time_table.xlsx');  % 行走时间表

Solu = xlsread('ans_three.xlsx'); 

%%{
FS = size(Flight_table);
GS = size(Gate_table);
TS = size(Ticket_table);
Flight_nums = FS(1); % 航次数量   303 
Gate_nums = GS(2);    % 登机口数量 69      70 为临时登机口
Ticket_nums = TS(1);  % 机票 票次数量 1649

%% Temp_gate_num 临时口使用数量 
Temp_gate_num = sum( Solu(:,1) == Gate_nums+1 );  % 临时口 使用数量   少   52

%% Gate_num      固定登机口使用数量

Gate_free_num = 0;
for j=1:Gate_nums
        if sum( Solu(:,1) == j ) == 0 % 未占用
            Gate_free_num = Gate_free_num+1;% 未占用数量     固定口 空闲数量   多
        end
end
Gate_used_num = Gate_nums - Gate_free_num; % 固定登机口使用数量

%% a 成功分配到等级口的航班 数量和比例  按W 和 N 分开
        flight_success_id = find(Solu(:,1) ~= Gate_nums+1); % 成功分配的航班 id
        flight_success_num = size(flight_success_id,1);     % 数量
        % 成功分配的航班
        success_W =[];% 宽体机 W
        success_N =[];% 窄体机 N
        for i = 1:flight_success_num % 每个成功分配的 航班
           flight_id = flight_success_id(i);% 航班id
           flight_type = Flight_table(flight_id,5); % 机体类型  (N=0,W=1)
           if(flight_type == 1) 
               success_W = [success_W; flight_id];
           else 
               success_N = [success_N; flight_id];
           end
        end

        % 分配失败的航班 
        flight_fail_id = find(Solu(:,1) == Gate_nums+1); % 分类失败的航班
        flight_fail_num = size(flight_fail_id,1);     % 数量 
        fail_W =[];% 宽体机 W
        fail_N =[];% 窄体机 N
        for i = 1:flight_fail_num % 每个航班
           flight_id = flight_fail_id(i);% 航班id
           flight_type = Flight_table(flight_id,5); % 机体类型  (N=0,W=1)
           if(flight_type == 1) 
               fail_W = [fail_W; flight_id];
           else 
               fail_N = [fail_N; flight_id];
           end
        end 

        W_success_num = size(success_W,1) * 2; % 一个飞机 两个航班  成功分配的 宽体机
        W_num = W_success_num + size(fail_W,1)*2;
        W_flight_succ_rate = W_success_num/W_num; % W 成功分配比例

        N_success_num = size(success_N,1)*2;   % 一个飞机 两个航班  成功分配的 窄体机
        N_num = N_success_num + size(fail_N,1)*2;
        N_flight_succ_rate = N_success_num/N_num; % N 成功分配比例

%% b题  T 型  和 S型登机口使用数量以及 被使用的登机口在 20当天的 平均使用率 
        Gate_T=[];
        flight_T =[];
        Gate_S=[];
        flight_S =[];
        for k = 1:flight_success_num % 每个成功分配的 航班
           flight_id = flight_success_id(k);% 航班id
           Gate_id = Solu(flight_id,1); % 被分配的 登机口id
           Gate_type = Gate_table(3, Gate_id); % 终端厅类型 T=0, S=1 
           if(Gate_type == 0)
              Gate_T = [Gate_T; Gate_id]; % T类型 登机口id
              flight_T = [flight_T; flight_id];% 对应登录的 航班id
           else
              Gate_S = [Gate_S; Gate_id]; % S类型 登机口id
              flight_S = [flight_S; flight_id];% 对应登录的 航班id
           end
        end
        
        Gate_T_use_num = size(Gate_T,1); % T型登机口 航班
        T_used_num= size(unique(Gate_T),1); % T型登机口 使用数量
        Gate_S_use_num = size(Gate_S,1); % S型登机口 航班
        S_used_num= size(unique(Gate_S),1); % S型登机口 使用数量
        
        % T厅使用率
        % Gate_T_unique = unique(Gate_T); 
        % Gate_use_time_rate = zeros(size(Gate_T_unique,1),1); % 使用的不同的 T型登机口数量
        Gate_use_time_T = zeros(Gate_nums,1);% 69*1 使用时间
        for g =1:Gate_T_use_num
            Gate_id  = Gate_T(g);   % 登机口 id
            flight_id = flight_T(g);% 航班id
            in_time  = Flight_table(flight_id,1); % 航班到时间
            out_time = Flight_table(flight_id,2); % 航班离开时间
            if in_time < 24*60
                in_time = 24*60; % 20号起点时间
            end
            if out_time > 24*60*2
                out_time = 24*60*2;% 20 号最后时间
            end
            use_time = out_time - in_time; % 该次航班占用时间
            Gate_use_time_T(Gate_id) = Gate_use_time_T(Gate_id) + use_time;
        end
        % T_used_num = sum(Gate_use_time_T ~= 0); % 占用时间不为0 的 话 就是被使用了     T型登机口 使用数量
        T_used_rate = sum(Gate_use_time_T) /( 24*60*T_used_num);% 总使用时间 / 总天数时间
        
         
        % S厅使用率
        % Gate_T_unique = unique(Gate_T); 
        % Gate_use_time_rate = zeros(size(Gate_T_unique,1),1); % 使用的不同的 T型登机口数量
        Gate_use_time_S = zeros(Gate_nums,1);% 69*1 使用时间
        for g =1:Gate_S_use_num
            Gate_id  = Gate_S(g);   % 登机口 id
            flight_id = flight_S(g);% 航班id
            in_time  = Flight_table(flight_id,1); % 航班到时间
            out_time = Flight_table(flight_id,2); % 航班离开时间
            if in_time < 24*60
                in_time = 24*60; % 20号起点时间
            end
            if out_time > 24*60*2
                out_time = 24*60*2;% 20 号最后时间
            end
            use_time = out_time - in_time; % 该次航班占用时间
            Gate_use_time_S(Gate_id) = Gate_use_time_S(Gate_id) + use_time;
        end
        % S_used_num = sum(Gate_use_time_S  ~= 0); % 占用时间不为0 的 话 就是被使用了  S型登机口数量
        S_used_rate = sum(Gate_use_time_S)  /( 24*60*S_used_num);% 总使用时间 / 总天数时间
               
        
%% c题 换乘失败旅客数量 和 比例
      fail_passenger_nums = 0;
      passenger_nums = 0;
      
      passenger_time_nums_id = [];
      
      passenger_tension_nums_id = [];
      
   %  时间 /紧张程度
       Progress_time = 0;% 过程时间         
       Trans_time = 0; % 捷运时间
       Walk_time = 0; % 行走时间
       Change_time = 0; % 总换乘时间
       Flight_time = 0; % 两个航班 连接时间
      
       for k = 1:Ticket_nums % 遍历每个票次 计算 时间
           peop_nums = Ticket_table(k,1);    % 人数
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
           
           in_gate_loc = Gate_table(5,in_gate_id);    % 到登机口 终端厅 位置 North=0 Center=1 South=2 East=3
           out_gate_loc = Gate_table(5,out_gate_id);  % 走登机口 终端厅 位置 North=0 Center=1 South=2 East=3 
           
           %% 确定  过程时间表 和 捷运时间表 行列id
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
           
           %% 行走时间表 位置 id
           row = in_gate_type*3 + 1 + in_gate_loc;
           col = out_gate_type*3 + 1 + out_gate_loc;
           
           %% 对应 表中的时间 
           temp_time_proc = Progress_time_table(row_id,col_id);
           temp_time_trans = Trans_time_table(row_id,col_id);
           temp_time_walk = Work_time_table(row,col);
           
           in_time  = Flight_table(in_flight_id,1); % 到航班id 到时间
           out_time = Flight_table(out_flight_id,2);% 走航班id 走时间
		   
           all_time = temp_time_proc + temp_time_trans + temp_time_walk; % 所需总时间 题三
		   % all_time = temp_time_proc ; % 过程时间 题二
             
		   if all_time < (out_time-in_time)
			% 换乘成功
			   Change_time_ =  all_time * peop_nums;
            % 成功 旅客数量
            
           else
               all_time = 360; % 6 小时  乘法 
		    % 换乘失败
		       Change_time_ =  all_time * peop_nums; % 6 小时  乘法 
		    % 换乘失败 旅客数量
               fail_passenger_nums = fail_passenger_nums + peop_nums; % 换乘失败的 旅客数量
           end
           passenger_nums = passenger_nums + peop_nums; % 总乘客 
           
           Flight_time_ = (out_time-in_time) * peop_nums; % 该票次 航班连接时间
           
           Tension_ = Change_time_/Flight_time_;  % 该票次 乘客紧张程度
           
           passenger_tension_nums_id = [passenger_tension_nums_id; [Tension_, peop_nums]]; % 紧张程度 & 乘客数量 
           
           Change_time = Change_time + Change_time_;% 总换乘时间
            
           passenger_time_nums_id = [passenger_time_nums_id; [all_time, peop_nums]]; % 换乘时间 & 乘客数量
           
		   Flight_time   = Flight_time + Flight_time_; % 加权航班 连接时间和
       end  
       
       %% 换乘失败的乘客数量 的 比例
        fail_passenger_rate = fail_passenger_nums/passenger_nums;  % 换乘失败的乘客数量 的 比例
       
       %% 旅客 换乘时间 分布
        max_time  = max(passenger_time_nums_id(:,1)); % 最大时间
        max_time5 = ceil(max_time/5)*5;% 上取整5倍
        passenger_time_num = zeros(max_time5/5,1);   % 旅客时间分布
        % passenger_time_rate = zeros(max_time5/5,1);   % 旅客时间分布 比例
        for lk = 1:size(passenger_time_nums_id,1)
            time = passenger_time_nums_id(lk,1);     % 时间
            pass_num = passenger_time_nums_id(lk,2); % 乘客数量
            passenger_time_num(ceil(time/5)) = passenger_time_num(ceil(time/5)) +  pass_num;
        end
        passenger_time_rate = passenger_time_num/passenger_nums;
        
       %% 旅客 紧张程度 分布 
        % passenger_tension_nums_id;
        max_tension = ceil(max(passenger_tension_nums_id(:,1))/0.1)*0.1;% 上 取整 0.1倍
        passenger_tension_num = zeros(max_tension/0.1, 1);   % 旅客时间分布
        for lk = 1:size(passenger_tension_nums_id,1)
            tension = passenger_tension_nums_id(lk,1);  % 紧张程度
            pass_num = passenger_tension_nums_id(lk,2); % 乘客数量
            passenger_tension_num(ceil(tension/0.1)) = passenger_tension_num(ceil(tension/0.1)) +  pass_num;
        end
        passenger_tension_rate = passenger_tension_num/passenger_nums; 
        
      %% 总 换乘时间 = 流程时间 + 捷运时间 + 行走时间
      %  Change_time  = Progress_time + Trans_time + Walk_time; % 总 换乘时间
        
      %% 旅客总体换乘紧张程度
       Tension = Change_time / Flight_time;
%}
