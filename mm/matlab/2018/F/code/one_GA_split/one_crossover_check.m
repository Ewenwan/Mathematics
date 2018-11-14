%%{ 
% 交叉
% in： 交叉后的解 solu_cros ，航班表 Flight_table，登机口类型表 Gate_table，交叉点 cros_point
% 单点交叉  k之后的基因全部 交换
function [solu_cros_check] = one_crossover_check(solu_cros, Flight_table, Gate_table, cros_point)
    FS = size(Flight_table);
    GS = size(Gate_table);
    Flight_nums = FS(1);      % 航班数量   基因数量
    Gate_nums = GS(2);        % 登机口数量
    solu_cros_check = solu_cros; % 初始化 交叉 核查 后的解
    
% 检查 不可行解，用 变异 产生 可行解 ======================================== 
    % 产生 交叉点前的 Gate_time
    Gate_time = zeros(1, Gate_nums);% 门最后空闲时间
    for k = 1 : cros_point-1 
        index = solu_cros(k,1); % 本航班被分配的登机口 有可能为临时停机口 Gate_nums+1
        if(index <= Gate_nums)
           Gate_time(index) = Flight_table(k, 2) + 45; 
        end
    end
    
    % 
    for i = cros_point:Flight_nums % 检查 交叉后的 基因 不合适的重新产生
        gate_candidate = [];
        for j = 1:Gate_nums %遍历每一个登机口，看哪一些合适
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
        
       %% 检查 原基因点 是否可行 
        index_src = solu_cros(i,1);% 原基因点
        if( sum(gate_candidate == index_src) > 0) % 该基因点 已经合适，不用重新产生
		    Gate_time(index_src) = Flight_table(i, 2) + 45;% 更新登机口 空闲时间
            continue; % 跳过 该 合适的 基因点
        end
        
        %% 原 基因点 不合适， 变异产生新的 基因点
        candi_size = size(gate_candidate);
        if(candi_size(1)>0) % 有解
           % 随机选择一个
           candi_index = ceil(rand()*candi_size(1));
           index_selt = gate_candidate(candi_index); % 选择一个 对应的固定登机口 id
           if(candi_size(1)>=2) % 有两个以上的候选登机口
               solu_cros_check(i, 1+1) = 1; % 标注为  可变异点
           end

        else %无解
           solu_cros_check(i, 1) = Gate_nums+1;% 选择临时登机口
           continue
        end
     
        solu_cros_check(i,1) = index_selt;% 选择该登机口
        Gate_time(index_selt) = Flight_table(i, 2) + 45;% 更新登机口 空闲时间
    end

end
%%}
      