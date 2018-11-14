%%{ 
% 返回变异后的解，以及 其 临时口使用数量 和 固定扣空闲数量
function [Temp_gate_num, Progress_time, Gate_used_num] = two_score(Solu, Flight_table, Gate_table, Ticket_table, Progress_time_table) 

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
        
%% Progress_time 过程时间 
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
        
        
        
end
%%}
      