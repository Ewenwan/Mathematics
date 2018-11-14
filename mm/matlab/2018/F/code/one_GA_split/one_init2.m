%%{ 
    function [Solu,Temp_gate_num, Gate_free_num] = one_init2(Flight_table, Gate_table)
        %% 窄求解 N 
        FS = size(Flight_table);
        GS = size(Gate_table);
        Flight_nums = FS(1); %航班数量
        Gate_nums = GS(2);   %登机口数量  N 45      W 24
        
        Solu = zeros(Flight_nums, 1+1); % 初始化解 门id + 可变异否
        
        Gate_time = zeros(1, Gate_nums);% 门最后空闲时间

        for i = 1:Flight_nums % 为每个航班选择登机口
            
           %i
           %
           %{
           % 剔除部分
           if(Gate_nums == 45) % N
               if((i==1) ||(i==2) || (i==3) || (i==4) || (i==7) || (i==11) || (i==24) || (i==31)|| (i==45)|| (i==68) )
                  Solu(i, Gate_nums+1) = 1;
                  continue     
               end
           end
           %}
           
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
               index = gate_candidate(candi_index);% 对应的固定登机口
               if(candi_size(1)>=2) % 有两个以上的候选登机口
                   Solu(i, 1+1) = 1; % 可变异点
               end
               
           else %无解
               Solu(i, 1) = Gate_nums+1;% 选择临时登机口
               continue
           end

           Solu(i,1) = index; % 选择该登机口 index
           Gate_time(index) = Flight_table(i, 2) + 45; % 更新登机口 空闲时间
           
        end
		
        Temp_gate_num = sum( Solu(:,1) == Gate_nums+1 );  % 临时口 使用数量   少
        Gate_free_num = 0;
        for j=1:Gate_nums
                if sum( Solu(:,1) == j ) == 0 % 未占用
                    Gate_free_num = Gate_free_num+1;% 未占用数量     固定口 空闲数量   多
                end
        end
        
        
    end
%%}
      