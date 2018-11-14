%%{ 
    function [Solu] = one_init3(Flight_table, Gate_table)
        %% 窄求解 N 
        FS = size(Flight_table);
        GS = size(Gate_table);
        Flight_nums = FS(1); %航班数量
        Gate_nums = GS(2);   %登机口数量
        
        Solu = zeros(Flight_nums, Gate_nums+1); % 初始化解
        
        Gate_time_net = zeros( 864*5 ,Gate_nums); % 待优化 中间变量   3天
        
        Gate_time = zeros(1, Gate_nums);% 门最后空闲时间
        
        for i = 1:Flight_nums % 为每个航班选择登机口
            
           %i        
           in_time1 = Flight_table(i, 1);       % 该航班到时间
           out_time1 = Flight_table(i, 2) + 45; % 该航班离开时间 + 45 
           gate_candidate = [];
           for j = 1:Gate_nums %遍历每一个登机口，看哪一个合适
               f1 = ((Flight_table(i,3)==0)&&((Gate_table(1,j)==1)));
               f2 = ((Flight_table(i,3)==1)&&((Gate_table(1,j)==0)));
               f3 = ((Flight_table(i,4)==0)&&((Gate_table(2,j)==1)));
               f4 = ((Flight_table(i,4)==1)&&((Gate_table(2,j)==0)));

               
               % f5 = ( Flight_table(i, 1) < Gate_time(j));
               f5 = (  sum(Gate_time_net( in_time1:out_time1-1, j)) >=1 ); % 45空间还可以用===============
               
               if( f1 || f2 || f3 || f4 || f5 ) %不合适
               else % 合适
                   gate_candidate = [gate_candidate; j]; % 合适的存放起来
               end
           end
           
           if((out_time1 - in_time1)>800)%本 飞机 占用时间过长
               gate_candidate = [gate_candidate; Gate_nums+1];% 添加一个 临时机位作为选择
           end
           
           candi_size = size(gate_candidate);
           
           
           if(candi_size(1)>0) % 有解
               % 随机选择一个
               candi_index = ceil(rand()*candi_size(1));
               index = gate_candidate(candi_index);
               
               if (index == Gate_nums+1) % 正常情况下选择了临时停机位=====
                   Solu(i, Gate_nums+1) = 1;
                   continue
               end
               
               
           else %无解的情况下，迫不得已选择临时停机位=====
               Solu(i, Gate_nums+1) = 1;
               continue
           end

           Solu(i,index) = 1;
           
           in_time = Flight_table(i, 1);       %该航班到时间
           out_time = Flight_table(i, 2) + 45; %该航班离开时间 + 45 
           Gate_time_net(in_time:out_time-1, index) = 1; % 45空间还可以用====================
           
           Gate_time(index) = Flight_table(i, 2) + 45;   
           
        end
    end
%%}
      