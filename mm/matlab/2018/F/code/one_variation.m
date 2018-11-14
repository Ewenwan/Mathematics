%%{ 
% 返回变异后的解，以及 其 临时口使用数量 和 固定扣空闲数量
function [Solu_vari, Temp_gate_num, Gate_free_num] = one_variation(Solu_soure, Flight_table, Gate_table)
        %% 窄求解 N 
        FS = size(Flight_table);
        GS = size(Gate_table);
        Flight_nums = FS(1); %航班数量
        Gate_nums = GS(2);   %登机口数量
        Solu_vari = Solu_soure; % 初始化变异个体
        
        Gate_time = zeros(1, Gate_nums);% 门最后空闲时间
        
        vari_point =  ceil(rand()*Flight_nums); 
        while(~Solu_soure(vari_point,Gate_nums+1+1))
            vari_point =  ceil(rand()*Flight_nums); % 产生合适的变异点
        end

        for i = 1 : vari_point-1 % 产生变异点前的 Gate_time
            index = find(Solu_soure(i,1:Gate_nums) == 1);% 本航班被分配的登机口
            %if(index <= Gate_nums)
               Gate_time(index) = Flight_table(i, 2) + 45; 
            %end
        end

        for i = vari_point:Flight_nums % 之后变异产生新的个体
            
           gate_candidate = [];
           for j = 1:Gate_nums %遍历每一个登机口，看哪一个合适
               f1 = ((Flight_table(i,3)==0)&&((Gate_table(1,j)==1)));
               f2 = ((Flight_table(i,3)==1)&&((Gate_table(1,j)==0)));
               f3 = ((Flight_table(i,4)==0)&&((Gate_table(2,j)==1)));
               f4 = ((Flight_table(i,4)==1)&&((Gate_table(2,j)==0)));

               f5 = ( Flight_table(i, 1) <= Gate_time(j));% 45分钟可用
               
               if( f1 || f2 || f3 || f4 || f5 ) %不合适
               else % 合适
                   gate_candidate = [gate_candidate; j]; % 合适的存放起来
               end
           end
           candi_size = size(gate_candidate);

           if(candi_size(1)>0) % 有解
               % 随机选择一个
               candi_index = ceil(rand()*candi_size(1));
               index = gate_candidate(candi_index);
               if(candi_size(1)>=2) % 有两个以上的候选登机口
                   Solu_vari(i, Gate_nums+1+1) = 1; % 可变异点
               end
               
           else %无解
               Solu_vari(i, Gate_nums+1) = 1;
               continue
           end

           Solu_vari(i,index) = 1;% 选择该登机口
           Gate_time(index) = Flight_table(i, 2) + 45;% 更新登机口 空闲时间
        end
        
        
        Temp_gate_num = sum(Solu_vari(:,Gate_nums+1));  % 临时口 使用数量   少
        Gate_free_num = 0;
        for j=1:Gate_nums
                if sum(Solu_vari(:,j))==0 % 未占用
                    Gate_free_num=Gate_free_num+1;% 未占用数量     固定口 空闲数量   多
                end
        end
             
end
%%}
      