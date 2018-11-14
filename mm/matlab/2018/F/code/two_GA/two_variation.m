%%{ 
% 返回变异后的解，以及 其 临时口使用数量 和 固定扣空闲数量
function [Solu_vari] = two_variation( Solu_soure, Flight_table, Gate_table) %求解1次
        FS = size(Flight_table);
        GS = size(Gate_table);
        %TS = size(Ticket_table);
        Flight_nums = FS(1); % 航次数量   303 
        Gate_nums = GS(2);   % 登机口数量 69    70 为临时登机口
        %Ticket_nums = TS(1); % 机票 票次数量 1649
        
        Solu_vari = Solu_soure; % 初始化变异个体
       
        Gate_time = zeros(1, Gate_nums);% 1*69  登机口 最后空闲时间
 
        % 变异点
        vari_point =  ceil(rand()*(Flight_nums-1)); 
        while(~Solu_soure(vari_point, 1+1))         % 第二列为 是否可以 变异
            vari_point =  ceil(rand()*(Flight_nums-1)); % 产生合适的变异点 1 ~ N-1
        end

        for k = 1 : vari_point-1 % 产生变异点前的 Gate_time
            index = Solu_soure(k,1); % 本航班被分配的登机口 有可能为临时停机口 Gate_nums+1
            if(index <= Gate_nums)
               Gate_time(index) = Flight_table(k, 2) + 45; 
            end
        end

        for i = vari_point:Flight_nums % 之后变异产生新的个体
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
               index1 = gate_candidate(candi_index);% 对应的固定登机口
               if(candi_size(1)>=3) % 有两个以上的候选登机口 ==========================
                   Solu_vari(i, 1+1) = 1; % 可变异点
               end
               
           else %无解
               Solu_vari(i, 1) = Gate_nums+1;% 选择临时登机口
               continue
           end

           Solu_vari(i,1) = index1; % 选择该登机口 index
           Gate_time(index1) = Flight_table(i, 2) + 45; % 更新登机口 空闲时间
        end           
end
%%}
      