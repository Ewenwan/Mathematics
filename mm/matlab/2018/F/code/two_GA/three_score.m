%%{ 
%  临时口使用数量  时间/紧张程度 固定口使用数量
function [Temp_gate_num, Tension, Gate_used_num] = three_score(Solu, Flight_table, Gate_table, Ticket_table, Progress_time_table, Trans_time_table,Work_time_table) 
% Progress_time   Change_time
        %FS = size(Flight_table);
        GS = size(Gate_table);
        TS = size(Ticket_table);
        % Flight_nums = FS(1); % 航次数量   303 
        Gate_nums = GS(2);   % 登机口数量 69    70 为临时登机口
        Ticket_nums = TS(1); % 机票 票次数量 1649
        
        
%% Temp_gate_num 临时口使用数量 
        Temp_gate_num = sum( Solu(:,1) == Gate_nums+1 );  % 临时口 使用数量   少
        
%% Gate_num      固定登机口使用数量
      
        Gate_free_num = 0;
        for j=1:Gate_nums
                if sum( Solu(:,1) == j ) == 0 % 未占用
                    Gate_free_num = Gate_free_num+1;% 未占用数量     固定口 空闲数量   多
                end
        end
        Gate_used_num = Gate_nums - Gate_free_num; % 固定登机口使用数量
        
%%  时间 /紧张程度
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
           
           in_gate_loc = Gate_table(5,in_gate_id);   % 到登机口 终端厅 位置 North=0 Center=1 South=2 East=3
           out_gate_loc = Gate_table(5,out_gate_id); % 走登机口 终端厅 位置 North=0 Center=1 South=2 East=3 
           
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
           
           % 行走时间表 位置
           row = in_gate_type*3 + 1 + in_gate_loc;
           col = out_gate_type*3 + 1 + out_gate_loc;
           
           temp_time_proc = Progress_time_table(row_id,col_id);
           temp_time_trans = Trans_time_table(row_id,col_id);
           temp_time_walk = Work_time_table(row,col);
           
           in_time  = Flight_table(in_flight_id,1); % 到航班id 到时间
           out_time = Flight_table(out_flight_id,2);% 走航班id 走时间
		   
           all_time = temp_time_proc + temp_time_trans + temp_time_walk; % 所需总时间
		   
		   if all_time < (out_time-in_time)
			% 换乘成功
			   %Progress_time = Progress_time + temp_time_proc * peop_nums;   % 流程时间
			   %Trans_time    = Trans_time    + temp_time_trans * peop_nums;  % 捷运时间
			   %Walk_time     = Walk_time     + temp_time_walk * peop_nums;   % 行走时间 Walk_time
			   
			   Change_time = Change_time + all_time * peop_nums;
		   else
		    % 换乘失败
		       Change_time = Change_time + 360 * peop_nums; % 6 小时  乘法 
		   
		   end
		   
		   
		   Flight_time   = Flight_time   + (out_time-in_time)*peop_nums; % 加权航班 连接时间和
       end  
       
        
      %% 总 换乘时间 = 流程时间 + 捷运时间 + 行走时间
       % Change_time  = Progress_time + Trans_time + Walk_time; % 总 换乘时间
        
      %% 旅客总体换乘紧张程度
       Tension = Change_time / Flight_time;
         
end
%%}
      